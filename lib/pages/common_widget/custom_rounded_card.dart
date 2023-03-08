import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/settings_provider.dart';

//! Widget rotondo, elevazione che sta intorno ai form
class RoundedCard extends StatelessWidget {
  final Widget child;
  final bool isRoundedOnDx;
  final double? width;
  const RoundedCard(
      {Key? key, required this.child, this.width, this.isRoundedOnDx = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeConfig = context.read<SettingsProvider>().config;
    final round = sizeConfig.safeBlockVertical * 10;
    return SizedBox(
      width: width,
      height: sizeConfig.safeBlockVertical * 9,
      child: Material(
        type: MaterialType.card,
        //shadowColor: MainColor.secondaryColor,
        color: Colors.white,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: isRoundedOnDx
              ? BorderRadius.only(
                  topRight: Radius.circular(round),
                  bottomRight: Radius.circular(round),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(round),
                  bottomLeft: Radius.circular(round),
                ),
        ),
        // clipBehavior: Clip.none,
        child: child,
      ),
    );
  }
}
