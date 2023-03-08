import 'package:flutter/material.dart';

import 'models.dart';

//! classe che controlla la correttezza dei dati inseriti dall'utente nei form di autenticazione
//! se un form non è correttamente compilato appare errore, altrimenti prendo il valore valido

//todo: i listeners sui bottoni non funzionano, cambiare logica.
//bildano solo quando faccio setState sul parent (ovviamente)
class AuthValidator with ChangeNotifier {
  AuthenticationPhase currentAuthPhase = AuthenticationPhase.login;
  EmailField emailValidator = EmailField();
  PswField pValidator = PswField();
  UsernameField userValidator = UsernameField();
  //servono per desktop (non c'è la tastiera e l'app non ribuilda)
  bool canMakeLogin = false;
  bool canMakeSignup = false;

  void canAuth() {
    switch (currentAuthPhase) {
      case AuthenticationPhase.login:
        canLogin();
        break;
      case AuthenticationPhase.register:
        canRegister();
        break;
    }
  }

  void canLogin() {
    canMakeLogin = emailValidator.isCorrect() && pValidator.isCorrect();
    notifyListeners();
  }

  void canRegister() {
    canMakeSignup = emailValidator.isCorrect() &&
        pValidator.isCorrect() &&
        userValidator.isCorrect();
    notifyListeners();
  }

  void updateAuthPhase() {
    if (currentAuthPhase == AuthenticationPhase.login) {
      currentAuthPhase = AuthenticationPhase.register;
    } else {
      currentAuthPhase = AuthenticationPhase.login;
    }
    resetField();
  }

//quando switcho da login a register, pulisco tutti i campi
  void resetField() {
    emailValidator = EmailField();
    pValidator = PswField();
    userValidator = UsernameField();
    notifyListeners();
  }

//* la uso quando viene tolta la keyboard premendo il tasto inputAction done (che di base non causa il rebuild, ma a me serve ribuildare !)
  void rebuild() => notifyListeners();
}
