import 'package:http/http.dart' as http;
import 'package:music/models/social_models/chat.dart';
import 'package:music/models/social_models/follower.dart';
import 'dart:convert' as convert;

import 'package:music/api/social_api/social_keys.dart';
import 'package:music/models/social_models/post.dart';
import 'package:music/models/user/social_account.dart';

import '../../models/social_models/comment.dart';

//TODO: mettere un time limit alla richiesta (7-8 secondi max)

class SocialApi {
  //passo username e psw, torna access token e user_id
  static Future<List<String>> getUserTokenId(
    String username,
    String psw,
  ) async {
    final url = Uri.parse(socialUrl + 'auth');
    try {
      //la response mi ridà l'access token e l'user_id
      final response = await http.post(
        url,
        body: {
          'server_key': serverKey,
          'username': username,
          'password': psw,
        },
      );
      final body = convert.jsonDecode(response.body);
      if (body['api_status'] == 200) {
        return [body['access_token'], body['user_id']];
      }
      throw (body['errors']['error_text']);
    } catch (error) {
      rethrow;
    }
  }

//passo access_token, user_id, ottengo i dati dell'utente !

//socialUser
  static Future<SocialAccount> getUserData({
    required String token,
    required String id,
  }) async {
    final url = Uri.parse(socialUrl + 'get-user-data?access_token=$token');
    try {
      final response = await http.post(
        url,
        body: {
          'server_key': serverKey,
          'user_id': id,
          'fetch': 'followers,following,user_data',
        },
      );
      final body = convert.jsonDecode(response.body);
      //!final User newUser = User.fromJSON(body['user_data']);
      if (body['api_status'] == 200 || body['api_status'] == 220) {
        //success
        // print("ecco booody: $body");
        final List followersMap = body['followers'];
        final List followingMap = body['following'];
        final List<Follower> followers = List.generate(
          followersMap.length,
          (i) {
            return Follower.fromJSON(followersMap[i]);
          },
        );

        final List<Follower> following = List.generate(
          followingMap.length,
          (i) {
            return Follower.fromJSON(followingMap[i]);
          },
        );
        return SocialAccount.fromJSON(
            body['user_data'], followers, following, response.headers);
        /*   return User.fromJSON(
          body['user_data'],
          token: token,
        );*/
      }
      //questo errore lo da quando un account è registrato, ma non verificato !
      if (body['errors']['error_id'] == 2) {
        throw ("Devi verificare il tuo account!\nPer favore, controlla la tua email");
      }
      throw (body['errors']['error_text']);
    } catch (e) {
      rethrow;
    }
  }

