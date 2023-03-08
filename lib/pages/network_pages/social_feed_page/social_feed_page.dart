import 'package:flutter/material.dart';
import 'package:music/api/social_api/social_api.dart';
import 'package:music/models/social_models/post.dart';
import 'package:music/pages/common_widget/custom_shimmer.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/pages/common_widget/error_page.dart';
import 'package:music/provider/settings_provider.dart';
import 'package:music/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../router.dart';
import 'views/like_box.dart';
import 'views/post_box.dart';

//* Pagina che mostra il feed del social network (i vari post degli altri utenti)

class SocialFeedPage extends StatelessWidget {
  const SocialFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SocialApi.getFeed(
          context.read<UserProvider>().currentUser!.internalAccount.token,
        ),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const ShimmerListView();
          }

          if (snap.hasError) {
            return ErrorPage(error: snap.error.toString());
          }
          final posts = snap.data as List<Post>;
          if (posts.isEmpty) {
            return const EmptyPage(title: "Nessun post Trovato");
          }

          return ListView.builder(
            //gli do un padding in basso alla fine
            itemCount: posts.length + 1,
            itemBuilder: (context, i) => i + 1 != posts.length + 1
                //altezza del bottone
                ? _buildPost(context, posts[i])
                : SizedBox(
                    height: context
                            .read<SettingsProvider>()
                            .config
                            .blockSizeVertical *
                        5),
          );
        });
  }

//contenuto del Post (immagine profilo publisher, testo, icone like commenta condividi)
  Widget _buildPost(BuildContext context, Post currentPost) => Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            PostBox(currentPost: currentPost),
            //* icone like, commenta, condividi
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LikeBox(post: currentPost),
                const Spacer(flex: 1),
                InkWell(
                  onTap: () => goToCommentsPage(context, currentPost),
                  child: const Icon(Icons.message),
                ),
                const Spacer(flex: 1),
                const Icon(Icons.send),
                const Spacer(flex: 7),
                Text(currentPost.date),
              ],
            ),
            // if (currentPost.numLikes > 0)
            //   Align(
            //     alignment: Alignment.topLeft,
            //     child: Text("Piace a ${currentPost.numLikes}"),
            //   ),
            if (currentPost.numComments > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => goToCommentsPage(context, currentPost),
                  child:
                      Text("Visualizza i ${currentPost.numComments} commenti"),
                ),
              ),
          ],
        ),
      );

//navigo sulla pagina dei commenti di un Post
  void goToCommentsPage(BuildContext context, Post currentPost) =>
      Navigator.of(context).pushNamed(
        AppRouter.commentiPostSocial,
        arguments: currentPost,
      );
}
