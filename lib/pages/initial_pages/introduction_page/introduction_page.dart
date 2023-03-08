import 'package:flutter/material.dart';
import 'package:music/pages/initial_pages/introduction_page/desktop/desktop_introduction_page.dart';
import 'package:music/pages/initial_pages/introduction_page/mobile/mobile_introduction_page.dart';
import 'package:music/responsive_widget/responsive_widget.dart';

//* pagina mostrata la prima volta che si avvia l'app !

//* Per mobile => una pagina per volta
//* per Desktop => una pagina sopra all'altra, in alto a dx bottoni Login e registrazione (come todo app che ho scaricato)
class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const ResponsiveWidget(
        mobileWidget: MobileIntroductionPage(),
        webWidget: DesktopIntroductionPage(),
      );
}
