import 'package:music/helpers.dart';
import 'package:music/models/machform_models/form_element_options.dart';
import 'package:music/models/machform_models/form_elements.dart';
import 'package:music/models/machform_models/machform.dart';

import 'db_repository.dart';

class MachFormOperations {
  //?Save Form to DB => su tabella ap_form ci vanno i dati generici del form
  //? per ogni form elements => salvo riga su tabella ap_form_elements
  //? per ogni element_options => salvo riga su tabella ap_element_options

  static Future<void> saveFormToDB(MachForm machForm) async {
    final db = await DbRepository.instance.database;
    try {
      //* STEP 1 => SALVO FORM NELLA TABELLA ap_form
      final apFormRow = machForm.toJson(saveToDb: true);
      await db.insert('ap_forms', apFormRow);

      final formElementsBatch = db.batch();
      final elementOptionsBatch = db.batch();

      //* STEP 2 => SALVO OGNI FORM_ELEMENT NELlA TABELLA AP_FORM_ELEMENTS
      for (FormElements formElementRow in machForm.formElements) {
        formElementsBatch.insert(
          'ap_form_elements',
          formElementRow.toJson(saveToDb: true),
        );

        //* STEP 3 => SALVO OGNI OPZIONE DELL'ELEMENTO NELLA TABELLA AP_ELEMENT_OPTIONS
        for (FormElementsOptions elementOptionRow
            in formElementRow.formElementsOptions) {
          elementOptionsBatch.insert(
            'ap_element_options',
            elementOptionRow.toJson(),
          );
        }
      }
      await formElementsBatch.commit(noResult: true);
      await elementOptionsBatch.commit(noResult: true);
    } catch (e) {
      print("Errore nel salvare il Form nel DB $e");
      rethrow;
    }
  }

//cancello diario musicoterapia
  static Future<void> deleteForm() async {
    final db = await DbRepository.instance.database;
    try {
      //* STEP 1 => SALVO FORM NELLA TABELLA ap_form
      await db.rawQuery(
        '''
        DELETE
        FROM ap_forms
        WHERE form_id = ? 
        ''',
        ['68336'],
      );
    } catch (e) {
      print("Errore nel salvare il Form nel DB $e");
      rethrow;
    }
  }

  //? pagina lista Form => appaiono tutti i form (quelli che vedo dal network)
  //* se il form con quell'id è presente nel DB interno, allora c'è la spunta che ce l'ho gia e posso compilarlo
  //* se quel form non è presente nel DB interno, allora appare Icona download

