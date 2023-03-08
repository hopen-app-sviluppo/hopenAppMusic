enum AuthenticationPhase {
  login,
  register,
}

enum AuthFieldType {
  email,
  psw,
  username,
}

abstract class AuthField {
  final AuthFieldType authFieldType;
  final String name;
  String? content;
  String? error;

  AuthField({
    required this.authFieldType,
    required this.name,
    this.content,
    this.error,
  });

  //metodo per validarlo,

  bool onFieldValiding(String? newVal);

  bool isCorrect() => content != null && error == null;
}

class EmailField extends AuthField {
  EmailField({
    String? content,
    String? error,
  }) : super(
          authFieldType: AuthFieldType.email,
          name: "Email",
          content: content,
          error: error,
        );

  @override
  bool onFieldValiding(String? newVal) {
    if (newVal == null || newVal.length < 10 || newVal.length > 80) {
      content = null;
      error = "Invalid Format ";
      //canAuthenticate["email"] = false;
      return false;
    } else {
      content = newVal;
      error = null;
      //  canAuthenticate["email"] = true;
      return true;
    }
  }
}

class PswField extends AuthField {
  PswField({
    String? content,
    String? error,
  }) : super(
          authFieldType: AuthFieldType.psw,
          name: "Password",
          content: content,
          error: error,
        );

  @override
  bool onFieldValiding(String? newVal) {
    String errorPsw = "";
    final upperCase = RegExp(r'[A-Z]');
    final digits = RegExp(r'[0-9]');
    final specialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (newVal == null) {
      errorPsw += "Inserisci Password";
      //canAuthenticate["password"] = false;
      content = null;
      return false;
    }
    //se psw non contiene almeno 8 caratteri
    if (newVal.length < 8) {
      errorPsw += "Minimo 8 Caratteri !";
    }

    //se psw non contiene almeno un carattere grande
    if (!newVal.contains(upperCase)) {
      errorPsw += "\nAlmeno una lettera Grande !";
    }
    //se psw non contiene almeno una cifra
    if (!newVal.contains(digits)) {
      errorPsw += "\nAlmeno una cifra !";
    }
    //se psw non contiene almeno un carattere speciale
    /* if (!newVal.contains(specialCharacters)) {
      errorPsw += "\nAlmeno un carattere speciale !";
    }*/

    //se non ci sono errori
    if (errorPsw == "") {
      error = null;
      content = newVal;
      //!mando segnale che psw è okay
      //canAuthenticate["password"] = true;
      return true;
    } else {
      content = null;
      error = errorPsw;
      //  canAuthenticate["password"] = false;
      return false;
    }
  }
}

class UsernameField extends AuthField {
  UsernameField({
    String? content,
    String? error,
  }) : super(
          authFieldType: AuthFieldType.username,
          name: "Username",
          content: content,
          error: error,
        );

  @override
  bool onFieldValiding(String? newVal) {
    if (newVal == null || newVal.length < 5 || newVal.length > 32) {
      error = "Tra 5 e 32 caratteri";
      content = null;
      return false;
    } else {
      error = null;
      content = newVal;
      return true;
    }
  }
}
