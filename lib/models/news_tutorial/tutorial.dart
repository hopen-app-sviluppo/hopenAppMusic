import 'package:music/models/news_tutorial/categoria.dart';

class Tutorial {
  final String id;
  final String dateTime;
  final String titolo;
  final String desc;
  final String url;
  final Categoria categoria;
  Tutorial({
    required this.id,
    required this.dateTime,
    required this.titolo,
    required this.desc,
    required this.url,
    required this.categoria,
  });

  //prendere assistito dal db
  static Tutorial fromJSON(Map<String, dynamic> data) {
    final tutorial = Tutorial(
      id: data['id'],
      dateTime: data['datetime'],
      titolo: data['titolo'],
      desc: data['descrizione'],
      url: data['url_video'],
      categoria: Categoria.fromJSON(data['idcategoria']),
    );
    return tutorial;
  }

  @override
  String toString() =>
      "id: $id, titolo: $titolo, desc: $desc, url: $url, datetime: $dateTime, $categoria";
}
