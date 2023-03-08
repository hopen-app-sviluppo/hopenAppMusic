import 'package:flutter/material.dart';
import 'package:music/pages/PROVA_MACHFORM/PROVA_MACHFORM_PAGE.dart';
import 'package:music/pages/network_pages/network_page.dart';
import 'package:provider/provider.dart';

import '../../../../database/db_repository.dart';
import '../../../../helpers.dart';
import '../../../network_pages/network_provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        width: MediaQuery.of(context).size.width * 0.7,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Text(
            "Music App",
            style: TextStyle(fontSize: 40.0),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text(
              "Fai un Backup dei tuoi dati !",
              style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              try {
                await DbRepository.instance.createDbBackup();
                Navigator.of(context).pop();
                showSnackBar(context, "Success !");
              } catch (e) {
                showSnackBar(
                  context,
                  "Errore nel creare un backup",
                  isError: true,
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text(
              "Hopen Network",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (context) => NetworkProvider(),
                    child: NetworkPage()),
              ),
            ),
          ),
          //* Prova mach form => da cancellare qua
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text(
              "Porva Machform",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ProvaMachform(),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text(
              "Impostazioni",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.beenhere_outlined),
            title: Text(
              "Avvertenze",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.emoji_people_outlined),
            title: Text(
              "About Us",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.how_to_vote_outlined),
            title: Text(
              "Valuta la nostra App !",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          /*   ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                updateIndex(0, isDrawer: true);
              }),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Assistiti"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => updateIndex(3, isDrawer: true),
          ),
          ListTile(
            leading: Icon(Icons.live_help),
            title: Text("Tutorial"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => updateIndex(2, isDrawer: true),
          ),
          ListTile(
            leading: Icon(Icons.new_releases),
            title: Text("News"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => updateIndex(1, isDrawer: true),
          ),*/
          const Text("Version 1.0"),
        ]),
      );
}
