import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../provider/authentication_provider.dart';

class MobileIntroductionPage extends StatefulWidget {
  const MobileIntroductionPage({Key? key}) : super(key: key);

  @override
  State<MobileIntroductionPage> createState() => _MobileIntroductionPageState();
}

class _MobileIntroductionPageState extends State<MobileIntroductionPage> {
  late final PageController controller;
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Benvenuto da HopenUp"), actions: [
        TextButton(
          child: const Text("Skip"),
          onPressed: () => goToAuthPage(),
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80.0, left: 10.0, right: 10.0),
        child: PageView(
          controller: controller,
          onPageChanged: (newPageIndex) => setState(() {
            pageIndex = newPageIndex;
          }),
          children: [
            singlePage(
              "assets/1.jpg",
              "Monitora l'andamento dei tuoi assistiti in modo facile, veloce, preciso !",
            ),
            singlePage(
              "assets/2.jpg",
              "Collabora con altri esperti del settore grazie ad Hopen Network !",
            ),
            singlePage(
              "assets/3.jpg",
              "Aiutaci in qualsiasi momento a migliorare l'App !",
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  Widget singlePage(String imagePath, String text) => Column(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ],
      );

  Widget _buildNavBar() => SizedBox(
        width: double.infinity,
        height: 80.0,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            flex: 2,
            child: TextButton(
              onPressed: () {
                controller.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              },
              child: const Text("Back"),
            ),
          ),
          Expanded(
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
            ),
          ),
          Expanded(
            flex: 2,
            child: TextButton(
              onPressed: () {
                pageIndex != 2
                    ? controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      )
                    : goToAuthPage();
              },
              child: Text(pageIndex == 2 ? "Get Started !" : "Next"),
            ),
          ),
        ]),
      );

  void goToAuthPage() => context
      .read<AuthenticationProvider>()
      .updateAuthState(AuthState.loggedOut);
}
