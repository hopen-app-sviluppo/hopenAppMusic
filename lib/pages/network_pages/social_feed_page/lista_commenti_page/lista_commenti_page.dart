import 'package:flutter/material.dart';
import 'package:music/api/social_api/social_api.dart';
import 'package:music/helpers.dart';
import 'package:music/models/social_models/comment.dart';
import 'package:music/pages/common_widget/empty_page.dart';
import 'package:music/pages/network_pages/social_feed_page/lista_commenti_page/helper/lista_comment_provider.dart';
import 'package:music/pages/network_pages/social_feed_page/views/like_box.dart';
import 'package:music/pages/network_pages/social_feed_page/views/post_box.dart';
import 'package:music/provider/settings_provider.dart';
import 'package:music/provider/user_provider.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

import '../../../../models/social_models/post.dart';

//* pagina mostra la lista dei commenti di un post, e in basso la possibilità di scrivere il proprio !
class ListaCommentiPage extends StatefulWidget {
  //lo uso quando voglio commentare il post
  final Post currentPost;
  const ListaCommentiPage({
    Key? key,
    required this.currentPost,
  }) : super(key: key);

  @override
  State<ListaCommentiPage> createState() => _ListaCommentiPageState();
}

class _ListaCommentiPageState extends State<ListaCommentiPage> {
  bool isRefreshingComments = false;

//Icona in basso che serve per caricare altri commenti
  Widget buildRefreshCommentIndicator() => isRefreshingComments
      ? const Center(child: CircularProgressIndicator())
      : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                setState(() => isRefreshingComments = true);
                final newComments = await SocialApi.getPostsComment(
                    context
                        .read<UserProvider>()
                        .currentUser!
                        .internalAccount
                        .token,
                    widget.currentPost.id,
                    offset: widget.currentPost.postComments.length.toString());
                widget.currentPost.postComments.addAll(newComments);
                setState(() {
                  isRefreshingComments = false;
                });
              },
            ),
            const Text("Visualizza altri commenti")
          ],
        );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _buildAppBar(),
        body: GestureDetector(
          onTap: () => checkFocus(context),
          child: SizedBox(
            width: double.infinity,
            height:
                context.read<SettingsProvider>().config.safeBlockVertical * 80,
            child: _buildBody(context),
          ),
        ),
        bottomSheet: _buildNavBar(context),
      );

  PreferredSizeWidget _buildAppBar() => AppBar(
        title: const Text("Commenti"),
      );

  Widget _buildBody(BuildContext context) {
    if (widget.currentPost.postComments.isEmpty) {
      return const EmptyPage(title: "Non ci sono Commenti !");
    }

    return ListView.builder(
      itemCount: widget.currentPost.postComments.length + 2,
      itemBuilder: (context, i) {
        //Primo elemento => torno il posto fissato in alto
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                PostBox(currentPost: widget.currentPost),
                const Divider(
                  color: MainColor.secondaryColor,
                  thickness: 2.0,
                ),
              ],
            ),
          );
        }
        //Ultimo elemento => torno il refresh indicator per caricare + commenti
        if (i == widget.currentPost.postComments.length + 1) {
          return buildRefreshCommentIndicator();
        }
        //Commenti del post, tutti gli altri elementi
        final comment = widget.currentPost.postComments[i - 1];
        return buildCommentBox(comment, context);
      },
    );
  }

//* per ogni commento, mostro il suo box
  Widget buildCommentBox(CommentoPost comment, BuildContext context) =>
      ListTile(
        leading: CircleAvatar(
          foregroundImage: NetworkImage(comment.publisherAvatar),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              comment.publisherName + ' ' + comment.publisherSurname,
              style: const TextStyle(color: Colors.white60),
            ),
            Text(comment.time),
          ],
        ),
        trailing: LikeBox(comment: comment),
        //  isThreeLine: true,
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              comment.text,
              style: const TextStyle(color: Colors.white),
            ),
            GestureDetector(
              onTap: () async => context
                  .read<ListaCommentiProvider>()
                  .onFocusRequesting(comment),
              child: const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 5, right: 10),
                child: Text(
                  "Rispondi",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            //* parte dei sottocommenti (da mette i like e le risposte anche qua xD)
            _buildRisposte(comment),
          ],
        ),
      );

  Widget _buildRisposte(CommentoPost comment) =>
      Selector<ListaCommentiProvider, String>(
          selector: (context, prov) => prov.showCommentIdReplies,
          builder: (context, val, _) {
            if (comment.repliesCount == 0) {
              return const SizedBox.shrink();
            }
            //se ci sono risposte, ma non sono mostrate. appare questo
            if (comment.id != val) {
              return GestureDetector(
                child: Text("Visualizza ${comment.repliesCount} risposte"),
                onTap: () => context
                    .read<ListaCommentiProvider>()
                    .showCommentReply(comment.id),
              );
            }
            //visualizzo risposte
            return FutureBuilder(
                future: SocialApi.getCommentReplies(
                  context
                      .read<UserProvider>()
                      .currentUser!
                      .internalAccount
                      .token,
                  comment.id,
                ),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snap.hasError) return const SizedBox.shrink();

                  final data = snap.data as List<RispostaCommento>;
                  if (data.isEmpty) {
                    return const Text("Non ci sono commenti");
                  }

                  return Column(
                    children:
                        data.map((e) => _buildCommentRisposta(e)).toList(),
                  );
                });
          });

  //Risposta ad un commento
  Widget _buildCommentRisposta(RispostaCommento e) => ListTile(
        leading: CircleAvatar(
          foregroundImage: NetworkImage(e.publisherAvatar),
        ),
        title: Text(e.publisherName + ' ' + e.publisherSurname),
        subtitle: Text(e.text),
        trailing: LikeBox(
          rispostaCommento: e,
        ),
      );

