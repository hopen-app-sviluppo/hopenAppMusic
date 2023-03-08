//follower e following

//todo: riciclare questi items su SocialUser (sempre le stesse voci)

class Follower {
  final String userId;
  final String username;
  final String avatar;
  //se quel follower lo seguo oppure no
  bool loSeguo;

  Follower({
    required this.userId,
    required this.username,
    required this.avatar,
    required this.loSeguo,
  });

  Follower.fromJSON(Map<String, dynamic> data)
      : userId = data['user_id'],
        username = data['username'],
        avatar = data['avatar'],
        //is_following può valere 0 o 1
        loSeguo = data['is_following'] == 1;
}
