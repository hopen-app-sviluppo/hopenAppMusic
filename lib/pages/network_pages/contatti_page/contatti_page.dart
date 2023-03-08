import 'package:flutter/material.dart';
import 'package:music/models/social_models/follower.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/provider/user_provider.dart';
import 'package:music/router.dart';
import 'package:provider/provider.dart';

class ContattiPage extends StatelessWidget {
  const ContattiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //todo cambiare
    final List<Follower> userFollowing =
        context.read<UserProvider>().currentUser!.socialAccount.followers;

    if (userFollowing.isEmpty) {
      return const EmptyPage(title: "Inzia a Seguire qualcuno !");
    }
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView.builder(
          itemCount: userFollowing.length,
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(userFollowing[i].username),
              leading: CircleAvatar(
                foregroundImage: NetworkImage(userFollowing[i].avatar),
              ),
              trailing: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    Navigator.of(context).pushNamed(AppRouter.socialChat,
                        arguments: userFollowing[i]);
                  }),
            );
          }),
    );
  }
}
