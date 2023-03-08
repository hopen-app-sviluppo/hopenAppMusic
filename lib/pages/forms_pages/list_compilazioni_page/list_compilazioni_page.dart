import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/database/client_operations.dart';
import 'package:music/models/cliente.dart';
import 'package:music/models/compilazione_form.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/pages/common_widget/error_page.dart';
import 'package:music/helpers.dart';
import 'package:music/provider/user_provider.dart';
import 'package:music/router.dart';
import 'package:provider/provider.dart';

import '../../../database/form_operations.dart';
import '../../../models/form_assistito.dart';
import '../../common_widget/list_item.dart';
import '../compilazione_form_page/compilazione_form_page.dart';
import '../compilazione_form_page/helpers/compilazione_form_provider.dart';

//* Pagina che mostra la lista dei Form  => o compilati dall'utente oppure compilati per l'assistito
class ListCompilazioniPage extends StatelessWidget {
  //se true => mostro compilazioni fatte dal terapista, altrimenti mostro le compilazioni fatte per quell'utente
  final Cliente? cliente;
  const ListCompilazioniPage({
    Key? key,
    this.cliente,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context),
      );

  PreferredSizeWidget _buildAppBar() => AppBar(
        centerTitle: true,
        title: Text(cliente == null
            ? "Le tue compilazioni"
            : "Compilazioni di ${cliente!.nome}"),
      );

  Widget _buildBody(BuildContext context) => FutureBuilder(
        future: cliente == null
            ? FormOperations.getUserFormCompilati(
                context.read<UserProvider>().currentUser!.id,
              )
            : FormOperations.getAllAssistitoCompilations(
                context.read<UserProvider>().currentUser!.id,
                cliente!.id!,
              ),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snap.hasError) {
            return ErrorPage(error: snap.error.toString());
          }

          final forms = snap.data as List<CompilazioneForm>?;

          if (forms == null || forms.isEmpty) {
            return EmptyPage(
              title: cliente == null
                  ? "Non hai compilato Alcun Form !"
                  : "${cliente!.nome} non ha Compilazioni!",
              btnText: "Compila un form !",
              onBtnPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.sceltaFormPage,
                (route) => route.isFirst,
                arguments: cliente,
              ),
            );
          }
          /*  return GridView(
            padding: const EdgeInsets.all(5.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
            ),
            children: forms
                .map((e) => GridItem(title: "${e.assistitoName}", subTitle: ""))
                .toList(),
          );*/
          return ListView.builder(
            itemCount: forms.length,
            itemBuilder: (context, index) {
              final form = forms[index];
              return ListItem(
                height: MediaQuery.of(context).size.height * 0.12,
                title: form.assistitoName + " " + form.assistitoCognome,
                leadingSubTitle: form.formId == 0
                    ? "${form.score} / ${form.maxScore}"
                    : null,
                leadingTitle: form.formName,
                subTitle: "Creato il: ${formatHour(form.creatoIl)}",
                //thirdLine:
                //    "Ultima modifica: ${formatHour(form.ultimaModifica)}",
                leadingIcon: Icon(
                  form.formId == 0
                      ? Icons.music_note_outlined
                      : Icons.menu_book,
                  size: 40,
                ),
                onTap: () async {
                  final String formMusic = await rootBundle.loadString(
                      form.formId == 0
                          ? 'assets/musicoterapia.json'
                          : 'assets/diario_mus.json');
                  final Map<String, dynamic> response = json.decode(formMusic);
                  //prendo dati assistito
                  final cliente = await ClienteOperations.readCliente(
                    forms[index].assistitoId,
                  );
                  final domandeOnDb =
                      await getDomandeOnDb(forms[index].compilazioneId!);
                  //PER OGNI DOMANDA di tipo checkBox, mi prendo le sue risposte
                  //addScore(domandeOnDb, FormAss.fromJson(response));
                  // Apro pagina Compilazione Form in sola lettura
                  //ora ho le domande di tipo checkBox, mi prendo le risposte
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        //assegno alla classe provider il form scelto !
                        create: (context) => CompilazioneFormProvider(
                          currentForm: FormAss.fromJson(response),
                          isCompilingForm: false,
                          cliente: cliente,
                          domandeCompilateOnDb: domandeOnDb,
                        ),
                        child: const CompilazioneFormPage(),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      );

  Future<List<TableDomandaComp>> getDomandeOnDb(int compId) async {
    try {
      //checkare se compId è null?
      final List<TableDomandaComp> domandeComp =
          await FormOperations.getDomandeByCompilationId(compId);
      return domandeComp;
    } catch (e) {
      //allora mando un rethrow, appare snackbar errore e faccio navigator.pop
      rethrow;
    }
  }
}
