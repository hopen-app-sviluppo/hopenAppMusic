import 'package:flutter/material.dart';
import 'package:music/api/social_api/social_api.dart';
import 'package:music/database/db_repository.dart';
import 'package:music/database/user_operations.dart';
import 'package:music/models/user/internal_account.dart';
import 'package:music/models/user/user.dart';

//* Metodi di autenticazione (signin, signup, logout, mandacodicereg, password dimenticata, ricordami)

enum AuthState {
  loading,
  loggedIn,
  loggedOut,
  //prima volta che si accede all'app => mando utente su introduction page
  error,
}

class AuthenticationProvider with ChangeNotifier {
  User? currentUser;
  AuthState authState = AuthState.loading;

  void updateAuthState(AuthState newVal) {
    authState = newVal;
    notifyListeners();
  }

  //* controllo se utente è loggato o no !
  //se esiste nel DB interno, prendo token, provo a fare login con il social
  //se tutto ok => homepage, altrimenti => authenticationPage
  Future<void> onInitialize() async {
    try {
      await DbRepository.instance.initializeDatabase();
      final utenti = await UserOperations.readAllUser();
      if (utenti.length == 1) {
        //faccio login con il token interno
        final userOnDb = InternalAccount.fromDB(utenti.first);
        //preso l'utente dal DB interno, faccio login sul social!
        final socialUser = await SocialApi.getUserData(
          token: userOnDb.token,
          id: userOnDb.id.toString(),
        );
        currentUser = User(
          id: userOnDb.id,
          socialAccount: socialUser,
          internalAccount: userOnDb,
        );
        //!  currentUser = User.fromJSON(userSocialMap);
        authState = AuthState.loggedIn;
        notifyListeners();
      } else {
        // in tutti gli altri casi vado su loginPage
        currentUser = null;
        authState = AuthState.loggedOut;
        notifyListeners();
      }
    } catch (e) {
      print("erroreeeeee: $e");
      currentUser = null;
      //*appare pagina di benvenuto
      authState = AuthState.error;
      notifyListeners();
      rethrow;
    }
  }

  Future<String> socialSignup(String username, String p, String email) async {
    try {
      return await SocialApi.createAccount(username, p, email);
      //se va a buon fine, all'utente arriva un'email per attivare l'account !
    } catch (e) {
      rethrow;
    }
  }

//login con il social

  Future<void> socialLogin(String email, String p) async {
    try {
      //ottengo il token e l'id dell'utente
      final tokenUserId = await SocialApi.getUserTokenId(email, p);
      //con il token e id ottengo i dati dell'utente
      final socialUser = await SocialApi.getUserData(
        token: tokenUserId[0],
        id: tokenUserId[1],
      );
      //login con il social fatto !, ora cerco nel DB interno se esiste utente con quell'id
      //se esiste, allora ci aggiungo i dati nel DB interno che non sono in quelli del social.
      //se non esiste, allora lo creo da 0.
      final id = int.parse(tokenUserId[1]);
      final internalUser = await UserOperations.readUser(id);
      if (internalUser != null) {
        currentUser = User(
          id: id,
          socialAccount: socialUser,
          internalAccount: internalUser,
        );
      } else {
        //utente nel DB interno non esiste ! lo creo !
        final internalAccount = InternalAccount.empty(id, tokenUserId[0]);
        await UserOperations.createUser(internalAccount.toDB());
        currentUser = User(
          id: id,
          socialAccount: socialUser,
          internalAccount: internalAccount,
        );
      }

      authState = AuthState.loggedIn;
    } catch (e) {
      currentUser = null;
      authState = AuthState.loggedOut;

      print("errore auth provider: $e");
      rethrow;
    }
  }

  Future<void> logOut() async {
    //provo a fare logOut
    //setto nel db interno remember_access a false
    try {
      await SocialApi.logOut(currentUser!.internalAccount.token);
      currentUser = null;
      authState = AuthState.loggedOut;
      notifyListeners();
    } catch (error) {
      print("error logout: $error");
      rethrow;
    }
  }

  Future<void> recuperaPsw(String email) async {
    //dove prendo il token: 1) da utente corrente se user ci va dall'interno dell'app 2) dal DB interno
  }
}
