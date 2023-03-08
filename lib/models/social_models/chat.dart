class Chat {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final String time;
  final String seen;
  //left oppure roght ( se messaggio è mio o suo)
  final String position;
  final String media;

  Chat({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.time,
    required this.seen,
    required this.position,
    required this.media,
  });

  Chat.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        senderId = data['from_id'],
        receiverId = data['to_id'],
        text = data['text'],
        time = data['time'],
        seen = data['seen'],
        position = data['position'],
        media = data['media'];
}
