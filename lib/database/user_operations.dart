import 'package:flutter/cupertino.dart';
import 'package:music/helpers.dart';
import 'package:music/models/user/internal_account.dart';
import 'package:sqflite/sqflite.dart';
import './db_repository.dart';

//* User crud on internal db
class UserOperations {
  static Future<void> createUser(Map<String, dynamic> userMap) async {
    final db = await DbRepository.instance.database;
    try {
      await db.insert(
        "user",
        userMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("error creating user: $e");
      rethrow;
    }
  }

  //funzione chiamata dal metodo onInitialize in authentication Provider
  //quando avvio l'app controllo se mandare utente direttamente su homepage o su pagina di atuenticazione
  static Future<List<Map<String, Object?>>> readAllUser() async {
    final db = await DbRepository.instance.database;
    try {
      //prendo tutti gli utenti nel DB interno
      return await db.query("user");
    } catch (error) {
      print("errore: $error");
      return [];
    }
  }

  //torna true se nel DB esiste un utente con quell'id
  static Future<InternalAccount?> readUser(int id) async {
    final db = await DbRepository.instance.database;
    try {
      final maps = await db.rawQuery(
        '''
        SELECT *
        FROM user
        WHERE user_id = ? 
        ''',
        [id],
      );
      if (maps.isNotEmpty) {
        final ciao = InternalAccount.fromDB(maps.first);
        return ciao;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //devo aggioranre tutto tranne partitaiva,attivita,numPazienti,feedbackinviati,company
  static Future<void> updateUser(
      Map<String, dynamic> socialUser, int id) async {
    // Get a reference to the database.
    final db = await DbRepository.instance.database;
    //torna il numero di cambiamenti fatti
    try {
      await db
          .update("user", socialUser, where: 'user_id = ?', whereArgs: [id]);
    } catch (e) {
      print("errore nell'aggiornare l'utente: $e");
      rethrow;
    }
  }

  //aggiorna il singolo campo che gli passo nel db interno utente

  static Future<void> updateUserInternalField({
    required int userId,
    required String fieldToUpdate,
    required String? valToInsert,
  }) async {
    print(
        "ecco id: $userId, fieldToUpdate: $fieldToUpdate e valore: $valToInsert");
    final db = await DbRepository.instance.database;
    //torna il numero di cambiamenti fatti
    try {
      await db.rawUpdate(
        'UPDATE user SET $fieldToUpdate = ? WHERE user_id = ?',
        [valToInsert, userId],
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> deleteUser(int id) async {
    // Get a reference to the database.
    final db = await DbRepository.instance.database;
    try {
      await db.delete(
        'user',
        where: 'user_id = ?',
        whereArgs: [id],
      );
      return true;
    } catch (e) {
      print("errore nel cancellare utente: $e");
      return false;
    }
  }

  static Future<void> updateUserAccess(int newAccessVal, int userId) async {
    // Get a reference to the database.
    final db = await DbRepository.instance.database;
    //torna il numero di cambiamenti fatti
    try {
      await db.rawUpdate(
          'UPDATE user SET user_remember_access = ? WHERE user_id = ?',
          [newAccessVal, userId]);
    } catch (e) {
      //fallito nel settare valore a false
      rethrow;
    }
  }

//? aggiungo un paziente => incremento counter
  static Future<int> updateClienteCount(
    int userId, {
    int? currentNumClients,
  }) async {
    int counter = 0;
    if (currentNumClients == null) {
      counter = 1;
    } else {
      // counter = int.parse(currentNumClients);
      counter = currentNumClients++;
    }
    final db = await DbRepository.instance.database;
    //torna il numero di cambiamenti fatti
    try {
      await db.rawUpdate(
        'UPDATE user SET num_pazienti = ? WHERE user_id = ?',
        [counter, userId],
      );
      return counter;
    } catch (e) {
      //fallito nel settare valore
      rethrow;
    }
  }

//* in teoria nel DB ci va proprio tutto il feedback, per ora metto solo il numero di quelli invati (poi i feedback me li prendo dal gestionale)
  static Future<bool> onFeedbackSended(int userId, int feedbackInviati) async {
    final db = await DbRepository.instance.database;
    try {
      //print("numero: $feedbackInviati e id: $userId");
      await db.rawUpdate(
        'UPDATE user SET feedback_inviati = ? WHERE user_id = ?',
        [feedbackInviati, userId],
      );
      return true;
    } catch (error) {
      print("errore nell'aumentare i feedback inviati");
      return false;
    }
  }
}
