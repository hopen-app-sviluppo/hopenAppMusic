import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobileWidget;
  final Widget? tabletWidget;
  final Widget? webWidget;
  const ResponsiveWidget({
    Key? key,
    required this.mobileWidget,
    this.tabletWidget,
    this.webWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, cons) {
        if (cons.maxWidth < 600) return mobileWidget;

//* l'app sarà sviluppata anche per il web??
        if (cons.maxWidth > 1200) return webWidget ?? const SizedBox();

//* size > 800 && size < 1200
        return tabletWidget ?? mobileWidget;
      });
}
