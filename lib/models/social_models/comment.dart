import '../../helpers.dart';

abstract class CommentoSocial {
  final String id;
  final String userId;
  final String pageId;
  //se sto vedendo delle risposte ai commenti, non ho il postId
  final String text;
  final String time;
  //se il post è suo
  final bool isPostOwner;
  //se l'oggetto è il suo (post, commento, replica, ecc) => in una replica magari isPostOwner è false e is Onwer è true (il post non è di quell'utente, ma la replica si)
  final bool isOwner;
  //quanti like ha
  int likes;
  //quanti commenti ha
  int comments;
  //se ho già messo like
  bool isLiked;
  //se l'ho già commentato
  bool isCommented;
  //qualcosa sulle reazioni
  //final Map<String, dynamic> reaction;
  //todo: mettere publisher final SocialAccount publisher; per ora metto username, name, e avatar
  final String publisherName;
  final String publisherAvatar;
  final String publisherSurname;

  CommentoSocial({
    required this.id,
    required this.userId,
    required this.pageId,
    required this.text,
    required this.time,
    required this.isPostOwner,
    required this.isOwner,
    required this.comments,
    required this.likes,
    required this.isLiked,
    required this.isCommented,
    required this.publisherName,
    required this.publisherAvatar,
    required this.publisherSurname,
  });

  CommentoSocial.fromJSON(Map<String, dynamic> data)
      : id = data["id"],
        userId = data["user_id"],
        pageId = data['page_id'],
        //data['time] è un timestapmo, lo moltiplico per mille, converto in utc e lo formatto in stringa
        time = formatHour(
          DateTime.fromMillisecondsSinceEpoch(int.parse(data["time"]) * 1000),
        ),
        text = data['text'],
        isPostOwner = data['post_onwer'],
        isOwner = data['onwer'],
        comments = int.parse(data['comment_wonders']),
        likes = int.parse(data['comment_likes']),
        isLiked = data['is_comment_liked'],
        isCommented = data['is_comment_wondered'],
        publisherName = data['publisher']['first_name'],
        publisherSurname = data['publisher']['last_name'],
        publisherAvatar = data['publisher']['avatar'];

  @override
  String toString() => "commento: id: $id, likes: $likes, testo: $text";
}

class CommentoPost extends CommentoSocial {
  //id del commento a cui ha risposto
  final String postId;
  //numero di rusposte
  int repliesCount;

  CommentoPost({
    required this.postId,
    required this.repliesCount,
    required String id,
    required String userId,
    required String pageId,
    required String text,
    required String time,
    required bool isPostOwner,
    required bool isOwner,
    required int comments,
    required int likes,
    required bool isLiked,
    required bool isCommented,
    required String publisherName,
    required String publisherAvatar,
    required String publisherSurname,
  }) : super(
          id: id,
          userId: userId,
          pageId: pageId,
          text: text,
          time: time,
          isPostOwner: isPostOwner,
          isOwner: isOwner,
          comments: comments,
          likes: likes,
          isLiked: isLiked,
          isCommented: isCommented,
          publisherName: publisherName,
          publisherAvatar: publisherAvatar,
          publisherSurname: publisherSurname,
        );

  CommentoPost.fromJson(Map<String, dynamic> data)
      : postId = data['post_id'],
        repliesCount = int.parse(data['replies_count']),
        super.fromJSON(data);
}

//commento di un commento :P
class RispostaCommento extends CommentoSocial {
  //id del commento a cui ha risposto
  final String commentId;

  RispostaCommento(
      {required this.commentId,
      required String id,
      required String userId,
      required String pageId,
      required String text,
      required String time,
      required bool isPostOwner,
      required bool isOwner,
      required int comments,
      required int likes,
      required bool isLiked,
      required bool isCommented,
      required int repliesCount,
      required String publisherName,
      required String publisherAvatar,
      required String publisherSurname})
      : super(
          id: id,
          userId: userId,
          pageId: pageId,
          text: text,
          time: time,
          isPostOwner: isPostOwner,
          isOwner: isOwner,
          comments: comments,
          likes: likes,
          isLiked: isLiked,
          isCommented: isCommented,
          publisherName: publisherName,
          publisherAvatar: publisherAvatar,
          publisherSurname: publisherSurname,
        );

  RispostaCommento.fromJson(Map<String, dynamic> data)
      : commentId = data['comment_id'],
        super.fromJSON(data);
}
