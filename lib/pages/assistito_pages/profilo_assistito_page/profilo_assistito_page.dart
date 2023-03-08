import 'package:flutter/material.dart';
import 'package:music/database/form_operations.dart';
import 'package:music/pages/common_widget/immagine_profilo.dart';
import 'package:music/router.dart';
import 'package:provider/provider.dart';
import '../../../helpers.dart';
import '../../../models/cliente.dart';
import '../../../provider/user_provider.dart';
import '../../../theme.dart';
// valutare se mettere un provider per l'assistito corrente
//mi eviterebbe tutto il passaggio del parametro
//Quando apro profilo assistito, aggiorno l'assistito corrente, e prendo direttamente quello

//* pagina dettaglio assistito !
class ProfiloAssistitoPage extends StatelessWidget {
  final Cliente assistito;
  const ProfiloAssistitoPage({
    Key? key,
    required this.assistito,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      );

  AppBar _buildAppBar(BuildContext context) => AppBar(
        title: Text("Profilo di ${assistito.nome}"),
        centerTitle: true,
      );

  Widget _buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(flex: 3, child: _buildImmagineProfilo(context)),
            Expanded(flex: 1, child: _buildCredenziali(context)),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 9,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTitle("Panoramica", Icons.timeline_outlined),
                            _buildNumeroCompilazioni(context),
                          ]),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Expanded(
                    flex: 9,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTitle("Azioni", Icons.touch_app_outlined),
                            _buildDecoration(
                              child: _buildBtnGrafici(context),
                            ),
                            _buildDecoration(
                              child: _buildBtnCompilaForm(context),
                            ),
                            _buildDecoration(
                              child: _buildBtnCompilazioniFatte(context),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildImmagineProfilo(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImmagineProfilo(
            //  width: MediaQuery.of(context).size.width * 0.10,
            //  height: MediaQuery.of(context).size.width * 0.10,
            sigla: assistito.sigla,
            backgroundColor: assistito.sesso == "maschio"
                ? Colors.blue.withOpacity(0.3)
                : assistito.sesso == "femmina"
                    ? Colors.purple
                    : Colors.grey,
          ),
          Text("${assistito.nome} ${assistito.cognome}"),
        ],
      );

  Widget _buildCredenziali(BuildContext context) => Align(
        alignment: Alignment.topRight,
        child: TextButton(
          child: const Text(
            "Credenziali",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
          onPressed: () => Navigator.of(context)
              .pushNamed(AppRouter.credenziali, arguments: assistito),
        ),
      );

  Widget _buildTitle(String text, IconData iconData) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(iconData),
          Expanded(
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildNumeroCompilazioni(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.check_outlined),
          Expanded(
            child: FutureBuilder(
                future: FormOperations.countClientCompilazioni(
                    assistito.userId, assistito.id!),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  if (snap.hasError) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        snap.data.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Compilazioni"),
                    ],
                  );
                }),
          )
        ],
      );

  Widget _buildDecoration({required Widget child}) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: MainColor.secondaryColor),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: child,
      );

  Widget _buildBtnGrafici(BuildContext context) => TextButton(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Icon(Icons.pie_chart_outline),
          Expanded(
              child: Center(child: Text("Grafici per ${assistito.sigla}"))),
        ]),
        onPressed: () async {
          try {
            final compilazioni =
                await FormOperations.getAllAssistitoCompilations(
                    context.read<UserProvider>().currentUser!.id,
                    assistito.id!);
            Navigator.of(context).pushNamed(
              AppRouter.grafici,
              arguments: [true, assistito, compilazioni],
            );
          } catch (e) {
            showSnackBar(context, "Errore Indesiderato !");
          }
        },
      );

  Widget _buildBtnCompilaForm(BuildContext context) => TextButton(
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Icon(Icons.edit_outlined),
          Expanded(
              child:
                  Center(child: Text("Compila form\nper ${assistito.sigla}"))),
        ]),
        onPressed: () => Navigator.of(context).pushNamed(
          AppRouter.sceltaFormPage,
          arguments: assistito,
        ),
      );

  Widget _buildBtnCompilazioniFatte(BuildContext context) => TextButton(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(Icons.visibility),
              Expanded(child: Center(child: Text("Compilazioni"))),
            ]),
        onPressed: () => Navigator.of(context).pushNamed(
          AppRouter.formListPage,
          arguments: assistito,
        ),
      );
}
