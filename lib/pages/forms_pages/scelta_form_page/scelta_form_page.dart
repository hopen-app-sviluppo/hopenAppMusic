import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/models/form_assistito.dart';
import 'package:provider/provider.dart';
import '../../../models/cliente.dart';
import '../../common_widget/list_item.dart';
import '../compilazione_form_page/helpers/compilazione_form_provider.dart';
import '../compilazione_form_page/compilazione_form_page.dart';

//* pagina che mostra la lista dei form da compilare
class SceltaFormPage extends StatelessWidget {
  final Cliente? cliente;
  const SceltaFormPage({
    Key? key,
    this.cliente,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? nomeCliente = cliente == null
        ? 'Scegli un form per la compilazione'
        : 'Compila un form per ${cliente!.nome}';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(nomeCliente),
      ),
      body: _buildBody(context),
    );
  }

//TODO: chiamata API per ottenere la lista dei Forms
  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        //? MUSICOTERAPIA
        ListItem(
          height: MediaQuery.of(context).size.height * 0.12,
          leadingTitle: "Musicoterapia",
          title: "Form che riguarda musicoterapia",
          leadingIcon: const Icon(Icons.music_note_outlined, size: 40),
          onTap: () async {
            //todo: chiamata api per prendermi questo Form in json
            final String formMusic =
                await rootBundle.loadString('assets/musicoterapia.json');
            final Map<String, dynamic> response = json.decode(formMusic);
            final frm = FormAss.fromJson(response);
            Navigator.of(context).push(
              MaterialPageRoute(
                //TODO
                //! ogni form ha il suo oggetto instanziato !, magari faccio subuto un check (quando compilo form pulisco tutto)
                //! se vado su un form e ho già un'istanza non nulla, gli dico se vuole caricarlo oppure riniziare da capo
                //! se vuole caricarlo allora glielo passo come paramentro, alrimenti parto da zero
                builder: (context) => ChangeNotifierProvider(
                  //assegno alla classe provider il form scelto !
                  create: (context) => CompilazioneFormProvider(
                    currentForm: frm,
                    isCompilingForm: true,
                    cliente: cliente,
                  ),
                  child: const CompilazioneFormPage(),
                ),
              ),
            );
          },
        ),

        //? diario MUSICOTERAPIA
        ListItem(
          height: MediaQuery.of(context).size.height * 0.12,
          leadingTitle: "Diario Musicoterapia",
          title: "Diario della musicoterapia",
          leadingIcon: const Icon(
            Icons.menu_book,
            size: 40,
          ),
          onTap: () async {
            //todo: chiamata api per prendermi questo Form in json
            final String formMusic =
                await rootBundle.loadString('assets/diario_mus.json');
            final Map<String, dynamic> res = json.decode(formMusic);
            final form = FormAss.fromJson(res);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  //assegno alla classe provider il form scelto !
                  create: (context) => CompilazioneFormProvider(
                    currentForm: form,
                    isCompilingForm: true,
                    cliente: cliente,
                  ),
                  child: const CompilazioneFormPage(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
