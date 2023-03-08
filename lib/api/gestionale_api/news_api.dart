import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:music/models/news_tutorial/news.dart';

import 'gestionale_key.dart';

class NewsApi {
//* GET => torna la lista di tutte le news !
  static Future<List<News>> getNews() async {
    final url = Uri.parse(apiUrl + 'news/all');
    final response = await http.get(url, headers: key);
    //Get all'endpoint news/all
    if (response.statusCode == 200) {
      //converto stringa in Json Format
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      //print("jsonResponse: $jsonResponse");
      final List jsonResponseNews = jsonResponse['data']['news'];
      List<News> listNews = [];
      for (int i = 0; i < jsonResponseNews.length; i++) {
        //converto la news corrente
        final News currentNews = News.fromJSON(jsonResponseNews[i]);
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
