import 'package:flutter/material.dart';

import 'package:music/pages/initial_pages/authentication/helper/auth_validator.dart';
import 'package:music/responsive_widget/responsive_widget.dart';

import 'package:provider/provider.dart';

import '../../../common_widget/custom_rounded_card.dart';
import '../widgets/auth_text_field.dart';
import '../../../common_widget/custom_checkbox.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ResponsiveWidget(
        mobileWidget: mobileLogin(context),
        webWidget: desktopLogin(context),
      );

  Widget mobileLogin(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RoundedCard(
            width: MediaQuery.of(context).size.width * 0.6,
            child: AuthTextField(
              maxLength: 60,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              authField: context.read<AuthValidator>().emailValidator,
            ),
          ),
          //SizedBox(height: sizeConfig.safeBlockVertical * 5),

          RoundedCard(
            width: MediaQuery.of(context).size.width * 0.6,
            child: AuthTextField(
              maxLength: 20,
              prefixIcon: Icons.lock,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              authField: context.read<AuthValidator>().pValidator,
            ),
          ),

          _buildRicordamiRecovery(),
        ],
      );

  Widget desktopLogin(BuildContext context) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              child: Card(
                child: AuthTextField(
                  maxLength: 60,
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  authField: context.read<AuthValidator>().emailValidator,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              child: Card(
                child: AuthTextField(
                  maxLength: 20,
                  prefixIcon: Icons.lock,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  authField: context.read<AuthValidator>().pValidator,
                ),
              ),
            ),
            _buildRicordamiRecovery(),
          ]);

//* ricordami, e recovery password
  Row _buildRicordamiRecovery() => Row(children: [
        const Text("  Ricordami"),
        const CustomCheckBox(),
        const Spacer(),
        TextButton(
          child: const Text("Password Dimenticata ?"),
          onPressed: () async {
            //todo metodo recovery password
            /* late final String message;
              try{
                if(context.read<AuthValidator>().emailValidator.isCorrect()){
                  //ho l'email; il token do lo prendo ??
                  await context.read<AuthenticationProvider>().recuperaPsw(context.read<AuthValidator>().emailValidator.content!,);
                  message = "Controlla la tua posta elettronica !";
                }else{
                  throw("Inserisci la tua email");
                }
        
              }catch(e){
                message = e.toString();
              }finally{
                showSnackBar(context, message);
              }*/
          },
        ),
      ]);
}
