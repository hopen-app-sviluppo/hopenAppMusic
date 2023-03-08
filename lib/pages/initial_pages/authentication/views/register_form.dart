import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../responsive_widget/responsive_widget.dart';
import '../../../common_widget/custom_rounded_card.dart';
import '../helper/auth_validator.dart';
import '../widgets/auth_text_field.dart';

//per la registrazione serve: username, psw, ripeti psw, email

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobileWidget: mobileSignUp(context),
      webWidget: desktopSignUp(context),
    );
  }

  Widget mobileSignUp(BuildContext context) {
    final _cardWidth = MediaQuery.of(context).size.width * 0.6;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RoundedCard(
          width: _cardWidth,
          child: AuthTextField(
            maxLength: 60,
            prefixIcon: Icons.person,
            keyboardType: TextInputType.text,
            authField: context.read<AuthValidator>().userValidator,
          ),
        ),
        RoundedCard(
          width: _cardWidth,
          child: AuthTextField(
            maxLength: 60,
            prefixIcon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            authField: context.read<AuthValidator>().emailValidator,
          ),
        ),
        RoundedCard(
          width: _cardWidth,
          child: AuthTextField(
            maxLength: 20,
            prefixIcon: Icons.lock,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            authField: context.read<AuthValidator>().pValidator,
          ),
        ),
      ],
    );
  }

  Widget desktopSignUp(BuildContext context) {
    final _cardWidth = MediaQuery.of(context).size.width * 0.4;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: _cardWidth,
          child: Card(
            child: AuthTextField(
              maxLength: 60,
              prefixIcon: Icons.person,
              keyboardType: TextInputType.text,
              authField: context.read<AuthValidator>().userValidator,
            ),
          ),
        ),
        SizedBox(
          width: _cardWidth,
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
          width: _cardWidth,
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
      ],
    );
  }

  Widget _buildElements(BuildContext context, final double cardWidth,
          final CrossAxisAlignment crossAxis) =>
      Column(
        crossAxisAlignment: crossAxis,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RoundedCard(
            width: cardWidth,
            child: AuthTextField(
              maxLength: 60,
              prefixIcon: Icons.person,
              keyboardType: TextInputType.text,
              authField: context.read<AuthValidator>().userValidator,
            ),
          ),
          RoundedCard(
            width: cardWidth,
            child: AuthTextField(
              maxLength: 60,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              authField: context.read<AuthValidator>().emailValidator,
            ),
          ),
          RoundedCard(
            width: cardWidth,
            child: AuthTextField(
              maxLength: 20,
              prefixIcon: Icons.lock,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.text,
              authField: context.read<AuthValidator>().pValidator,
            ),
          ),
        ],
      );
}
