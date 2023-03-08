import 'package:flutter/material.dart';
import 'package:music/api/gestionale_api/testo_api.dart';
import 'package:music/pages/common_widget/custom_html_page.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';
import '../../../../router.dart';
import '../../../../helpers.dart';
import '../../authentication/helper/auth_validator.dart';
import '../../../../provider/authentication_provider.dart';
import '../helper/models.dart';

class AuthenticationBtn extends StatefulWidget {
  const AuthenticationBtn({
    Key? key,
  }) : super(key: key);

  @override
  State<AuthenticationBtn> createState() => _AuthenticationBtnState();
}

class _AuthenticationBtnState extends State<AuthenticationBtn> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _buildCurrentBtn();
  }

  //* torna il Bottone in base alla fase di autenticazione (login, register prima fase, register seconda fase)
  Widget _buildCurrentBtn() {
    switch (context.read<AuthValidator>().currentAuthPhase) {
      case AuthenticationPhase.login:
        return _buildLoginButton();
      case AuthenticationPhase.register:
        return _buildRegisterButton();
    }
  }

  ElevatedButton _buildLoginButton() => ElevatedButton(
        onPressed:
            context.select<AuthValidator, bool>((val) => val.canMakeLogin)
                ? () => _checkLogin()
                : null,
        child: const Text("Login"),
      );

  ElevatedButton _buildRegisterButton() => ElevatedButton(
        onPressed:
            context.select<AuthValidator, bool>((val) => val.canMakeSignup)
                ? () => _checkRegister()
                : null,
        child: const Center(
          child: Text("Registrati"),
        ),
      );

  Future<void> _checkLogin() async {
    //posso fare Login
    setState(() {
      isLoading = true;
    });
    try {
      await context.read<AuthenticationProvider>().socialLogin(
            context.read<AuthValidator>().emailValidator.content!,
            context.read<AuthValidator>().pValidator.content!,
          );
      //login è adanto a buon fine, mostro dialogo
      final resultText = await TestoApi.getTestoIniziale();
      if (resultText != null) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  backgroundColor: MainColor.primaryColor,
                  content: SingleChildScrollView(
                    child: HtmlPage(
                      htmlData: resultText,
                    ),
                  ), //Text(resultText, textAlign: TextAlign.justify),
                  actions: [
                    ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Chiudi"))
                  ],
                ));
      }
      //quando si chiude, vado su homepage
      context
          .read<AuthenticationProvider>()
          .updateAuthState(AuthState.loggedIn);
      //di ignoranza, se non funziona, navigo indietro su pagina di login
      //se faccio di ignoranza, non mi mostra il popup se voglio uscire
      if (ModalRoute.of(context)?.settings.name != AppRouter.profiloUtente) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRouter.profiloUtente, (route) => false);
      }
    } catch (error) {
      showSnackBar(
        context,
        error.toString(),
        isError: true,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkRegister() async {
    setState(() {
      isLoading = true;
    });
    //late final String result;
    String result = "";
    bool isError = false;
    try {
      result = await context.read<AuthenticationProvider>().socialSignup(
            context.read<AuthValidator>().userValidator.content!,
            context.read<AuthValidator>().pValidator.content!,
            context.read<AuthValidator>().emailValidator.content!,
          );
      context.read<AuthValidator>().updateAuthPhase();
    } catch (e) {
      print("errore Sign Up $e");
      result = e.toString();
      isError = true;
    } finally {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, result, isError: isError);
    }
  }
}
