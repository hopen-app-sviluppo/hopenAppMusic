import 'package:flutter/material.dart';

import '../../../../models/social_models/post.dart';
import '../../../../theme.dart';

//* la parte del Post in cui c'è:
//*   - Immagine profilo Publisher post
//*   - Testo del post
class PostBox extends StatelessWidget {
  final Post currentPost;
  const PostBox({
    Key? key,
    required this.currentPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.3),
          border: Border.all(width: 1, color: MainColor.secondaryColor),
        ),
        child: Column(children: [
          Row(
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(currentPost.userAvatar),
              ),
              const Spacer(flex: 1),
              Text(currentPost.username),
              const Spacer(flex: 19)
            ],
          ),
          Text(currentPost.text),
          if (currentPost.sticker != null)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(currentPost.sticker!),
                ),
              ),
            ),
        ]),
      );
}
