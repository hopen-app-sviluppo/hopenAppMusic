import 'package:flutter/material.dart';
import 'package:music/database/form_operations.dart';
import '../database/client_operations.dart';
import '../database/user_operations.dart';
import '../models/cliente.dart';
import '../models/user/user.dart';

//*fornisce utente corrente e fa tutte le operazioni con database lato utente!

//!utente fa login,signup => prendo dati dal server, creo database interno con tabella user
// se utente fa login => creo database

class UserProvider with ChangeNotifier {
  User? _currentUser;

  UserProvider(this._currentUser) {
    //significa che è stato fatto un login o un signup
    if (_currentUser != null) {
      // createUserTable();
    }
  }

  User? get currentUser => _currentUser;

  //* aggiorno utente corrente
  void updateUser(User newUser) {
    _currentUser = newUser;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateUserTable() async {
    //final isUserUpdated = await UserOperations.updateUser(_currentUser!, _currentUser!.id);
  }

  //! perchè uno dovrebbe cancellare utente??? bho
  Future<void> deleteUserTable() async {
    final bool isUserDeleted =
        await UserOperations.deleteUser(_currentUser!.id);
    if (isUserDeleted) {
      //utente cancellato nel db
      clearUser();
    } else {
      //errore nel cancellare utente nel db
    }
  }

  //torna la lista degli assistiti dell'utente corrente
  Future<List<Cliente>> getClients() async {
    try {
      final List<Cliente> clients =
          await ClienteOperations.getUserClients(currentUser!.id);
      return clients;
    } catch (error) {
      rethrow;
    }
  }

  Future<int> countAssistiti() async {
    try {
      final int numAssistiti =
          await ClienteOperations.countUserClients(currentUser!.id);
      return numAssistiti;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> countFormCompilati() async {
    try {
      final int formCompilati =
          await FormOperations.countUserCompilazioni(currentUser!.id);
      return formCompilati;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateNumPazienti() async {
    try {
      int pazientiCount = await UserOperations.updateClienteCount(
        currentUser!.id,
        currentNumClients: currentUser!.internalAccount.numPazienti,
      );
      currentUser!.internalAccount.numPazienti = pazientiCount;
      notifyListeners();
    } catch (e) {
      currentUser!.internalAccount.numPazienti = 0;
    }
  }
}
