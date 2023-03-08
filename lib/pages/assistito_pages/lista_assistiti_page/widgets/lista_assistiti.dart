import 'package:flutter/material.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/pages/common_widget/list_item.dart';
import 'package:music/pages/grafici_pages/helpers/grafici_client_provider.dart';
import 'package:music/provider/user_provider.dart';
import 'package:music/router.dart';
import 'package:provider/provider.dart';

import '../../../../models/cliente.dart';
import '../../../common_widget/error_page.dart';
import '../../../common_widget/grid_item.dart';
import '../../../forms_pages/compilazione_form_page/helpers/compilazione_form_provider.dart';

//a questo widget ci accedo:
//1 - da pagina compilazione Form => quando devo scegliere l'assistito per cui compilare il form
//2 - da pagina lista assistiti => quando devo solo leggere gli assistiti del terapista

class ListaAssistiti extends StatelessWidget {
  //se clicco su assistito => apro pagina profilo o lo scelgo per selezionare il form.
  final bool isChoosingClient;
  final bool isShowingGraphicPage;
  final BuildContext? ctx;
  //mostro una lista o una griglia? dipende
  final bool showListView;
  //* Se isChoosingClient è true, devo passargli anche il context, altrimenti no !
  const ListaAssistiti({
    Key? key,
    this.isChoosingClient = false,
    this.isShowingGraphicPage = false,
    required this.showListView,
    this.ctx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: context.read<UserProvider>().getClients(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snap.hasError) {
          final String error = snap.error.toString();
          return ErrorPage(error: error);
        }

        final List<Cliente> clients = snap.data as List<Cliente>;
        if (clients.isEmpty) {
          return EmptyPage(
            title: "Non hai Assistiti !",
            btnText: isShowingGraphicPage ? "Creane uno !" : null,
            onBtnPressed: isShowingGraphicPage
                ? () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRouter.creaAssistito, (route) => route.isFirst)
                : null,
          );
        }
        if (showListView) {
          return _buildListView(clients);
        } else {
          //todo per ora non viene utilizzata
          return GridView(
            //padding: const EdgeInsets.all(5.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
            ),
            children: clients
                .map((e) => GridItem(
                      title: "${e.nome} ${e.cognome}",
                      leadingIcon: const Icon(Icons.man_outlined),
                      onTap: () {
                        if (isChoosingClient) {
                          /*aggiorno cliente scelto per compilazione form*/
                          ctx!
                              .read<CompilazioneFormProvider>()
                              .updateCliente(e);
                          /*esco dallo showDialog*/
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pushNamed(
                              AppRouter.profiloAssistito,
                              arguments: e);
                        }
                      },
                    ))
                .toList(),
          );
        }

        /*   return ListTile(
                  title: Text(clients[index].nome),
                  onTap: () {
                    if (isChoosingClient) {
                      /*aggiorno cliente scelto per compilazione form*/
                      ctx!
                          .read<CompilazioneFormProvider>()
                          .updateCliente(clients[index]);
                      /*esco dallo showDialog*/
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushNamed(
                          AppRouter.profiloAssistito,
                          arguments: clients[index]);
                    }
                  });*/
      });
  Widget _buildListView(List<Cliente> clients) => ListView.builder(
      itemCount: clients.length,
      itemBuilder: (context, index) {
        final currentClient = clients[index];
        return ListItem(
          height: MediaQuery.of(context).size.height * 0.08,
          title: "${currentClient.nome} ${currentClient.cognome}",
          leadingIcon: Icon(
            currentClient.sesso == "maschio"
                ? Icons.man_outlined
                : currentClient.sesso == "femmina"
                    ? Icons.woman_outlined
                    : Icons.person,
          ),
          onTap: () {
            if (isShowingGraphicPage) {
              context.read<GraficiClientProvider>().updateClient(
                    context.read<UserProvider>().currentUser!.id,
                    currentClient,
                  );
              return;
            }
            if (isChoosingClient) {
              /*aggiorno cliente scelto per compilazione form*/
              ctx!
                  .read<CompilazioneFormProvider>()
                  .updateCliente(currentClient);
              /*esco dallo showDialog*/
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushNamed(AppRouter.profiloAssistito,
                  arguments: currentClient);
            }
          },
        );
      });
}