  static Future<String> createAccount(
    String username,
    String p,
    String email,
  ) async {
    final url = Uri.parse(socialUrl + 'create-account');
    try {
      final response = await http.post(url, body: {
        'server_key': serverKey,
        'username': username,
        'password': p,
        'email': email,
        'confirm_password': p,
      });
      final body = convert.jsonDecode(response.body);
      // print("response: $body");
      if (body['api_status'] == 220) {
        //success
        // print("success: $body");
        return body['message'];
      } else {
        throw (body['errors']['error_text']);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> logOut(String token) async {
    final url = Uri.parse(socialUrl + 'delete-access-token=$token');
    try {
      final response = await http.post(url, body: {
        "server_key": serverKey,
      });
      final body = convert.jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (body['errors']['error_text']);
      }
    } catch (e) {
      print("errore: $e");
      rethrow;
    }
  }

  static Future<void> loginWithCookies() async {}

  static Future<void> recoveryPsw(String token, String email) async {
    final url =
        Uri.parse(socialUrl + 'send-reset-password-email?access_token=$token');
    try {
      final response = await http.post(url, body: {
        "server_key": serverKey,
        "email": email,
      });
      final body = convert.jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw (body['errors']['error_text']);
      }
    } catch (e) {
      print("errore: $e");
      rethrow;
    }
  }

  //utente vuole cambiare una delle sue info
  static Future<void> updateUserData(String token) async {
    //final url = Uri.parse(socialUrl + "update-user-data?access_token=$token");
  }

//posso passargli gli ID degli utenti che segue, delle pagine che segue ecc
  static Future<List<Post>> getFeed(String token) async {
    final url = Uri.parse(socialUrl + "posts?access_token=$token");
    try {
      final response = await http.post(url, body: {
        "server_key": serverKey,
        "type": "get_news_feed",
      });
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return List.generate(
          body['data'].length,
          (i) => Post.fromJSON(body['data'][i] as Map<String, dynamic>),
        );
      } else {
        throw ("Errore indesiderato");
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<String?> likePost(String token, String postId) async {
    final url = Uri.parse(socialUrl + "post-actions?access_token=$token");
    try {
      final response = await http.post(url, body: {
        "server_key": serverKey,
        "action": "like",
        "post_id": postId,
      });
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        //può essere "unliked" o "liked"
        //su body['likes_data']['count'] = 1; avrei il numero dei like del post
        return body['action'];
      } else {
        throw ("Errore indesiderato");
      }
    } catch (e) {
      return null;
    }
  }

  //chiamata sempre allo stesso url, magari riciclare con i metodi sotto

  static Future<void> commentPost(
    String token,
    String postId,
    String content,
  ) async {
    final url = Uri.parse(socialUrl + "comments?access_token=$token");
    try {
      final response = await http.post(url, body: {
        "server_key": serverKey,
        "post_id": postId,
        "type": "create",
        "text": content,
      });

      final body = convert.jsonDecode(response.body);
      if (body['api_status'] != 200) {
        throw ("error");
      }
      return;
    } catch (e) {
      throw ("error");
    }
  }

//like comment
//reply to comment
  static Future<void> callApiComment({
    required String token,
    required String? commentId,
    required ApiCommentType apiType,
    String? replyContent,
    String? replyId,
  }) async {
    final url = Uri.parse(socialUrl + "comments?access_token=$token");
    Map<String, dynamic> _body = {
      "server_key": serverKey,
    };
    print("ciaooo");
    if (commentId != null) {
      _body["comment_id"] = commentId;
    }
    switch (apiType) {
      case ApiCommentType.like:
        _body['type'] = 'comment_like';
        break;
      case ApiCommentType.commentReplies:
        _body['type'] = 'fetch_comments_reply';
        break;
      case ApiCommentType.replyToComment:
        _body['type'] = 'create_reply';
        _body['text'] = replyContent!;
        break;
      case ApiCommentType.replyLike:
        _body['type'] = "reply_like";
        _body['reply_id'] = replyId!;
        break;
    }
    print("ecco body: $_body");
    try {
      final response = await http.post(url, body: _body);
      final body = convert.jsonDecode(response.body);
      print("responseeee: $body");
      if (body['api_status'] != 200) {
        throw ("Errore");
      }
    } catch (e) {
      rethrow;
    }
  }

  //con limit gli dico quanti commenti voglio ricevere nella risposta (15 per volta)
  // con offset gli dico da dove prendere questi 15
  //es: offset = 3 => prendo i commenti dal numero 4 al numero 19 (limit è 15)
  //quindi ogni volta che chiamo questa funziona offset deve incrementarsi di 15

  static Future<List<CommentoPost>> getPostsComment(String token, String postId,
      {String? offset}) async {
    final url = Uri.parse(socialUrl + "comments?access_token=$token");
    Map<String, dynamic> _body = {
      "server_key": serverKey,
      "post_id": postId,
      "type": "fetch_comments",
      "limit": "5",
    };
    if (offset != null) {
      _body["offset"] = offset;
    }
    try {
      final response = await http.post(url, body: _body);
      final body = convert.jsonDecode(response.body);
      //print("ecco body: $body");
      if (body['api_status'] != 200) {
        throw ("Errore");
      }

      print("ecco body: ${body['data']}");
      return List.generate(
        body['data'].length,
        (i) => CommentoPost.fromJson(body['data'][i]),
      );
    } catch (e) {
      print("erroeeee: $e");
      throw ("Errore");
    }
  }

  static Future<List<RispostaCommento>> getCommentReplies(
    String token,
    String commentId,
  ) async {
    final url = Uri.parse(socialUrl + "comments?access_token=$token");
    Map<String, dynamic> _body = {
      "server_key": serverKey,
      "comment_id": commentId,
      "type": "fetch_comments_reply",
    };
    try {
      final response = await http.post(url, body: _body);
      final body = convert.jsonDecode(response.body);
      //print("ecco body: $body");
      if (body['api_status'] != 200) {
        throw ("Errore");
      }

      return List.generate(
        body['data'].length,
        (i) => RispostaCommento.fromJson(body['data'][i]),
      );
    } catch (e) {
      print("erroeeee: $e");
      throw ("Errore");
    }
  }

//funziona, ho salvato la response in json sul desktop
  static Future<void> sendMessageToUser(
    String token,
    int userId,
    String text,
    int messageHashId,
  ) async {
    final url = Uri.parse(socialUrl + "send-message?access_token=$token");
    try {
      final response = await http.post(url, body: {
        "server_key": serverKey,
        "user_id": userId,
        //probabilmente dovrò salvarlo da qualche parte
        "message_hash_id": messageHashId,
        "text": text,
      });

      final body = convert.jsonDecode(response.body);
      if (body['api_status'] != 200) {
        throw ("error");
      }
      print("ecco body: $body");
      return;
    } catch (e) {
      throw ("error");
    }
  }

//apre i messaggi avuti con il destinatario
  static Future<List<Chat>> getChat(
    String token,
    String userId,
    String destinatarioId,
  ) async {
    final url = Uri.parse(socialUrl + "get_user_messages?access_token=$token");
    try {
      final response = await http.post(url, body: {
        "server_key": serverKey,
        "user_id": userId,
        "recipient_id": destinatarioId,
        //posso passargli anche limit (magari mi premdo solo gli ultimi primi 20 messaggi), poi semmai rifaccio chiamata
      });

      final body = convert.jsonDecode(response.body);
      if (body['api_status'] != 200) {
        throw ("error");
      }
      print("ecco body: $body");
      return List.generate(
        body['messages'].length,
        (i) => Chat.fromJson(body['messages'][i]),
      );
    } catch (e) {
      throw ("error");
    }
  }

//Follow / Unfollow user by id
  static Future<void> followUser(String token, String userId) async {
    final url = Uri.parse(socialUrl + "follow-user?access_token=$token");
    try {
      final response = await http.post(url, body: {
        "server_key": serverKey,
        "user_id": userId,
      });

      final body = convert.jsonDecode(response.body);
      if (body['api_status'] != 200) {
        throw ("error");
      }
      print("ecco body: $body");
      return;
    } catch (e) {
      throw ("error");
    }
  }
}

//tutte le chiamate api all'url dei commenti è lo stesso, cambia solo il parametro type
enum ApiCommentType {
  //per mettere o togliere like al commento
  like,
  //per rispondere al commento
  replyToComment,
  //per vedere le risposte ad un commento
  commentReplies,
  //mettere like ad una risposta di un commento
  replyLike,
}

extension ToString on ApiCommentType {
  String get name => toString().split('.').last;
}
