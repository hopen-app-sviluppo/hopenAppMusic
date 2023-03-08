import 'package:flutter/material.dart';
import 'package:music/pages/initial_pages/main_page/widgets/main_drawer.dart';
import 'package:music/pages/network_pages/network_page.dart';
import 'package:music/pages/network_pages/news_page/helper/news_provider.dart';
import 'package:music/pages/network_pages/news_page/news_page.dart';
import 'package:music/pages/tutorials_page/helper/tutorial_provider.dart';
import 'package:music/provider/authentication_provider.dart';
import 'package:music/router.dart';

import '../../../../helpers.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';
import '../../../assistito_pages/lista_assistiti_page/lista_assistiti_page.dart';
import '../../../profilo_utente_page/profilo_utente_page.dart';
import '../../../tutorials_page/tutorials_page.dart';
import '../widgets/floating_act_btn.dart';

//* pagina principale => contiene scaffold, bottom navigation bar, app bar, e il body è in base alla pagina selezionata

class MainPageMobile extends StatefulWidget {
  final int index;
  const MainPageMobile({
    Key? key,
    this.index = 0,
  }) : super(key: key);

  @override
  State<MainPageMobile> createState() => _MainPageMobileState();
}

class _MainPageMobileState extends State<MainPageMobile>
    with SingleTickerProviderStateMixin {
  //valore inizializzato a 0, ma posso passarglelo come parametro
  late int currentIndex;
  //* lista di lunghezza fissa contente le app bar delle varie pagine
  late final List<PreferredSizeWidget> appBars;
  //controller utile per network page
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    _tabController = TabController(length: 3, vsync: this);
    appBars = [
      _buildHomeAppBar(context),
      //_buildNetworkAppBar(context),
      _buildNewsAppBar(context),
      _buildTutorialAppBar(context),
      _buildAssistitiAppBar(context),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void updateIndex(int newIndex, {bool isDrawer = false}) {
    if (isDrawer) {
      Navigator.of(context).pop();
    }
    setState(() {
      currentIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: appBars[currentIndex],
        body: Padding(
          //non vado sopra al floating action button in basso
          padding: const EdgeInsets.only(bottom: 15.0),
          child: _buildBody(),
        ),
        floatingActionButton: const FloatingActBtn(),
        bottomNavigationBar: _buildNavBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        drawer: const MainDrawer(),
      );

  //*************************************************************************************************
  //* DEFINISCO LE APP BAR DELLE VARIE PAGINE

  PreferredSizeWidget _buildHomeAppBar(BuildContext context) => _buildAppBar();

  //PreferredSizeWidget _buildNetworkAppBar(BuildContext context) => AppBar(
  //      title: const Text("OPEN CLOUD  HEALTHCARE NETWORK"),
  //      bottom: TabBar(controller: _tabController, tabs: [
  //        _buildTab(
  //          const Icon(Icons.face),
  //          const Text("Feed"),
  //        ),
  //        _buildTab(
  //          const Icon(Icons.new_releases),
  //          const Text("News"),
  //        ),
  //        _buildTab(
  //          const Icon(Icons.contact_page),
  //          const FittedBox(child: Text("Contatti")),
  //        ),
  //      ]),
  //    );

  // Tab _buildTab(Icon icon, Widget child) => Tab(icon: icon, child: child);

  PreferredSizeWidget _buildNewsAppBar(BuildContext context) =>
      _buildAppBar(title: "HopenUp News");

  PreferredSizeWidget _buildTutorialAppBar(BuildContext context) =>
      _buildAppBar(title: "Video Tutorial");
  PreferredSizeWidget _buildAssistitiAppBar(BuildContext context) =>
      _buildAppBar(title: "I tuoi Assistiti");

  PreferredSizeWidget _buildAppBar({String? title}) => AppBar(
          centerTitle: true,
          title: Text(title ?? "Musica per la Relazione d'Aiuto "),
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
          ]);

  //*************************************************************************************************

  //? ************************************************************************************************
  //? DEFINISCO IL BODY

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

//? ************************************************************************************************

//? ************************************************************************************************
//? DEFINISCO LA BOTTOM NAVIGATION BAR

  Widget _buildNavBar() => SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          color: MainColor.secondaryColor,
          elevation: 10.0,
          notchMargin: 5.0,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildNavBarElement(
                  selectedIcon: Icons.home, //Icons.person,
                  unselectedIcon: Icons.home_filled, //Icons.person_outline,
                  index: 0,
                  name: "    Home   ",
                ),
                _buildNavBarElement(
                  selectedIcon: Icons.share, //Icons.new_releases,
                  unselectedIcon:
                      Icons.share_outlined, //Icons.new_releases_outlined,
                  index: 1,
                  name: "    News  ",
                  rotate: true,
                ),
                const SizedBox(width: 32.0),
                _buildNavBarElement(
                  selectedIcon: Icons.live_help,
                  unselectedIcon: Icons.live_help_outlined,
                  index: 2,
                  name: "Tutorials",
                ),
                _buildNavBarElement(
                  selectedIcon: Icons.people,
                  unselectedIcon: Icons.people_outline,
                  index: 3,
                  name: "Assistiti",
                ),
              ]),
        ),
      );

  Widget _buildNavBarElement({
    required IconData selectedIcon,
    required IconData unselectedIcon,
    required int index,
    required String name,
    bool rotate = false,
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
          rotate
              ? Transform.rotate(
                  angle: 1.58,
                  child: Icon(
                    currentIndex == index ? selectedIcon : unselectedIcon,
                    color: color,
                  ),
                )
              : Icon(currentIndex == index ? selectedIcon : unselectedIcon,
                  color: color),
          Text(
            name,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
