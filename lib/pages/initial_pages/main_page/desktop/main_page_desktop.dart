import 'package:flutter/material.dart';
import 'package:music/pages/initial_pages/main_page/widgets/floating_act_btn.dart';
import 'package:music/pages/initial_pages/main_page/widgets/main_drawer.dart';
import 'package:music/pages/network_pages/news_page/helper/news_provider.dart';
import 'package:music/pages/network_pages/news_page/news_page.dart';
import 'package:music/pages/tutorials_page/tutorials_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../helpers.dart';
import 'package:provider/provider.dart';
import '../../../../provider/authentication_provider.dart';
import '../../../../router.dart';
import '../../../../theme.dart';
import '../../../assistito_pages/lista_assistiti_page/lista_assistiti_page.dart';
import '../../../profilo_utente_page/profilo_utente_page.dart';
import '../../../tutorials_page/helper/tutorial_provider.dart';

//* pagina principale => contiene scaffold, bottom navigation bar, app bar, e il body è in base alla pagina selezionata

class MainPageDesktop extends StatefulWidget {
  final int index;
  const MainPageDesktop({
    Key? key,
    this.index = 0,
  }) : super(key: key);

  @override
  State<MainPageDesktop> createState() => _MainPageDesktopState();
}

class _MainPageDesktopState extends State<MainPageDesktop>
    with SingleTickerProviderStateMixin {
  //valore inizializzato a 0, ma posso passarglelo come parametro
  late int currentIndex;
  //* lista di lunghezza fissa contente le app bar delle varie pagine
  late final List<PreferredSizeWidget> appBars;
  //controller utile per network page

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Musica per la Relazione d'Aiuto "),
          bottom: _buildTabBar(),
          centerTitle: true,
          actions: [
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  try {
                    await context.read<AuthenticationProvider>().logOut();
                    //di ignoranza, se non funziona, navigo indietro su pagina di login
                    if (ModalRoute.of(context)?.settings.name !=
                        AppRouter.auth) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRouter.auth, (route) => false);
                    }
                  } catch (e) {
                    showSnackBar(context, e.toString(), isError: true);
                  }
                }),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _buildBody(),
        ),
        drawer: const MainDrawer(),
        floatingActionButton: const FloatingActBtn(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      );

  PreferredSizeWidget _buildTabBar() => PreferredSize(
        preferredSize: Size(
          double.infinity,
          MediaQuery.of(context).size.height * 0.1,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: BottomAppBar(
                shape: const CircularNotchedRectangle(),
                color: MainColor.secondaryColor,
                elevation: 0.0,
                notchMargin: 4.0,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Expanded(
                    child: _buildNavBarElement(
                      selectedIcon: Icons.home, //Icons.person,
                      unselectedIcon: Icons.home_filled, //Icons.person_outline,
                      index: 0,
                      name: "    Home   ",
                    ),
                  ),
                  Expanded(
                    child: _buildNavBarElement(
                      selectedIcon: Icons.new_releases, //Icons.new_releases,
                      unselectedIcon: Icons
                          .new_releases_outlined, //Icons.new_releases_outlined,
                      index: 1,
                      name: "     News    ",
                    ),
                  ),
                  const Spacer(flex: 2),
                  Expanded(
                    child: _buildNavBarElement(
                      selectedIcon: Icons.live_help,
                      unselectedIcon: Icons.live_help_outlined,
                      index: 2,
                      name: "Tutorials",
                    ),
                  ),
                  Expanded(
                    child: _buildNavBarElement(
                      selectedIcon: Icons.people,
                      unselectedIcon: Icons.people_outline,
                      index: 3,
                      name: "Assistiti",
                    ),
                  ),
                ]),
              ),
            ),
            //Icona Hopen Network
            InkWell(
              onTap: () async {
                await launchUrl(Uri.parse("https://hopennetwork.it"));
              },
              child: Column(children: [
                Container(
                  width: 150,
                  height: 40,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/social.png"),
                    ),
                  ),
                ),
                const FittedBox(child: Text("Hopen Network")),
              ]),
            ),
          ],
        ),
      );

  Widget _buildNavBarElement({
    required IconData selectedIcon,
    required IconData unselectedIcon,
    required int index,
    required String name,
  }) {
    final Color color =
        currentIndex == index ? MainColor.primaryColor : Colors.white;
    return InkWell(
      onTap: () => updateIndex(index),
      borderRadius: BorderRadius.circular(25.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            currentIndex == index ? selectedIcon : unselectedIcon,
            color: color,
          ),
          Text(
            name,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }

  void updateIndex(int newIndex, {bool isDrawer = false}) {
    if (isDrawer) {
      Navigator.of(context).pop();
    }
    setState(() {
      currentIndex = newIndex;
    });
  }

  Widget _buildBody() {
    switch (currentIndex) {
      case 1:
        return ChangeNotifierProvider<NewsProvider>(
          create: (context) => NewsProvider(),
          child: const NewsPage(),
        );
      case 2:
        return ChangeNotifierProvider<TutorialProvider>(
          create: (context) => TutorialProvider(),
          child: const TutorialsPage(),
        );
      case 3:
        return const ListaAssistitiPage();
      default:
        return const ProfiloUtentePage();
    }
  }
}
