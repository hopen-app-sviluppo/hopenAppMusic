import 'package:flutter/material.dart';
import 'package:music/helpers.dart';
import 'package:music/models/cliente.dart';
import 'package:music/models/compilazione_form.dart';

import 'package:music/pages/assistito_pages/lista_assistiti_page/widgets/lista_assistiti.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/pages/common_widget/error_page.dart';
import 'package:music/pages/grafici_pages/helpers/enums.dart';
import 'package:music/pages/grafici_pages/helpers/grafici_client_provider.dart';
import 'package:music/pages/grafici_pages/views/grafico_eta_musicale.dart';
import 'package:music/pages/grafici_pages/views/grafico_mood_musicofilia.dart';
import 'package:music/pages/grafici_pages/widgets/btn_save_pdf.dart';
import 'package:music/pages/grafici_pages/widgets/dropdown_btn.dart';
import 'package:music/router.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

//*Pagina che mostra i grafici relative alle compilazioni di un assistito
class GraficiPage extends StatelessWidget {
  const GraficiPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Selector<GraficiClientProvider, Cliente?>(
        selector: (context, graphProv) => graphProv.currentClient,
        builder: (context, cliente, _) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: FittedBox(
              child: Selector<GraficiClientProvider, GraphicType?>(
                selector: (ctx, grafProv) => grafProv.graphType,
                builder: (ctx, type, _) =>
                    Text(ctx.read<GraficiClientProvider>().getAppBarText()),
              ),
            ),
            actions: [
              Selector<GraficiClientProvider, List<CompilazioneForm>?>(
                selector: (context, prov) => prov.selectedComps,
                builder: (context, comps, _) {
                  if (comps == null || comps.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  //ho le compialzioni, quindi ho i 3 grafici in memoria
                  return const BtnSavePdf();
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: cliente == null
                ? _buildChooseBody(context)
                : _buildBody(context, cliente),
          ),
        ),
      );

//Pagina mostrata quando ancora l'assistito non è stato scelto :P
  Widget _buildChooseBody(BuildContext context) {
    return ListaAssistiti(
      showListView: true,
      isShowingGraphicPage: true,
      ctx: context,
    );
  }

//!assistito scelto
  Widget _buildBody(BuildContext context, Cliente cliente) =>
      Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        //button scegli assistito, button scegli compilazione
        Expanded(flex: 1, child: _buildHeader(context, cliente)),
        //grafici page
        Expanded(
          flex: 9,
          child: context.read<GraficiClientProvider>().allCompilazioni ==
                      null ||
                  context.read<GraficiClientProvider>().allCompilazioni!.isEmpty
              ? EmptyPage(
                  title: "${cliente.nome} non ha compilazioni !",
                  btnText: "Compila un form !",
                  onBtnPressed: () =>
                      Navigator.of(context).pushReplacementNamed(
                    AppRouter.sceltaFormPage,
                    arguments: cliente,
                  ),
                )
              : _buildContent(context),
        ),
      ]);

  Widget _buildHeader(BuildContext context, Cliente cliente) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //se accedo alla pagina dal profilo assistito => non devo sceglierlo !
          //Se invece accedo alla page dal profilo utente => allora deve scegliere l'assistito dalla lista
          Expanded(
            child: context.read<GraficiClientProvider>().isAssistitoProfile
                ? Text(cliente.nome + " " + cliente.cognome)
                : const Card(
                    color: Colors.white,
                    child: DropdownBtn(),
                  ),
          ),
          Expanded(
            child: Selector<GraficiClientProvider, List<CompilazioneForm>?>(
                //ribuilda quando aggiorno le date dai button
                selector: (context, graphProv) => graphProv.selectedComps,
                builder: (context, selectedComp, _) {
                  if (selectedComp == null) return const SizedBox.shrink();
                  return TextButton.icon(
                    label: const Text("Compilazioni"),
                    icon: const Icon(Icons.edit),
                    onPressed: () => showBtmSheet(context),
                  );
                }),
          ),
        ],
      );

//* assistito scelto e ha compilazioni del form musicoterapia
  Widget _buildContent(BuildContext context) =>
      Selector<GraficiClientProvider, List<CompilazioneForm>?>(
        selector: (context, graphProv) => graphProv.selectedComps,
        builder: (context, selectedComps, _) {
          //* non sono state selezionate compilazioni
          if (selectedComps == null || selectedComps.isEmpty) {
            return EmptyPage(
              title: "",
              btnText: "Seleziona almeno una compilazione !",
              onBtnPressed: () => showBtmSheet(context),
            );
          }
          return _buildPage(selectedComps, context);
        },
      );

  //torna un grafico