//* Footer => posso scriverci commento da pubblicare
  Widget _buildNavBar(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      //se utente preme "Rispondi ad un commento, appare tastiera e questo box verde"
      Selector<ListaCommentiProvider, CommentoPost?>(
        selector: (context, prov) => prov.commentToReply,
        builder: (context, commentToReply, _) {
          if (commentToReply == null) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.all(10.0),
            decoration: const BoxDecoration(color: MainColor.secondaryColor),
            child: Row(children: [
              Expanded(
                child: Text(
                  "Rispondi a : ${context.read<ListaCommentiProvider>().commentToReply!.publisherName} ${context.read<ListaCommentiProvider>().commentToReply!.publisherSurname}",
                ),
              ),
              InkWell(
                onTap: () => context.read<ListaCommentiProvider>().onUnfocus(),
                child: const Icon(Icons.close),
              ),
            ]),
          );
        },
      ),
      Container(
        height: context.read<SettingsProvider>().config.safeBlockVertical * 10,
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: MainColor.secondaryColor,
              width: 1,
            ),
          ),
        ),
        child: Row(children: [
          //immagine utente
          CircleAvatar(
            foregroundImage: NetworkImage(
                context.read<UserProvider>().currentUser!.socialAccount.avatar),
          ),
          //scrivi commento
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: _buildTextField(context),
            ),
          ),
          //pubblicare commento ad un post oppure una risposta
          TextButton(
            child: const Text("Pubblica"),
            onPressed: () async => _publicComment(context),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildTextField(BuildContext context) => TextField(
        focusNode: context.read<ListaCommentiProvider>().focusNode,
        controller: TextEditingController(),
        style: const TextStyle(color: Colors.white),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(hintText: "Commenta. . ."),
        onChanged: context.read<ListaCommentiProvider>().onTextFieldValUpdate,
        onSubmitted: (content) async => await _publicComment(context),
      );

  Future<void> _publicComment(BuildContext context) async {
    final String? commentText =
        context.read<ListaCommentiProvider>().textFieldVal;
    //pubblica commento
    if (commentText == null) return;

    try {
      //* pubblico una risposta ad un commento
      if (context.read<ListaCommentiProvider>().commentToReply != null) {
        await SocialApi.callApiComment(
          token:
              context.read<UserProvider>().currentUser!.internalAccount.token,
          commentId: context.read<ListaCommentiProvider>().commentToReply!.id,
          apiType: ApiCommentType.replyToComment,
          replyContent: commentText,
        );
        // aggiorno il numero delle risposte al commento
        context.read<ListaCommentiProvider>().commentToReply!.repliesCount++;
      } else {
        //* Commento un Post !
        await SocialApi.commentPost(
          context.read<UserProvider>().currentUser!.internalAccount.token,
          widget.currentPost.id,
          commentText,
        );
        //incremento il numero dei commenti del post
        widget.currentPost.numComments++;
      }
      setState(() {});

      //tolgo il focus, pulisco il textfield, chiudo tutte le risposte ai commenti
      context.read<ListaCommentiProvider>()
        ..clearCommentIdReply()
        ..clearTextFieldVal()
        ..onUnfocus();
      showSnackBar(
        context,
        "Commento pubblicato !",
      );
      return;
    } catch (e) {
      print("errore: $e");
      showSnackBar(
        context,
        "Errore nel pubblicare il commento",
        isError: true,
      );
    }
  }
}
