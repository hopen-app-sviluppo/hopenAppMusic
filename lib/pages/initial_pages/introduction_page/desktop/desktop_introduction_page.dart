import 'package:flutter/material.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

import '../../../../provider/authentication_provider.dart';

class DesktopIntroductionPage extends StatelessWidget {
  const DesktopIntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      );

//* nome app / azienda a sx
//* login - signup a dx
  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
        elevation: 0.0,
        title: const Text("HopenUp SRL (logo)"),
        actions: [
          TextButton(
            child: const Text("login"),
            onPressed: () => context
                .read<AuthenticationProvider>()
                .updateAuthState(AuthState.loggedOut),
          ),
        ],
      );

  //* single child scroll view
  Widget _buildBody(BuildContext context) => SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              padding: const EdgeInsets.all(40),
              color: MainColor.secondaryColor,
              child: Row(children: const [
                Expanded(
                  child: Text("Musica per la Relazione di aiuto"),
                ),
                Expanded(child: Text("immaginetta")),
              ]),
            ),
            _buildImageBox(
              "assets/1.jpg",
              "Monitora l'andamento dei tuoi assistiti in modo facile, veloce, preciso !",
            ),
            _buildImageBox(
              "assets/2.jpg",
              "Collabora con altri esperti del settore grazie ad Hopen Network !",
              alignImageOnDx: true,
            ),
            _buildImageBox(
              "assets/3.jpg",
              "Aiutaci in qualsiasi momento a migliorare l'App !",
            ),
            //* Un footer ce lo mettiamo ?
          ]),
        ),
      );

  Widget _buildImageBox(
    String assetPath,
    String desc, {
    bool alignImageOnDx = false,
  }) {
    //allineo immagine a destra o a sinistra?
    final List<Widget> children = alignImageOnDx
        ? [
            Expanded(flex: 2, child: Text(desc)),
            const Spacer(),
            Expanded(
              flex: 3,
              child: Image(
                image: AssetImage(assetPath),
              ),
            ),
          ]
        : [
            Expanded(
              flex: 3,
              child: Image(
                image: AssetImage(assetPath),
              ),
            ),
            const Spacer(),
            Expanded(flex: 2, child: Text(desc)),
          ];
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Row(
        children: children,
      ),
    );
  }
}
