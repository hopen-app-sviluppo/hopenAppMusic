import 'package:flutter/material.dart';
import 'package:music/database/machform_operations.dart';
import 'package:music/helpers.dart';
import 'package:music/models/cliente.dart';
import 'package:music/models/machform_models/form_element_options.dart';
import 'package:music/models/machform_models/form_element_type.dart';
import 'package:music/models/machform_models/form_elements.dart';
import 'package:music/models/machform_models/machform.dart';
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';

//se reading => allora sta leggendo una compilazione,
//se writing => allora sta compilando
enum CompilazioneType {
  reading,
  writing,
}

class MachFormProvider with ChangeNotifier {
  final MachForm machForm;
  //pagina corrente, se esistono pageBreaks allora questo valore può incrementarsi
  int pageSelected = 1;
  bool pageBreakExists = false;
  //assistito scelto per la compilazione
  Cliente? currentClient;
  //di default è writing
  CompilazioneType compType = CompilazioneType.writing;

  //metto qua i risultati, in modalità map<String,dynamic> => cos' quando compilo faccio un toJson nel DB, tabella ap_form_formId
  //ogni key sarà il nome della colonna del database, value il suo valore

  Map<String, dynamic> formValues = {};

  MachFormProvider({
    required this.machForm,
    this.currentClient,
    Map<String, dynamic>? compilazioniValues,
  }) {
    //* inizializzazione
    if (compilazioniValues == null) {
      //assegno a formValues i valori di default
      initiliazeWritingCompilation();
    } else {
      //assegno a formValues i valori presenti nel DB (utente sta leggendo una compilazione)
      initiliazeReadingCompilation(compilazioniValues);
      compType = CompilazioneType.reading;
    }
  }

  void updateClient(Cliente? selectedClient) {
    currentClient = selectedClient;
    notifyListeners();
  }

  void onPageSelected({int? pageIndex}) {
    pageSelected = pageIndex ?? pageSelected++;
    notifyListeners();
  }

  void goToNextPage() {
    pageSelected++;
    notifyListeners();
  }

  void goToPrevPage() {
    pageSelected--;
    notifyListeners();
  }

//aggiorno il valore di riferimento
  void updateFormVal(String columnName, dynamic value) {
    if (compType == CompilazioneType.reading) {
      return;
    }
    formValues[columnName] = value;
    notifyListeners();
  }

//aggiorno il valore che è un textField
  void updateTextController(String columnName, String? value) {
    if (compType == CompilazioneType.reading) {
      return;
    }
    formValues[columnName].text = value ?? "";
    notifyListeners();
  }

  Future<void> compilaForm(BuildContext context) async {
    //inserisco id assistito
    formValues['id_assistito'] = currentClient?.id;
    if (formValues['id_assistito'] == null) throw ("Seleziona l'assistito !");
    //inserisco id operatore
    formValues['id_operatore'] =
        context.read<UserProvider>().currentUser!.internalAccount.id;
    await MachFormOperations.compilazioneMachform(
      machForm.formId,
      formValuesToDB(),
    );
  }

  //preparo i formValues per essere inseriti nel DB per la compilazione
  //i bool diventano 0 o 1, i textfield diventano stringhe o null
  Map<String, dynamic> formValuesToDB() {
    Map<String, dynamic> temp = {};
    formValues.forEach((key, value) {
      print("ecco value type: ${value.runtimeType}");
      switch (value.runtimeType) {
        case TextEditingController:
          if (value.text == "") {
            temp[key] = null;
          } else {
            temp[key] = value.text;
          }
          break;
        case DateTime:
          //converto data in stringa, del tipo yyyy-MM-dd
          temp[key] = formatDateToString(value);
          break;
        case TimeOfDay:
          //converto time in stringa del tipo hh:mm
          temp[key] = "${value.hour}:${value.minute}";
          break;
        case bool:
          //converto in intero
          temp[key] = value ? 1 : 0;
          break;
        case int:
          temp[key] = value;
          break;
        default:
          temp[key] = value;
          break;
      }
    });
    return temp;
  }

//chiudo tutti i controllers
  @override
  void dispose() {
    for (var element in machForm.formElements) {
      if (element.elementType == FormElementType.text ||
          element.elementType == FormElementType.textarea ||
          element.elementType == FormElementType.email ||
          element.elementType == FormElementType.number ||
          element.elementType == FormElementType.phone) {
        formValues['element_${element.elementId}']?.dispose();
      } else if (element.elementType == FormElementType.radio &&
          element.elementChoiceHasOther) {
        formValues['element_${element.elementId}_other']?.dispose();
      }
    }
    super.dispose();
  }

//se utente sta facendo una nuova compilazione, parte sta funziona dal costruttore => inizializzo tutti i valori con quelli di default
  void initiliazeWritingCompilation() {
    for (var element in machForm.formElements) {
      switch (element.elementType) {
        case FormElementType.text:
        case FormElementType.number:
        case FormElementType.phone:
        case FormElementType.email:
        case FormElementType.textarea:
        case FormElementType.url:
          //phone nel DB è di tipo double
          updateFormVal(
            'element_${element.elementId}',
            TextEditingController(text: ""),
          );
          break;
        case FormElementType.checkbox:
          //se l'elemento è di tipo checkBox => allora aggiungo tutte le sue opzioni nella forma: element_id_position : false
          for (FormElementsOptions option in element.formElementsOptions) {
            updateFormVal(
              'element_${element.elementId}_${option.position}',
              false,
            );
          }
          break;
        case FormElementType.radio:
          updateFormVal(
            'element_${element.elementId}',
            0,
          );
          //se ho aggiunto other, allora ho un altro valore nel DB, con nome colonna element_id_other
          if (element.elementChoiceHasOther) {
            updateFormVal(
              'element_${element.elementId}_other',
              TextEditingController(text: ""),
            );
          }
          break;
        case FormElementType.select:
          //è un dropdown
          updateFormVal('element_${element.elementId}', 0);
          break;
        case FormElementType.simple_name:
          //nel db salvo come element_elementId_1 è il nome, element_elementId_2 è il cognome
          updateFormVal(
            'element_${element.elementId}_1',
            TextEditingController(text: ""),
          );
          updateFormVal(
            'element_${element.elementId}_2',
            TextEditingController(text: ""),
          );
          break;
        case FormElementType.date:
        case FormElementType.europe_date:
          //sarà in formato Datetime
          updateFormVal('element_${element.elementId}', DateTime.now());
          break;
        case FormElementType.time:
          updateFormVal('element_${element.elementId}', TimeOfDay.now());
          break;
        case FormElementType.address:
          //6 valori
          updateFormVal(
            'element_${element.elementId}_1',
            TextEditingController(text: ""),
          );
          updateFormVal(
            'element_${element.elementId}_2',
            TextEditingController(text: ""),
          );
          updateFormVal(
            'element_${element.elementId}_3',
            TextEditingController(text: ""),
          );
          updateFormVal(
            'element_${element.elementId}_4',
            TextEditingController(text: ""),
          );
          updateFormVal(
            'element_${element.elementId}_5',
            TextEditingController(text: ""),
          );
          updateFormVal(
            'element_${element.elementId}_6',
            TextEditingController(text: ""),
          );

          break;
        case FormElementType.matrix:
          updateFormVal('element_${element.elementId}', 0);
          break;
        case FormElementType.page_break:
          pageBreakExists = true;
          break;
        case FormElementType.money:
          break;
        case FormElementType.file:
          break;
        case FormElementType.section:
          break;
        case FormElementType.signature:
          break;
        case FormElementType.media:
          break;
      }
    }
  }

