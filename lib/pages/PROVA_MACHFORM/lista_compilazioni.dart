import 'package:flutter/material.dart';
import 'package:music/database/client_operations.dart';
import 'package:music/database/machform_operations.dart';
import 'package:music/models/machform_models/machform.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/pages/common_widget/error_page.dart';
import 'package:music/provider/user_provider.dart';
import 'package:provider/provider.dart';

import 'compilazione_machform.dart';
import 'provider/machform_provider.dart';

class ListaCompilazioni extends StatelessWidget {
  const ListaCompilazioni({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Le tue Compilazioni"),
      ),
      body: FutureBuilder(
        future: MachFormOperations.getUserMachformCompilati(
            context.read<UserProvider>().currentUser!.internalAccount.id),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snap.hasError) {
            return ErrorPage(error: snap.error.toString());
          }

          final List<Map<String, Object?>> compilazioni =
              snap.data as List<Map<String, Object?>>;

          if (compilazioni.isEmpty) {
            return EmptyPage(title: "Non hai Compilazioni");
          }

          return ListView.builder(
              itemCount: compilazioni.length,
              itemBuilder: (context, i) {
                print("ecco comp: ${compilazioni[i]}");
                return ListTile(
                  title: Text(compilazioni[i]['form_name'].toString()),
                  subtitle: Text(compilazioni[i]['client_name'].toString()),
                  leading: Text(compilazioni[i]['datetime'].toString()),
                  onTap: () async {
                    //apro pagina per visualizzare la compilazione !
                    final Map<String, Object?> risultatoCompilazione =
                        await MachFormOperations.getCompilationById(
                      compilazioni[i]['form'] as int,
                      compilazioni[i]['id_form'] as int,
                    );

                    final apForm = await MachFormOperations.getFormById(
                        compilazioni[i]['form'] as int);

                    final currentClient = await ClienteOperations.readCliente(
                        compilazioni[i]['id_assistito'] as int);

                    debugPrint("ecco result: $risultatoCompilazione");

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider<MachFormProvider>(
                          create: (context) => MachFormProvider(
                            machForm: apForm!,
                            currentClient: currentClient,
                            compilazioniValues: risultatoCompilazione,
                          ),
                          child: CompilazioneMachForm(
                            machForm: apForm!,
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
