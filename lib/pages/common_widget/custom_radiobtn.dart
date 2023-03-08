import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/settings_provider.dart';
import '../../theme.dart';

//* radio button in alto sulla registrazione utente e creazione assistito

class CustomRadioBtn extends StatelessWidget {
  final bool isStepChecked;
  final bool isBlueColor;
  final String text;
  final String number;
  const CustomRadioBtn({
    Key? key,
    this.isStepChecked = true,
    this.isBlueColor = true,
    required this.text,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeConfig = context.read<SettingsProvider>().config;
    return Container(
      padding: const EdgeInsets.only(right: 5.0),
      decoration: isStepChecked
          ? BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: MainColor.redColor,
              ),
              borderRadius:
                  BorderRadius.circular(sizeConfig.safeBlockHorizontal * 10),
              color: MainColor.redColor.withOpacity(0.5),
            )
          : null,
      child: Row(children: [
        Card(
          shape: const CircleBorder(),
          color:
              isBlueColor ? MainColor.primaryColor : MainColor.secondaryColor,
          child: SizedBox(
            width: sizeConfig.safeBlockHorizontal * 8,
            height: sizeConfig.safeBlockVertical * 7,
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: !isBlueColor
                      ? MainColor.primaryColor
                      : MainColor.secondaryColor,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ]),
    );
  }
}
