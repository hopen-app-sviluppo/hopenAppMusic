class Feedbacks {
  final String userId;
  final String content;
  final DateTime creatoIl;
  final String? id;

  Feedbacks({
    required this.userId,
    required this.content,
    required this.creatoIl,
    this.id,
  });

//datetime arriva in formato stringa, io lo converto in datetime
  static Feedbacks fromJSON(Map<String, dynamic> data) {
    final feedback = Feedbacks(
      id: data['id'],
      userId: data['user_id'],
      content: data['content'],
      creatoIl: DateTime.parse(data['datetime']),
    );
    return feedback;
  }

//datetime sul DB è un timestamp, ma li prende come stringa
  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "content": content,
      "datetime": creatoIl.toString(),
    };
  }
}
