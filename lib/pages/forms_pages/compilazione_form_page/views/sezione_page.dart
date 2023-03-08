import 'package:flutter/material.dart';
import 'package:music/models/form_assistito.dart';
import 'package:music/provider/settings_provider.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

import '../../../../models/cliente.dart';
import '../../../assistito_pages/lista_assistiti_page/widgets/lista_assistiti.dart';
import '../helpers/compilazione_form_provider.dart';
import '../helpers/compilazione_type.dart';
import '../widgets/domanda_box.dart';

class SezionePage extends StatelessWidget {
  const SezionePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Sezione sezioneCorrente =
        context.read<CompilazioneFormProvider>().currentSection;
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, sezioneCorrente),
        SliverList(
          delegate: SliverChildListDelegate(
            _buildDomande(sezioneCorrente),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Sezione sezioneCorrente) =>
      SliverAppBar(
        pinned: true,
        backgroundColor: MainColor.secondaryColor,
        //disabilito pulsante back
        leading: const SizedBox.shrink(),
        expandedHeight: MediaQuery.of(context).size.height * 0.2,
        //   context.read<CompilazioneFormProvider>().currentForm.formId == 0
        //       ? sezioneCorrente.imagePath != null
        //           ? MediaQuery.of(context).size.height * 0.7
        //           : MediaQuery.of(context).size.height * 0.3
        //       : MediaQuery.of(context).size.height * 0.25,
        flexibleSpace: _buildFlexibleSpace(context, sezioneCorrente),
      );

  Widget _buildFlexibleSpace(
    BuildContext context,
    Sezione sezioneCorrente,
  ) {
    final double paddingTop = MediaQuery.of(context).padding.top;
    return Container(
      margin: EdgeInsets.only(top: paddingTop),
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(builder: (context, cons) {
        final barHeight = cons.maxHeight;
        final appBarHeight = kToolbarHeight + paddingTop + 15.0;
        //se non è espanso
        if (barHeight <= appBarHeight) {
          return _buildTitleDescription(context, sezioneCorrente);
        }
        //se è espanso
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //nome Form
            Expanded(
              flex: 1,
              child: _buildTitleDescription(context, sezioneCorrente),
            ),
            //* Immagine

            //      if (context.read<CompilazioneFormProvider>().currentForm.formId ==
            //              0 &&
            //          sezioneCorrente.imagePath != null)
            //        Expanded(
            //          flex: 20,
            //          child: Container(
            //            decoration: BoxDecoration(
            //              image: DecorationImage(
            //                image: AssetImage(sezioneCorrente.imagePath!),
            //                fit: BoxFit.contain,
            //              ),
            //            ),
            //          ),
            //        ),
            //bottone scegli assistito - Punteggio Sezione
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (context.read<CompilazioneFormProvider>().compType ==
                      CompilazioneType.writing)
                    Selector<CompilazioneFormProvider, Cliente?>(
                      selector: (context, compProv) => compProv.cliente,
                      builder: (ctx, client, _) =>
                          _buildAssistitoNome(context, client),
                    )
                  else
                    Text(
                      context.read<CompilazioneFormProvider>().cliente!.nome +
                          " " +
                          context
                              .read<CompilazioneFormProvider>()
                              .cliente!
                              .cognome,
                      style: const TextStyle(color: Colors.white),
                    ),
                  if (sezioneCorrente.maxScore != null)
                    Selector<CompilazioneFormProvider, int>(
                      selector: (context, comp) => comp.currentSection.score,
                      builder: (_, score, __) {
                        return Center(
                          child: Text(
                            "Punteggio Sezione:\n$score / ${sezioneCorrente.maxScore}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

//titolo sezione e icon Help => apre descrizione sezione
  Widget _buildTitleDescription(
          BuildContext context, Sezione sezioneCorrente) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              final bool? result = await vuoiUscireDalForm(context);
              if (result != null && result) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            child: const Icon(
              Icons.home,
              color: MainColor.primaryColor,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                sezioneCorrente.sezioneTitle,
                style: const TextStyle(fontWeight: FontWeight.bold
                    // color: MainColor.primaryColor,
                    ),
              ),
            ),
          ),
          if (sezioneCorrente.sezioneDesc != "")
            InkWell(
              onTap: () => mostraTutorialSezione(context, sezioneCorrente),
              child: const Icon(
                Icons.help,
                color: MainColor.primaryColor,
              ),
            ),
        ],
      );

//Se non è stato scelto il cliente, compare il bottone per sceglerlo, altrimenti compare il nome dell'assistito e un icona per sceglierne un altro
  Widget _buildAssistitoNome(BuildContext context, Cliente? client) =>
      Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: MainColor.primaryColor),
            borderRadius: BorderRadius.circular(25.0)),
        child: TextButton.icon(
          label: Text(
            client == null
                ? "Seleziona Assistito"
                : "${client.nome} ${client.cognome}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: const Icon(Icons.edit_outlined),
          onPressed: () async => await chooseAssistito(context),
        ),
      );

  List<Widget> _buildDomande(Sezione sezioneCorrente) {
    List<Widget> widgets = [];
    for (int i = 0; i < sezioneCorrente.domande.length; i++) {
      final domanda = sezioneCorrente.domande[i];
      widgets.add(DomandaBox(domanda: domanda));
    }
    return widgets;
  }

  Future<void> chooseAssistito(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              backgroundColor: MainColor.primaryColor.withOpacity(0.9),
              title: const Text("Scegli Assistito "),
              elevation: 10.0,
              content: SizedBox(
                  height: context
                          .read<SettingsProvider>()
                          .config
                          .safeBlockVertical *
                      50,
                  width: context
                          .read<SettingsProvider>()
                          .config
                          .safeBlockHorizontal *
                      70,
                  child: ListaAssistiti(
                    ctx: context,
                    isChoosingClient: true,
                    showListView: true,
                  )),
              actions: [
                TextButton(
                  child: const Text("Chiudi"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ));
  }

//cliccando sul punto interrogativo appare la spiegazione di quella sezione
  Future<void> mostraTutorialSezione(
          BuildContext context, Sezione sezioneCorrente) async =>
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: MainColor.primaryColor.withOpacity(0.9),
          content: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                sezioneCorrente.sezioneDesc,
                textAlign: TextAlign.justify,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          )),
          actions: [
            TextButton(
              child: const Text("Chiudi"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );

  Future<bool?> vuoiUscireDalForm(BuildContext context) async =>
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: MainColor.primaryColor,
          title: const Text(
            "Sei sicuro di interrompere la compilazione ?",
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            "Il tuo lavoro non verrà salvato !",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: const Text("Annulla"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Torna alla Home !"))
          ],
        ),
      );
}
