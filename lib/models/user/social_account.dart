//parte social dell'utente

import 'package:music/models/social_models/follower.dart';

class SocialAccount {
  final String nome;
  final String cognome;
  final String email;
  final String username;
  final String gender;
  final String telefono;
  final String citta;
  final String state;
  final String avatar;
  final Details? details;
  final Map<String, String> cookies;
  List<Follower> followers;
  List<Follower> following;
  int followersLength;
  int followingLength;

  SocialAccount({
    required this.avatar,
    required this.gender,
    required this.nome,
    required this.cognome,
    required this.username,
    required this.email,
    required this.citta,
    required this.state,
    required this.cookies,
    required this.telefono,
    required this.followers,
    required this.following,
    this.details,
  })  : followersLength = followers.length,
        followingLength = following.length;

  //metodo che trasforma un Json in un oggetto di Social Account
  SocialAccount.fromJSON(
    Map<String, dynamic> data,
    this.followers,
    this.following,
    Map<String, String> headers,
  )   : nome = data["first_name"],
        cognome = data["last_name"],
        email = data["email"],
        username = data['username'],
        avatar = data["avatar"],
        gender = data['gender'],
        telefono = data['phone_number'],
        citta = data['city'],
        state = data['state'],
        cookies = headers,
        details = Details.fromJSON(data['details']),
        followersLength = followers.length,
        followingLength = following.length;

  //account che trasforma un oggetto social account in un json

  Map<String, dynamic> toJSON() => {
        "first_name": nome,
        "last_name": cognome,
        "email": email,
        "username": username,
        "avatar": avatar,
        "gender": gender,
        "phone_number": telefono,
        "city": citta,
        "state": state,
      };

  @override
  String toString() =>
      "social: nome: $nome, cognome: $cognome, email: $email, username: $username, gender: $gender, tel: $telefono, city: $citta, state: $state";

//seguo nuovo utente oppure rimuovo un follow
  void updateFollower(Follower follower, bool addFollow) {
    if (addFollow) {
      following.add(follower);
      followingLength++;
      follower.loSeguo = true;
    } else {
      following.removeWhere((element) => element.userId == follower.userId);
      followingLength--;
      follower.loSeguo = false;
    }
  }
}

//un account social ha i details: numero di post, album, follower... ecc
class Details {
  final String postCount;
  final String albumCount;
  final String followingCount;
  final String followersCount;
  final String likesCount;
  final String groupCount;

  Details({
    required this.postCount,
    required this.albumCount,
    required this.followingCount,
    required this.followersCount,
    required this.likesCount,
    required this.groupCount,
  });

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "post_count": postCount,
      "album_count": albumCount,
      "following_count": followingCount,
      "followers_count": followersCount,
      "groups_count": groupCount,
      "likes_count": likesCount,
    };
  }

  static Details fromJSON(Map<String, dynamic> data) {
    return Details(
      postCount: data["post_count"],
      albumCount: data["album_count"],
      followingCount: data["following_count"],
      followersCount: data["followers_count"],
      groupCount: data["groups_count"],
      likesCount: data["likes_count"],
    );
  }
}