  //? quando voglio compilare un form => lo seleziono dalla lista, quindi lo prendo dal Database interno, serve una Get che prende il DB interno e lo appoggia nei Models

//cancello diario musicoterapia
  static Future<MachForm?> getFormById(int formId) async {
    final db = await DbRepository.instance.database;
    try {
      //* STEP 1 => OTTENGO IL FORM CON QUELL'ID
      final formResult = await db.rawQuery(
        '''
        SELECT *
        FROM ap_forms
        WHERE form_id = ? 
        ''',
        [formId],
      );
      if (formResult.isEmpty) return null;

      //* STEP 2 => OTTENGO GLI ELEMENTI DI QUEL FORM, li ordino in base alla posizione
      final formElementsResult = await db.rawQuery(
        '''
        SELECT *
        FROM ap_form_elements
        WHERE form_id = ?
        ORDER BY element_position
        ''',
        [formId],
      );

      if (formElementsResult.isEmpty) return null;

      //* STEP 3 => OTTENGO LE OPZIONI DI QUEGLI ELEMENTI, li ordino in base alla posizione e tolgo quelli che non voglio far mostrare
      final optionsElementResult = await db.rawQuery(
        '''
        SELECT *
        FROM ap_element_options
        WHERE form_id = ? AND option_is_hidden = ?
        ORDER BY position
        ''',
        [formId, 0],
      );

      if (optionsElementResult.isEmpty) return null;

      //* STEP 4 => DECODIFICO I RISULTATI NEI MIEI MODELS

      // print("INIZIA LA DECODIFICA DEI VALORIII");
      //valore di appoggio, formElementResult è immodificabile => devo creare una nuova lista che sarà modificabile
      final formElements = List.generate(formElementsResult.length, (i) {
        // Map<String, dynamic> element = formElementsResult[i];
        // Map<String, dynamic> map = Map<String, dynamic>.from(element);
        // return map;
        return Map<String, dynamic>.from(formElementsResult[i]);
      });

      //? STEP 4.1 => PER OGNI ELEMENTO, INSERISCO I SUOI OPTIONS

      for (Map<String, Object?> element in formElements) {
        final elementOptions = optionsElementResult
            .where((option) => option['element_id'] == element['element_id'])
            .toList();
        element['form_elements_options'] =
            elementOptions; //assegno lista delle sue opzioni
      }

      //  print("FATTOOOOO, ECCO GLI ELEMENTI: ${formElements.length}");
      //  print("ecco le opzioni del primo elemento: ${formElements.first['form_elements_options']}");
      //  //? STEP 4.2 => INSERISCO GLI ELEMENTI NEL FORM
      //  //creo mappa modificabile
      Map<String, dynamic> form = Map<String, dynamic>.from(formResult.first);
      form['form_elements'] = formElements;

      //  //? STEP 5 => OTTENGO IL MIO FORM

      // print("STEP FINALEEE}");
      // print("vediamo un elemento: ${formElements.first}");
      return MachForm.fromInternalDB(form);
    } catch (e) {
      print("Errore nel salvare il Form nel DB $e");
      rethrow;
    }
  }

//* compilo il machform con quell'id
  static Future<void> compilazioneMachform(
    int formId,
    Map<String, dynamic> formValues,
  ) async {
    print("ECCOCIIII");
    //* STEP 1 => Creo tabella ap_form_formId,
    final dbRepo = DbRepository.instance;
    final db = await dbRepo.database;
    try {
      final String createTableQuery =
          dbRepo.createTable('ap_form_$formId', formValues);
      print("ecco la query: ${createTableQuery}");
      await db.execute(createTableQuery);

      //* STEP 2 => INSERISCO I VALORI LA COMPILAZIONE

      final int compilazioneId = await db.insert(
        'ap_form_$formId',
        formValues,
      );

      //* STEP 3 => INSERISCO LE VARIE CHIAVI ESTERNE SULLA TABELLA AP_FORMS_ESEGUITI

      final Map<String, dynamic> apFormEseguito = {
        'datetime': formatHour(DateTime.now()),
        'id_obiettivi': 0,
        'id_attivita': 0,
        'id_gruppo ': 0,
        'percentuale ': 0,
        'stato': 1,
        'privato': 'N',
        'id_form_parent': 0,
        'id_form': compilazioneId,
        'form': formId,
        'id_assistito': formValues['id_assistito'],
        'id_operatore': formValues['id_operatore'],
      };

      await db.insert('ap_forms_eseguiti', apFormEseguito);
    } catch (e) {
      print("EROOOOOREEEEEE: $e");
      rethrow;
    }
  }

//* LISTA MACHFORM COMPILATI DA QUELL'UTENTE
  static Future<List<Map<String, Object?>>> getUserMachformCompilati(
      int userId) async {
    final db = await DbRepository.instance.database;
    try {
      //* STEP 1 => OTTENGO TUTTE LE COMPILAZIONI FATTE DA QUELL'UTENTE

      final result = await db.rawQuery('''
        SELECT A.*, B.form_name, B.form_tags, A.id_form, C.client_name, D.username 
        FROM ap_forms_eseguiti A
				LEFT JOIN ap_forms B ON B.form_id = A.form
				LEFT JOIN cliente C ON C.client_id=A.id_assistito
				LEFT JOIN user D ON D.user_id=A.id_operatore
        WHERE A.id_operatore = ?
      ''', [userId]);

      return result;
    } catch (e) {
      print("errore: $e");
      rethrow;
    }
  }

  //* LISTA MACHFORM COMPILATI PER UN ASSISTITO
  static Future<List<Map<String, Object?>>> getAssistitoMachformCompilati(
      int clientId) async {
    final db = await DbRepository.instance.database;
    try {
      //* STEP 1 => OTTENGO TUTTE LE COMPILAZIONI FATTE DA QUELL'UTENTE

      final result = await db.rawQuery('''
        SELECT A.*, B.form_name, B.form_tags, A.id_form, C.client_name, D.username 
        FROM ap_forms_eseguiti A
				LEFT JOIN ap_forms B ON B.form_id = A.form
				LEFT JOIN cliente C ON C.client_id=A.id_assistito
				LEFT JOIN user D ON D.user_id=A.id_operatore
        WHERE A.id_assistito = ?
      ''', [clientId]);

      return result;
    } catch (e) {
      print("errore: $e");
      rethrow;
    }
  }

//* GLI PASSO L'ID DEL FORM, L'ID DELLA COMPILAZIONE E TORNA LA COMPILAZIONE FATTA

  static Future<Map<String, Object?>> getCompilationById(
      int formId, int compilazioneId) async {
    final db = await DbRepository.instance.database;
    try {
      final result = await db.rawQuery('''
      SELECT *
      FROM ap_form_$formId
      WHERE id = ?
      ''', [compilazioneId]);
      return result.first;
    } catch (e) {
      print("errore nel prendere il form dal DB");
      rethrow;
    }
  }
}
