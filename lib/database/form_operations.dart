import 'package:music/models/compilazione_form.dart';
import 'package:music/models/risultati_comp_musicoterapia.dart';
import 'package:sqflite/sqflite.dart';

import '../models/form_assistito.dart';
import 'db_repository.dart';

//operazioni sui form
//* Form CRUD
class FormOperations {
  //?CREATE
  static Future<int> createCompilazioneForm(CompilazioneForm compForm) async {
    final db = await DbRepository.instance.database;
    try {
      final newId = await db.insert(
        "form_compilato",
        compForm.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return newId;
    } catch (e) {
      print("Errore nel aggiungere form compilato: $e");
      rethrow;
    }
  }

  //?READ_ALL
  static Future<CompilazioneForm> readAllFormCompilati() async {
    final db = await DbRepository.instance.database;
    final result = await db.query("form_compilato");
    if (result.isNotEmpty) {
      //per ora prendo il primo utente (in teoria ce ne dovrebbe essere salvato solo 1)
      final utente = CompilazioneForm.fromJSON(result.first);
      return utente;
    } else {
      throw Exception('User Not Found !');
    }
  }

  //?tutte le compilazioni effettuate dall'utente
  static Future<List<CompilazioneForm>> getUserFormCompilati(int userId) async {
    final db = await DbRepository.instance.database;
    try {
      final result = await db.rawQuery('''
        SELECT *
        FROM form_compilato
        WHERE user_id = ? 
        ''', [userId]);
      //result[i] = una riga della tabella => es: {id:0,nome:andrea:cognome:mont:age:18}
      final List<CompilazioneForm> formCompilati = List.generate(
        result.length,
        (index) {
          //print("ciaooo : ${result[index]}");
          return CompilazioneForm.fromJSON(result[index]);
        },
        growable: false,
      );
      return formCompilati;
    } catch (e) {
      print("errore: $e");
      rethrow;
    }
  }

  //?conto le compilazioni effettuate dall'utente
  static Future<int> countUserCompilazioni(int userId) async {
    final db = await DbRepository.instance.database;
    try {
      final result = await db.rawQuery('''
        SELECT *
        FROM form_compilato
        WHERE user_id = ? 
        ''', [userId]);
      //result[i] = una riga della tabella => es: {id:0,nome:andrea:cognome:mont:age:18
      return result.length;
    } catch (e) {
      print("errore nel contare i form dell'utente: $e");
      rethrow;
    }
  }

  //?tutte le compilazioni effettuate per un assistito
  static Future<int> countClientCompilazioni(int userId, int clientId) async {
    final db = await DbRepository.instance.database;
    try {
      final result = await db.rawQuery(
        '''
        SELECT *
        FROM form_compilato
        WHERE user_id = ? AND client_id = ?
        ''',
        [userId, clientId],
      );
      return result.length;
    } catch (e) {
      print("errore nel prendere le compilazioni di questo assistito: $e");
      rethrow;
    }
  }

  //inserisce le righe dentro la tabella Domanda, lo fa per completare una compilazione
  static Future<bool> insertDomandeComp(List<TableDomandaComp> domande) async {
    final db = await DbRepository.instance.database;
    try {
      final batch = db.batch();
      for (TableDomandaComp domandaRow in domande) {
        batch.insert('domanda', domandaRow.domandaToDb());
      }
      await batch.commit(noResult: true);
      return true;
    } catch (e) {
      //Se fallisco qua, devo cancellare la compilazione !!
      print(
          "Errore compilazione Form: errore nell'aggiungere domande nel DB: $e");
      return false;
    }
  }

  static Future<List<TableDomandaComp>> getDomandeByCompilationId(
      int compilazioneId) async {
    final db = await DbRepository.instance.database;
    try {
      //prendo tutte le domande di quella compilazione
      final result = await db.rawQuery(
        '''
        SELECT *
        FROM domanda
        WHERE compilazione_id = ? 
        ''',
        [compilazioneId],
      );
      if (result.isEmpty) {
        throw "Domande non Trovate !";
      }
      //result[i] = una riga della tabella => es: {id:0, domanda_id:22, score: 3, sezione_id:3}
      final List<TableDomandaComp> domande = List.generate(
        result.length,
        (index) => TableDomandaComp.fromDB(result[index]),
        growable: false,
      );
      return domande;
    } catch (e) {
      print("errore: $e");
      rethrow;
    }
  }

  //USARE STA FUNZIONE SOLO QUANDO C'è UN FAIL NEL CREARE UNA COMPILAZIONE !!
  //FUNZIONE PERICOLOSA ! :O
  static Future<void> deleteCompilazioneForm(int compilazioneId) async {
    final db = await DbRepository.instance.database;
    try {
      //prendo tutte le domande di quella compilazione
      await db.rawDelete(
        '''
        DELETE
        FROM form_compilato
        WHERE compilazione_id = ? 
        ''',
        [compilazioneId],
      );
      print("cancelled");
    } catch (e) {
      //se fallisce qua che faccio????? :O
      print("errore nel cancellare form: $e");
      rethrow;
    }
  }

  // Ottengo tutte le compilazioni effettuate per un assistito da parte di quell'utente
  static Future<List<CompilazioneForm>?> getAllAssistitoCompilations(
    int userId,
    int clientId,
  ) async {
    final db = await DbRepository.instance.database;
    try {
      final result = await db.rawQuery(
        '''
        SELECT *
        FROM form_compilato
        WHERE user_id = ? AND client_id = ?
        ''',
        [userId, clientId],
      );
      final List<CompilazioneForm> compilations = List.generate(
        result.length,
        (index) => CompilazioneForm.fromJSON(result[index]),
        growable: false,
      );
      /*  for (int i = 0; i < result.length; i++) {
        //result[i] = una riga della tabella => es: {id:0, domanda_id:22, score: 3, sezione_id:3}
        compilations.add(CompilazioneForm.fromJSON(result[i]));
      }*/
      if (compilations.isEmpty) {
        return null;
      }
      return compilations;
    } catch (e) {
      print("errore nel prendere le compilazioni di questo assistito: $e");
      rethrow;
    }
  }

  // Ottengo tutte le compilazioni di musicterapia effettuate per un assistito da parte di quell'utente
  static Future<List<CompilazioneForm>?> getMusicoterapiaCompilations(
    int userId,
    int clientId,
    int formId,
  ) async {
    final db = await DbRepository.instance.database;
    try {
      final result = await db.rawQuery(
        '''
        SELECT *
        FROM form_compilato
        WHERE form_id = ? AND user_id = ? AND client_id = ?
        ''',
        [formId, userId, clientId],
      );
      final List<CompilazioneForm> compilations = List.generate(
        result.length,
        (index) => CompilazioneForm.fromJSON(result[index]),
        growable: false,
      );
      /*  for (int i = 0; i < result.length; i++) {
        //result[i] = una riga della tabella => es: {id:0, domanda_id:22, score: 3, sezione_id:3}
        compilations.add(CompilazioneForm.fromJSON(result[i]));
      }*/
      if (compilations.isEmpty) {
        return null;
      }
      return compilations;
    } catch (e) {
      print("errore nel prendere le compilazioni di questo assistito: $e");
      rethrow;
    }
  }

//? tabella per salvare risultati della compilazione form Musicoterapia nel DB
  static Future<void> createRisultatoCompMusic(
      RisultatiCompMusic resultCompMusic) async {
    final db = await DbRepository.instance.database;
    try {
      await db.insert(
        "risultati_comp_musicoterapia",
        resultCompMusic.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Errore nel aggiungere form compilato: $e");
      rethrow;
    }
  }

  //? prendo i risultati della compilazione tramite ID
  static Future<RisultatiCompMusic> getRisultatiComp(int compId) async {
    final db = await DbRepository.instance.database;
    try {
      final result = await db.rawQuery(
        '''
        SELECT *
        FROM risultati_comp_musicoterapia
        WHERE compilazione_id = ? 
        ''',
        [compId],
      );
      final RisultatiCompMusic res = RisultatiCompMusic.fromJSON(result.first);
      return res;
    } catch (e) {
      print("Errore nel leggere risultati del form compilato: $e");
      rethrow;
    }
  }
}