  //se utente sta leggendo una compilazione già fatta, parte sta funziona dal costruttore => inizializzo tutti i valori con quelli presenti nel DB
  void initiliazeReadingCompilation(Map<String, dynamic> compilazioniValues) {
    for (var element in machForm.formElements) {
      switch (element.elementType) {
        case FormElementType.text:
        case FormElementType.textarea:
        case FormElementType.email:
        case FormElementType.number:
        case FormElementType.phone:
        case FormElementType.url:
          updateFormVal(
            'element_${element.elementId}',
            TextEditingController(
              text: compilazioniValues['element_${element.elementId}'],
            ),
          );
          break;
        case FormElementType.checkbox:
          for (var option in element.formElementsOptions) {
            updateFormVal(
              'element_${element.elementId}_${option.position}',
              compilazioniValues[
                      'element_${element.elementId}_${option.position}'] ==
                  1,
            );
          }
          break;
        case FormElementType.radio:
          updateFormVal(
            'element_${element.elementId}',
            compilazioniValues['element_${element.elementId}'],
          );
          if (element.elementChoiceHasOther) {
            updateFormVal(
                'element_${element.elementId}_other',
                TextEditingController(
                    text: compilazioniValues[
                        'element_${element.elementId}_other']));
          }
          break;
        case FormElementType.select:
          updateFormVal('element_${element.elementId}',
              compilazioniValues['element_${element.elementId}']);
          break;
        case FormElementType.simple_name:
          updateFormVal(
            'element_${element.elementId}_1',
            TextEditingController(
                text: compilazioniValues['element_${element.elementId}_1']),
          );

          updateFormVal(
            'element_${element.elementId}_2',
            TextEditingController(
                text: compilazioniValues['element_${element.elementId}_2']),
          ); //=>
          break;
        case FormElementType.date:
        case FormElementType.europe_date:
          //da stringa a datetime
          updateFormVal(
              'element_${element.elementId}',
              formatStringToYear(
                  compilazioniValues['element_${element.elementId}']));
          break;
        case FormElementType.time:
          //converto 13:46 stringa in TimeOfDay(hour:13, minute:46)
          //se la stringa è 10:43, creo una lista ["10", "43"]
          final List<String> time =
              compilazioniValues['element_${element.elementId}'].split(":");
          updateFormVal(
              'element_${element.elementId}',
              TimeOfDay(
                hour: int.parse(time[0]),
                minute: int.parse(time[1]),
              ));
          break;
        case FormElementType.address:
          //6 valori
          updateFormVal(
              'element_${element.elementId}_1',
              TextEditingController(
                  text: compilazioniValues['element_${element.elementId}_1']));
          updateFormVal(
              'element_${element.elementId}_2',
              TextEditingController(
                  text: compilazioniValues['element_${element.elementId}_2']));
          updateFormVal(
              'element_${element.elementId}_3',
              TextEditingController(
                  text: compilazioniValues['element_${element.elementId}_3']));
          updateFormVal(
              'element_${element.elementId}_4',
              TextEditingController(
                  text: compilazioniValues['element_${element.elementId}_4']));
          updateFormVal(
              'element_${element.elementId}_5',
              TextEditingController(
                  text: compilazioniValues['element_${element.elementId}_5']));
          updateFormVal(
            'element_${element.elementId}_6',
            TextEditingController(
                text: compilazioniValues['element_${element.elementId}_6']),
          );
          break;
        case FormElementType.money:
          break;
        case FormElementType.matrix:
          updateFormVal('element_${element.elementId}',
              compilazioniValues['element_${element.elementId}']);
          break;
        case FormElementType.file:
          break;
        case FormElementType.section:
          break;
        case FormElementType.page_break:
          pageBreakExists = true;
          break;
        case FormElementType.signature:
          break;
        case FormElementType.media:
          break;
      }
    }
  }
}
