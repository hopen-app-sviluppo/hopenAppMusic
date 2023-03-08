import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:music/models/news_tutorial/categoria.dart';

import 'gestionale_key.dart';

//categorie delle news e dei tutorial
class CategorieApi {
  static Future<List<Categoria>> getCategories() async {
    final url = Uri.parse(apiUrl + 'news_categorie/all');
    final response = await http.get(url, headers: key);
    //Get all'endpoint news/all
    if (response.statusCode == 200) {
      //converto stringa in Json Format
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      //print("jsonResponse: $jsonResponse");
      final List jsonResponseNews = jsonResponse['data']['news_categorie'];
      List<Categoria> listNews = [];
      for (int i = 0; i < jsonResponseNews.length; i++) {
        //converto la news corrente
        final Categoria currentNews = Categoria.fromJSON(jsonResponseNews[i]);
        //aggiungo news alla lista
        listNews.add(currentNews);
      }
      return listNews;
    } else {
      print("errore richiesta news, status_code: ${response.statusCode}");
      throw ("Error: ${response.statusCode}");
    }
  }
}
