import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/database/client_operations.dart';
import 'package:music/models/cliente.dart';
import 'package:music/models/user/user.dart';
import 'package:music/pages/common_widget/immagine_profilo.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';
import '../../../router.dart';
import '../../../helpers.dart';

class ProfiloUtentePage extends StatelessWidget {
  const ProfiloUtentePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().currentUser!;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          if (Platform.isAndroid || Platform.isIOS)
            Expanded(flex: 3, child: _buildImgProfileFollower(context, user)),
          Expanded(flex: 1, child: _buildCredenziali(context)),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 9,
                  child: _buildBox(
                    context,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildTitleBox(Icons.timeline_outlined, "Panoramica"),
                          _buildNumeroAssistiti(context),
                          _buildFormCompilati(context),
                          _buildFeedbackInviati(context, user),
                        ]),
                  ),
                ),
                const Spacer(flex: 2),
                Expanded(
                  flex: 9,
                  child: _buildBox(
                    context,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTitleBox(Icons.touch_app_outlined, "Azioni"),
                        _buildTxtBtn(
                          context,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Icon(Icons.pie_chart_outline),
                                Expanded(
                                  child: Center(
                                    child: FittedBox(
                                      child: Text("Grafici assistiti"),
                                    ),
                                  ),
                                ),
                              ]),
                          onPressed: () async {
                            try {
                              final List<Cliente> userClients =
                                  await ClienteOperations.getUserClients(
                                context.read<UserProvider>().currentUser!.id,
                              );
                              Navigator.of(context)
                                  .pushNamed(AppRouter.grafici, arguments: [
                                false,
                                userClients,
                              ]);
                            } catch (e) {
                              showSnackBar(context, "Errore Indesiderato !");
                            }
                          },
                        ),
                        _buildTxtBtn(
                          context,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons.edit_outlined),
                                Expanded(
                                  child: Center(
                                    child: Text("Compila form"),
                                  ),
                                ),
                              ]),
                          onPressed: () => Navigator.of(context)
                              .pushNamed(AppRouter.sceltaFormPage),
                        ),
                        _buildTxtBtn(
                          context,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(Icons.visibility),
                                Expanded(
                                  child: Center(
                                    child:
                                        FittedBox(child: Text("Compilazioni")),
                                  ),
                                ),
                              ]),
                          onPressed: () => Navigator.of(context).pushNamed(
                            AppRouter.formListPage,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //* Immagine profilo, follower e following
  Widget _buildImgProfileFollower(BuildContext context, User user) => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(children: [
              ImmagineProfilo(
                avatar: user.socialAccount.avatar,
                backgroundColor: Colors.blue.withOpacity(0.3),
              ),
              Text(
                user.socialAccount.nome == ""
                    ? user.socialAccount.email
                    : user.socialAccount.nome +
                        " " +
                        user.socialAccount.cognome,
                maxLines: 2,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                ),
              ),
            ]),
            //follower
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: AssetImage("assets/logo.png"),
                  width: 200,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(AppRouter.followerPage, arguments: true),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "${user.socialAccount.followersLength}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text("followers")
                        ],
                      ),
                    ),
                    TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                            AppRouter.followerPage,
                            arguments: false),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${user.socialAccount.followingLength}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Text("following")
                          ],
                        )),
                  ],
                )
              ],
            ),
            //mettere following,
          ]);

//* credenziali utente
  Widget _buildCredenziali(BuildContext context) => Align(
        alignment: Alignment.topRight,
        child: TextButton(
          child: const Text(
            "le tue credenziali",
            style: TextStyle(decoration: TextDecoration.underline),
          ),
          onPressed: () =>
              Navigator.of(context).pushNamed(AppRouter.credenziali),
        ),
      );

  //* Box del menu
  Widget _buildBox(
    BuildContext context, {
    required Widget child,
  }) =>
      Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.blue.withOpacity(0.3),
        ),
        child: child,
      );

//* bottoni del menu a DX
  Widget _buildTxtBtn(
    BuildContext context, {
    required Widget child,
    required void Function()? onPressed,
  }) =>
      Container(
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: MainColor.secondaryColor),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: TextButton(
          child: child,
          onPressed: onPressed,
        ),
      );

  //* box Panoramica e Azioni
  Widget _buildTitleBox(IconData iconData, String text) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(iconData),
          Expanded(
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      );
//* Numero degli assistiti
  Widget _buildNumeroAssistiti(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.people_outline),
          Expanded(
            child: FutureBuilder(
                future: context.read<UserProvider>().countAssistiti(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  if (snap.hasError) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        snap.data.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Assistiti"),
                    ],
                  );
                }),
          )
        ],
      );

  Widget _buildFormCompilati(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.check_outlined),
          Expanded(
            child: FutureBuilder(
                future: context.read<UserProvider>().countFormCompilati(),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  if (snap.hasError) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        snap.data.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Form compilati"),
                    ],
                  );
                }),
          )
        ],
      );

  Widget _buildFeedbackInviati(BuildContext context, User user) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.feedback_outlined),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "${user.internalAccount.feedbackInviati}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text("Feedback inviati"),
                ]),
          )
        ],
      );
}
