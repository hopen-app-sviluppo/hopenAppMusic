import 'package:music/helpers.dart';
import 'package:music/models/social_models/comment.dart';

class Post {
  final String id;
  final String userId;
  final String text;
  final String date;
  // //un eventuale GIF inserita nel post
  final String? sticker;
  final String username;
  final String userAvatar;
  final String time;
  final String likes;
  final String shares;
  List<CommentoPost> postComments;
  int numLikes;
  int numComments;
  bool isLiked;
//! inserire Lista commenti

  Post({
    required this.id,
    required this.userId,
    required this.text,
    required this.date,
    required this.sticker,
    required this.userAvatar,
    required this.username,
    required this.time,
    required this.likes,
    required this.shares,
    required this.numLikes,
    required this.numComments,
    required this.isLiked,
    required this.postComments,
  });

  Post.fromJSON(Map<String, dynamic> data)
      : id = data["post_id"],
        userId = data["user_id"],
        //data['time] è un timestapmo, lo moltiplico per mille, converto in utc e lo formatto in stringa
        date = formatHour(
          DateTime.fromMillisecondsSinceEpoch(int.parse(data["time"]) * 1000),
        ),
        text = data["postText"],
        sticker = data["postSticker"],
        username = data['publisher']['username'],
        userAvatar = data['publisher']['avatar'],
        time = data['time'],
        likes = data["post_likes"],
        shares = data["post_shares"],
        numLikes = int.parse(data['post_likes']),
        numComments = int.parse(data['post_comments']),
        isLiked = data['is_liked'],
        postComments = List.generate(
          data['get_post_comments'].length,
          (index) => CommentoPost.fromJson(data['get_post_comments'][index]),
        );

  @override
  String toString() =>
      "likes: $likes, commenti: $numComments, text: $text, user: $username";
}