//* Inserisco un Page view, in modo da esportare in PDF tutti i grafici
  Widget _buildPage(
    List<CompilazioneForm> compilazioni,
    BuildContext context,
  ) {
    return FutureBuilder(
        //inizializzo i 3 grafici
        future: context
            .read<GraficiClientProvider>()
            .initializeGraphics(compilazioni),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snap.hasError) {
            return ErrorPage(error: snap.error as String? ?? "Errore");
          }

          //* ho creato tutti e 3 i grafici
          return Selector<GraficiClientProvider, GraphicType>(
            selector: (context, grafProv) => grafProv.graphType!,
            builder: (context, type, _) => Column(
              children: [
                //pulsantini per scegliere il grafico
                _buildChoiceChips(context, type),
                //! Grafico
                Expanded(
                  child: _graphicPage(type), //index cambia in base al type
                ),
              ],
            ),
          );
        });
  }

//pulsantini per scegliere il grafico
  Widget _buildChoiceChips(BuildContext context, GraphicType type) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ChoiceChip(
            label: const Text("Età Musicale"),
            selected: type == GraphicType.eta,
            selectedColor: MainColor.secondaryColor,
            onSelected: (isSelected) {
              if (isSelected) {
                context
                    .read<GraficiClientProvider>()
                    .updateGraphicType(GraphicType.eta);
              }
            },
          ),
          ChoiceChip(
            label: const Text("Mood"),
            selected: type == GraphicType.mood,
            selectedColor: MainColor.secondaryColor,
            onSelected: (isSelected) {
              if (isSelected) {
                context
                    .read<GraficiClientProvider>()
                    .updateGraphicType(GraphicType.mood);
              }
            },
          ),
          ChoiceChip(
            label: const Text("Musicofilia"),
            selected: type == GraphicType.musocifilia,
            selectedColor: MainColor.secondaryColor,
            onSelected: (isSelected) {
              if (isSelected) {
                context
                    .read<GraficiClientProvider>()
                    .updateGraphicType(GraphicType.musocifilia);
              }
            },
          ),
        ],
      );

  Widget _graphicPage(GraphicType type) {
    switch (type) {
      case GraphicType.eta:
        return const GraficoEtaMusicale();
      case GraphicType.mood:
        return const GraficoMoodMusicofilia(
          isMood: true,
        );
      case GraphicType.musocifilia:
        return const GraficoMoodMusicofilia(
          isMood: false,
        );
    }
  }

  void showBtmSheet(BuildContext context) {
    Scaffold.of(context).showBottomSheet<void>(
      (BuildContext context) => _buildBottomSheet(
          context, context.read<GraficiClientProvider>().allCompilazioni!),
    );
  }

  Widget _buildBottomSheet(BuildContext context, List<CompilazioneForm> comps) {
    Set<CompilazioneForm> selectedComps = {};
    return StatefulBuilder(builder: (context, StateSetter newState) {
      return SingleChildScrollView(
        child: Column(children: [
          ...List.generate(
            comps.length,
            (i) {
              final bool isSelected = selectedComps.contains(comps[i]);
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: isSelected
                            ? MainColor.secondaryColor
                            : MainColor.primaryColor,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor:
                          isSelected ? MainColor.secondaryColor : Colors.white,
                      child: Text("${i + 1}"),
                    ),
                    title: const Text("Compilazione del"),
                    subtitle: Text(formatHour(comps[i].creatoIl)),
                    trailing: Icon(
                      isSelected ? Icons.favorite : Icons.favorite_outline,
                      color: MainColor.secondaryColor,
                    ),
                    onTap: () {
                      if (isSelected) {
                        selectedComps.remove(comps[i]);
                      } else {
                        selectedComps.add(comps[i]);
                      }
                      newState(() {});
                    }),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton.icon(
              label: const Text("Conferma !"),
              icon: const Icon(Icons.check),
              onPressed: () {
                context.read<GraficiClientProvider>().updateSelectedComps(
                      selectedComps.toList(),
                    );
                Navigator.of(context).pop();
              },
            ),
          ),
        ]),
      );
    });
  }
}
