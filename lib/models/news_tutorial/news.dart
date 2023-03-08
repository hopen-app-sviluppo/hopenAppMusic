import 'package:music/models/news_tutorial/categoria.dart';

import '../../api/gestionale_api/gestionale_key.dart';

class News {
  final String id;
  final String dateTime;
  final String titolo;
  final String testo;
  //immagine jpg
  final String copertina;
  final Categoria categoria;

  News({
    required this.id,
    required this.dateTime,
    required this.titolo,
    required this.testo,
    required this.copertina,
    required this.categoria,
  });

  //prendere assistito dal db
  static News fromJSON(Map<String, dynamic> data) {
    //salvo l'url dell'immagine
    final String networkImage = uploadUrl + "news/${data['copertina']}";
    final news = News(
      id: data['id'],
      dateTime: data['datetime'],
      titolo: data['titolo'],
      testo: data['testo'],
      copertina: networkImage,
      categoria: Categoria.fromJSON(data['idcategoria']),
    );
    return news;
  }

  @override
  String toString() =>
      "id: $id, titolo: $titolo, testo: $testo, copertina: $copertina, datetime: $dateTime";
}
