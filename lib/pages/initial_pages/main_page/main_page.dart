import 'package:flutter/material.dart';
import 'package:music/pages/initial_pages/main_page/desktop/main_page_desktop.dart';
import 'package:music/pages/initial_pages/main_page/mobile/main_page_mobile.dart.dart';
import 'package:music/responsive_widget/responsive_widget.dart';

class MainPage extends StatelessWidget {
  final int index;
  const MainPage({
    Key? key,
    this.index = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ResponsiveWidget(
        mobileWidget: MainPageMobile(index: index),
        webWidget: MainPageDesktop(index: index),
      );
}
