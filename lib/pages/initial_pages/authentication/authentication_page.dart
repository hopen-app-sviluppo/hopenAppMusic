import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers.dart';
import '../../common_widget/custom_clipper.dart';
import './helper/auth_validator.dart';
import 'helper/models.dart';
import 'views/login_form.dart';
import 'views/register_form.dart';
import 'widgets/authentication_btns.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthValidator>(
      builder: (context, authVal, _) {
        return Scaffold(
          //* uso il consumer così quando l'utente insersice i valori nei campi e preme il textInputAction DONE ribuilda tutto.
          //* se premo il textInputAction non causa setState, così lo risolvo
          body: GestureDetector(
            onTap: () => checkFocus(context),
            child: _buildBody(context),
          ),
          bottomNavigationBar: _buildAuthBtns(context),
          extendBody: true,
        );
      },
    );
  }

  //Il corpo della mia pagina Login
  Widget _buildBody(BuildContext context) => Stack(children: <Widget>[
        //!   disegno linee in basso e in alto
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: drawLines(
            context,
            isTopDraw: false,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: drawLines(context),
        ),
        //!   Form
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildForm(context),
        ),
      ]);

  _buildForm(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: _buildFormElements(context),
        ),
      ),
    );
  }

  List<Widget> _buildFormElements(BuildContext context) {
    return [
      //* logo app - testo
      const Center(
        child: Text(
            "Musica per la Relazione di Aiuto \n\n Un progetto di Hopen Up S.r.l."),
      ),
      //* login form - register form
      SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.7,
        child: context.read<AuthValidator>().currentAuthPhase ==
                AuthenticationPhase.login
            ? const LoginForm() //* cambia per mobile e desktop
            : const RegisterForm(),
      ),
    ];
  }

  //!  Bottoni pagina
  Widget _buildAuthBtns(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.18,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //* bottone login - registrati
            //se metto const non mi ribuilda
            // ignore: prefer_const_constructors
            Expanded(
              flex: 5,
              // ignore: prefer_const_constructors
              child: AuthenticationBtn(),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 5,
              child: ElevatedButton(
                onPressed: () =>
                    context.read<AuthValidator>().updateAuthPhase(),
                child: Text(
                  context.read<AuthValidator>().currentAuthPhase ==
                          AuthenticationPhase.login
                      ? "Non hai ancora un Account ?"
                      : "Sei già Registrato ?",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
