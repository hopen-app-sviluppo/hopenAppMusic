import 'package:sqflite/sqflite.dart';
import '../models/cliente.dart';
import 'db_repository.dart';

//* Assistito CRUD

class ClienteOperations {
  //?CREATE
  static Future<void> createClient(Cliente cliente) async {
    // Get a reference to the database.
    final db = await DbRepository.instance.database;
    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    //! non gli passo nessun id, lo genera da solo !
    try {
      await db.insert(
        "cliente",
        cliente.toJSON(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print("Errore nel creare l'assistito: $e");
      rethrow;
    }
    //! in teoria dovrebbe lo stesso che gli passo io (che sarebbe l'id dato dal server)
    // return newId;
  }

  //?READ_ALL
  static Future<Cliente> readAllClient() async {
    final db = await DbRepository.instance.database;
    final result = await db.query("cliente");
    if (result.isNotEmpty) {
      //per ora prendo il primo utente (in teoria ce ne dovrebbe essere salvato solo 1)
      final utente = Cliente.fromJSON(result.first);
      return utente;
    } else {
      throw Exception('User Not Found !');
    }
  }

  //?READ_ONE
  static Future<Cliente> readCliente(int id) async {
    final db = await DbRepository.instance.database;
    //print("id: $id");
    final maps = await db.rawQuery('''
        SELECT *
        FROM cliente
        WHERE client_id = ? 
        ''', [id]);
    if (maps.isNotEmpty) {
      return Cliente.fromJSON(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  //?UPDATE
  static Future<void> updateCliente(Cliente cliente, int id) async {
    // Get a reference to the database.
    final db = await DbRepository.instance.database;
    //torna il numero di cambiamenti fatti
    await db.update(
      'cliente',
      cliente.toJSON(),
      // Ensure that the user has a matching id.
      where: 'id = ?',
      // Pass the user's id as a whereArg to prevent SQL injection.
      whereArgs: [cliente.id],
    );
  }

  //aggiorna il singolo campo che gli passo

  static Future<void> updateClientField({
    required int clientId,
    required String fieldToUpdate,
    required String? valToInsert,
  }) async {
    final db = await DbRepository.instance.database;
    //torna il numero di cambiamenti fatti
    try {
      await db.rawUpdate(
        'UPDATE cliente SET $fieldToUpdate = ? WHERE client_id = ?',
        [valToInsert, clientId],
      );
    } catch (e) {
      rethrow;
    }
  }

  //?DELETE
  static Future<void> deleteCliente(int id) async {
    // Get a reference to the database.
    final db = await DbRepository.instance.database;
    await db.delete(
      'cliente',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //?READ ALL user's Client
  static Future<List<Cliente>> getUserClients(int userId) async {
    final db = await DbRepository.instance.database;
    try {
      final result = await db.rawQuery('''
        SELECT *
        FROM cliente
        WHERE user_id = ? 
        ''', [userId]);
      /* if (result.isEmpty) {
        throw "Non hai Assistiti !";
      }*/
      final List<Cliente> clients = [];
      for (int i = 0; i < result.length; i++) {
        //result[i] = una riga della tabella => es: {id:0,nome:andrea:cognome:mont:age:18}
        clients.add(Cliente.fromJSON(result[i]));
      }
      return clients;
    } catch (e) {
      rethrow;
    }
  }

  //?Conto il numero degli assistiti dell'utente
  static Future<int> countUserClients(int userId) async {
    final db = await DbRepository.instance.database;
    try {
      final result = await db.rawQuery('''
        SELECT *
        FROM cliente
        WHERE user_id = ? 
        ''', [userId]);
      /* if (result.isEmpty) {
        throw "Non hai Assistiti !";
      }*/
      return result.length;
    } catch (e) {
      rethrow;
    }
  }
}
