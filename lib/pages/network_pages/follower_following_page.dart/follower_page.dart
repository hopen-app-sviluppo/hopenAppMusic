import 'package:flutter/material.dart';
import 'package:music/api/social_api/social_api.dart';
import 'package:music/helpers.dart';
import 'package:music/models/social_models/follower.dart';
import 'package:music/provider/user_provider.dart';
import 'package:music/router.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

import '../../../provider/settings_provider.dart';

//pagina che mostra i follower dell'utente e i following (gli utenti che segue)
class FollowerPage extends StatefulWidget {
  //se è true, allora mostro i suoi follower
  //se è false, mostro i suoi following
  final bool showFollower;
  const FollowerPage({
    Key? key,
    required this.showFollower,
  }) : super(key: key);

  @override
  State<FollowerPage> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = widget.showFollower ? 0 : 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          //* Se faccio solo navigator.pop non mi ribuilda la pagina precedente
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.profiloUtente, (route) => false),
        ),
        title: Text(
            context.read<UserProvider>().currentUser!.socialAccount.username),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size(double.infinity,
              context.read<SettingsProvider>().config.safeBlockVertical * 10),
          child: _buildTabBar(),
        ),
      );

  PreferredSizeWidget _buildTabBar() {
    return TabBar(controller: _tabController, tabs: [
      Tab(
        child: Text(
            "Follower: ${context.read<UserProvider>().currentUser!.socialAccount.followersLength}"),
      ),
      Tab(
        child: Text(
            "Following: ${context.read<UserProvider>().currentUser!.socialAccount.followingLength}"),
      ),
    ]);
  }

  Widget _buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            _showPeople(),
            _showPeople(showFollowers: false),
          ],
        ),
      );

  Widget _showPeople({bool showFollowers = true}) {
    return ListView.builder(
        itemCount: showFollowers
            ? context
                .read<UserProvider>()
                .currentUser!
                .socialAccount
                .followersLength
            : context
                .read<UserProvider>()
                .currentUser!
                .socialAccount
                .followingLength,
        itemBuilder: (context, i) {
          final people = showFollowers
              ? context
                  .read<UserProvider>()
                  .currentUser!
                  .socialAccount
                  .followers[i]
              : context
                  .read<UserProvider>()
                  .currentUser!
                  .socialAccount
                  .following[i];
          return ListTile(
            onTap: () {
              //mostra profilo di quell'utente
            },
            title: Text(people.username),
            leading: CircleAvatar(
              foregroundImage: NetworkImage(people.avatar),
            ),
            //Se sto sulla sezione Follower, e seguo quell'utente
            trailing: showFollowers && people.loSeguo
                ? seguiGiaBtn()
                //se sto sulla Sezione dei following oppure non seguo quell'utente
                : ElevatedButton(
                    child: Text(people.loSeguo ? " Rimuovi " : "  Follow  "),
                    onPressed: () async =>
                        await followUnfollowUser(people, showFollowers),
                  ),
          );
        });
  }

  Container seguiGiaBtn() => Container(
        width: context.read<SettingsProvider>().config.safeBlockHorizontal * 25,
        height: context.read<SettingsProvider>().config.safeBlockVertical * 6,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: MainColor.secondaryColor),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: const Center(
          child: Text("Segui già"),
        ),
      );

//premuto il pulsante Segui, Rimuovi
  Future<void> followUnfollowUser(Follower people, bool showFollowers) async {
    bool makeApiCall = true;
    //se lo seguo, allora voglio rimuovere il follow (appare showDialog)
    if (people.loSeguo) {
      final bool? result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Vuoi Rimuovere ${people.username} dai tuoi Follower ?"),
          content: const Text("Puoi cambiare idea in qualsiasi momento"),
          actions: [
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Annulla")),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Rimuovi !"),
            )
          ],
        ),
      );
      if (result == null || !result) {
        makeApiCall = false;
      }
    }
    if (makeApiCall) {
      try {
        await SocialApi.followUser(
          context.read<UserProvider>().currentUser!.internalAccount.token,
          people.userId,
        );
        //se tutto va bene, allora aggiorno valori nell'utente corrente
        context
            .read<UserProvider>()
            .currentUser!
            .socialAccount
            .updateFollower(people, !people.loSeguo);
        setState(() {});
      } catch (e) {
        showSnackBar(context, "Errore", isError: true);
      }
    }
  }
}