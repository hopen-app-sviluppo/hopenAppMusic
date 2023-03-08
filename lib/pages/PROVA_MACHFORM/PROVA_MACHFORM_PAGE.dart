//! PAGINA IN COSTRUZIONE

//TODO chiamata API sul network per ottenere la lista dei form che può vedere l'utente

//TODO: per ogni elemento possibilità di scaricarlo => a dx bottone Download rosso se non è presente già nel DB, altrimenti spunta verde (ce l'ho già), se nel DB interno esiste già un form con quell'id

//TODO: Premendo download, prendo il json del form, lo appoggio nei miei models, e lo butto nel DB interno

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/database/machform_operations.dart';
import 'package:music/models/machform_models/machform.dart';
import 'package:music/pages/PROVA_MACHFORM/compilazione_machform.dart';
import 'package:music/pages/PROVA_MACHFORM/lista_compilazioni.dart';
import 'package:music/pages/PROVA_MACHFORM/provider/machform_provider.dart';
import 'package:provider/provider.dart';
import '../../../../models/cliente.dart';
import '../common_widget/list_item.dart';

//* pagina che mostra la lista dei form da compilare
class ProvaMachform extends StatefulWidget {
  final Cliente? cliente;
  const ProvaMachform({
    Key? key,
    this.cliente,
  }) : super(key: key);

  @override
  State<ProvaMachform> createState() => _ProvaMachformState();
}

class _ProvaMachformState extends State<ProvaMachform> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    String? nomeCliente = widget.cliente == null
        ? 'Scegli un form per la compilazione'
        : 'Compila un form per ${widget.cliente!.nome}';
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(nomeCliente),
        leading: IconButton(
          icon: Icon(Icons.abc),
          onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ListaCompilazioni())),
        ),
      ),
      body: _buildBody(context),
    );
  }

