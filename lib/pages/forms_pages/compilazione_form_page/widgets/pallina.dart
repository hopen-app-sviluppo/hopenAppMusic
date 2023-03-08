import 'package:flutter/material.dart';
import 'package:music/provider/settings_provider.dart';
import 'package:provider/provider.dart';

//pagina compilazione form => singola Pallina nella bottom app bar
class Pallina extends StatelessWidget {
  final bool isSelected;
  const Pallina({
    Key? key,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(5.0),
        width: context.read<SettingsProvider>().config.safeBlockHorizontal * 5,
        height: context.read<SettingsProvider>().config.safeBlockVertical * 3,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          shape: BoxShape.circle,
        ),
      );
}
