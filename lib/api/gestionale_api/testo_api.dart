import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'gestionale_key.dart';
import 'dart:convert' as convert;
import 'package:html/parser.dart' show parse;
//sul gestionale mettiamo dei testi (nel database testo) da visualizzare nell'app

class TestoApi {
  //! Il testo iniziale ha ID 1, prendo solo quello

  //torna una pagina in html.

  static Future<String?> getTestoGestionaleById(String id) async {
    final url = Uri.parse(apiUrl + 'testo/detail?id=$id');
    try {
      final response = await http.get(url, headers: key);
      // print("ecco response: ${response.statusCode} e body: ${response.body}");
      final body = convert.jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        //  print("ecco la risposta: $body");
        //prendo il contenuto che  in HTML
        final Document document =
            parse(body['data']['testo']['contenuto'] as String);
        return document.outerHtml;
        //converto l'html in stringa
        //  final String? parsedString =
        //      parse(document.body?.text).documentElement?.text;
        //  return parsedString;
      } else {
        throw ("error getting text");
      }
    } catch (e) {
      print("fail ! $e");
      return null;
    }
  }

  static Future<String?> getTestoIniziale() async {
    final String? testo = await getTestoGestionaleById("1");
    return testo;
  }

  static Future<String?> getDescrizioneMusicoterapia() async {
    final String? testo = await getTestoGestionaleById("2");
    return testo;
  }

  static Future<String?> getDescrizioneDiarioMus() async {
    final String? testo = await getTestoGestionaleById("3");
    return testo;
  }

  static Future<String?> getTestoPaginaFeedback() async {
    final String? testo = await getTestoGestionaleById("4");
    return testo;
  }
}
