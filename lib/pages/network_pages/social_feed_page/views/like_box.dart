import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../api/social_api/social_api.dart';
import '../../../../models/social_models/comment.dart';
import '../../../../models/social_models/post.dart';
import '../../../../provider/user_provider.dart';
import '../../../../theme.dart';

class LikeBox extends StatefulWidget {
  //se passo post, sto mettendo like al post
  //se passo commentoSocial => so mettend like ad un commento
  // se non passo nulla => sto mettendo like ad una risposta
  final Post? post;
  final CommentoSocial? comment;
  final RispostaCommento? rispostaCommento;
  const LikeBox({
    Key? key,
    this.post,
    this.comment,
    this.rispostaCommento,
  }) : super(key: key);

  @override
  State<LikeBox> createState() => _LikeBoxState();
}

class _LikeBoxState extends State<LikeBox> {
  @override
  Widget build(BuildContext context) {
    if (widget.post != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async => await likePost(),
            child: widget.post!.isLiked
                ? const Icon(Icons.favorite, color: MainColor.secondaryColor)
                : const Icon(Icons.favorite_outline),
          ),
          Text("${widget.post!.numLikes}")
        ],
      );
    }

    if (widget.comment != null) {
      return InkWell(
        onTap: () async => await likeComment(),
        child: widget.comment!.isLiked
            ? const Icon(Icons.favorite, color: MainColor.secondaryColor)
            : const Icon(Icons.favorite_outline),
      );
    }

//like ad una risposta di un commento => rispostaCommento deve essere non null se arrivo qua
    return InkWell(
      onTap: () async => await likeRispostaComment(),
      child: widget.rispostaCommento!.isLiked
          ? const Icon(Icons.favorite, color: MainColor.secondaryColor)
          : const Icon(Icons.favorite_outline),
    );
  }

  Future<void> likeRispostaComment() async {
    try {
      await SocialApi.callApiComment(
        token: context.read<UserProvider>().currentUser!.internalAccount.token,
        commentId: null,
        apiType: ApiCommentType.replyLike,
        replyId: widget.rispostaCommento!.id,
      );
      print("ciao sono qua");
      if (widget.rispostaCommento!.isLiked) {
        widget.rispostaCommento!.isLiked = false;
        widget.rispostaCommento!.likes--;
      } else {
        widget.rispostaCommento!.isLiked = true;
        widget.rispostaCommento!.likes++;
      }
      setState(() {});
    } catch (e) {
      print("errore: $e");
    }
  }

  Future<void> likeComment() async {
    try {
      await SocialApi.callApiComment(
        token: context.read<UserProvider>().currentUser!.internalAccount.token,
        commentId: widget.comment!.id,
        apiType: ApiCommentType.like,
      );
      if (widget.comment!.isLiked) {
        widget.comment!.isLiked = false;
        widget.comment!.likes--;
      } else {
        widget.comment!.isLiked = true;
        widget.comment!.likes++;
      }
      setState(() {});
    } catch (e) {
      print("errore: $e");
    }
  }

  Future<void> likePost() async {
    final String? action = await SocialApi.likePost(
      context.read<UserProvider>().currentUser!.internalAccount.token,
      widget.post!.id,
    );
    //se action è null (c'è stato un errore, non faccio nulla !)
    if (action != null) {
      if (action == "liked") {
        widget.post!.isLiked = true;
        widget.post!.numLikes++;
      } else if (action == "unliked") {
        widget.post!.isLiked = false;
        widget.post!.numLikes--;
      }
      setState(() {});
    }
  }
}