//TODO: chiamata API per ottenere la lista dei Forms
  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        //? MUSICOTERAPIA
        //? diario MUSICOTERAPIA
        Row(children: [
          Text("CANCELLA DB"),
          Container(
            width: 100,
            height: 50,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await MachFormOperations.deleteForm();
              },
            ),
          ),
        ]),
        //! STEP 1 => SALVO FORM NEL DB INTERNO
        ListItem(
          height: MediaQuery.of(context).size.height * 0.12,
          leadingTitle: "Diario Musicoterapia",
          title: "Pulsante per caricare il JSON nel DB locale",
          leadingIcon: isLoading
              ? CircularProgressIndicator()
              : const Icon(
                  Icons.menu_book,
                  size: 40,
                ),
          onTap: () async {
            setState(() {
              isLoading = true;
            });
            //todo: chiamata api per prendermi questo Form in json
            final String diario = await rootBundle
                .loadString('assets/diario_musicoterapia_response.json');
            final Map<String, dynamic> res = json.decode(diario);
            print("ecco res: $res");
            //* in questo caso ho solo il diario di musicoterapia
            final diarioMus = MachForm.fromSocialNetwork(res['user_forms'][0]);
            print("ECCOCIIIII QUAAAAA");
            //! HO APPOGGIATO IL FORM NEI MIEI MODELS
            await MachFormOperations.saveFormToDB(diarioMus);
            print("FINITOOO");
            setState(() {
              isLoading = false;
            });
          },
        ),
        //! STEP 2 => PRENDO FORM DAL DB
        Row(children: [
          Text(
              "Pulsante per Prendere il Form dal DB \ne caricarlo nei miei Models"),
          Container(
            height: 80,
            width: 100,
            color: Colors.yellow,
            child: IconButton(
              icon: Icon(Icons.arrow_circle_right_rounded),
              onPressed: () async {
                //ottengo il form dal database ! e lo inserisco nei miei models
                final form = await MachFormOperations.getFormById(68336);
                if (form != null) {
                  print("finitoooo: ecco il form: $form");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<MachFormProvider>(
                        create: (context) => MachFormProvider(
                            machForm: form,),
                        child: CompilazioneMachForm(
                          machForm: form,
                        ),
                      ),
                    ),
                  );
                } else {
                  //TODO: GESTIRE ERRORE
                  print("errore nell'aprire il form dal DB");
                }
              },
            ),
          ),
        ]),
        SizedBox(height: 100, width: 200),
        ListItem(
          height: MediaQuery.of(context).size.height * 0.12,
          leadingTitle: "diario MODIFICATO da me",
          title: "Pulsante per caricare il JSON nel DB locale",
          leadingIcon: isLoading
              ? CircularProgressIndicator()
              : const Icon(
                  Icons.menu_book,
                  size: 40,
                ),
          onTap: () async {
            setState(() {
              isLoading = true;
            });
            //todo: chiamata api per prendermi questo Form in json
            final String diario =
                await rootBundle.loadString('assets/response_DIARIO_FAKE.json');
            final Map<String, dynamic> res = json.decode(diario);
            print("ecco res: $res");
            //* in questo caso ho solo il diario di musicoterapia
            final diarioMus = MachForm.fromSocialNetwork(res['user_forms'][0]);
            print("ECCOCIIIII QUAAAAA");
            //! HO APPOGGIATO IL FORM NEI MIEI MODELS
            await MachFormOperations.saveFormToDB(diarioMus);
            print("FINITOOO");
            setState(() {
              isLoading = false;
            });
          },
        ),
        //! STEP 2 => PRENDO FORM DAL DB
        Row(children: [
          Text(
              "Pulsante per Prendere il Form dal DB \ne caricarlo nei miei Models"),
          Container(
            height: 80,
            width: 100,
            color: Colors.yellow,
            child: IconButton(
              icon: Icon(Icons.arrow_circle_right_rounded),
              onPressed: () async {
                //ottengo il form dal database ! e lo inserisco nei miei models
                final form = await MachFormOperations.getFormById(123);
                if (form != null) {
                  print("finitoooo: ecco il form: $form");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<MachFormProvider>(
                        create: (context) => MachFormProvider(
                            machForm: form,),
                        child: CompilazioneMachForm(
                          machForm: form,
                        ),
                      ),
                    ),
                  );
                } else {
                  //TODO: GESTIRE ERRORE
                  print("errore nell'aprire il form dal DB");
                }
              },
            ),
          ),
        ]),

        //! FORM PROVA DROPDOWN
        ListItem(
          height: MediaQuery.of(context).size.height * 0.12,
          leadingTitle: "Form con il DROPDOWN da me",
          title: "Pulsante per caricare il JSON nel DB locale",
          leadingIcon: isLoading
              ? CircularProgressIndicator()
              : const Icon(
                  Icons.menu_book,
                  size: 40,
                ),
          onTap: () async {
            setState(() {
              isLoading = true;
            });
            //todo: chiamata api per prendermi questo Form in json
            final String diario =
                await rootBundle.loadString('assets/prova_form_dropdown.json');
            final Map<String, dynamic> res = json.decode(diario);
            print("ecco res: $res");
            //* in questo caso ho solo il diario di musicoterapia
            final diarioMus = MachForm.fromSocialNetwork(res['user_forms'][0]);
            print("ECCOCIIIII QUAAAAA");
            //! HO APPOGGIATO IL FORM NEI MIEI MODELS
            await MachFormOperations.saveFormToDB(diarioMus);
            print("FINITOOO");
            setState(() {
              isLoading = false;
            });
          },
        ),
        //! STEP 2 => PRENDO FORM DAL DB
        Row(children: [
          Text(
              "Pulsante per Prendere il Form \ncon il dropdown dal DB \ne caricarlo nei miei Models"),
          Container(
            height: 80,
            width: 100,
            color: Colors.yellow,
            child: IconButton(
              icon: Icon(Icons.arrow_circle_right_rounded),
              onPressed: () async {
                //ottengo il form dal database ! e lo inserisco nei miei models
                final form = await MachFormOperations.getFormById(72195);
                if (form != null) {
                  print("finitoooo: ecco il form: $form");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ChangeNotifierProvider<MachFormProvider>(
                        create: (context) => MachFormProvider(
                            machForm: form,),
                        child: CompilazioneMachForm(
                          machForm: form,
                        ),
                      ),
                    ),
                  );
                } else {
                  //TODO: GESTIRE ERRORE
                  print("errore nell'aprire il form dal DB");
                }
              },
            ),
          ),
        ]),
      ],
    );
  }
}

//response_DIARIO_FAKE
