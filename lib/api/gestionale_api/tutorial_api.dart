import 'package:http/http.dart' as http;
import 'package:music/models/news_tutorial/tutorial.dart';
import 'dart:convert' as convert;

import 'gestionale_key.dart';

class TutorialApi {
  //* GET => torna la lista di tutti i tutorial !
  static getTutorials() async {
    //await Future.delayed(Duration(seconds: 1));
    final videoUrl = Uri.parse(apiUrl + 'video/all');
    final response = await http.get(videoUrl, headers: key);
    if (response.statusCode == 200) {
      //converto stringa in Json Format
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      //  print("jsonResponse: $jsonResponse");
      final List jsonResponseVideo = jsonResponse['data']['video'];
      //   print("jsonResponsevideo: $jsonResponseVideo");
      List<Tutorial> listVideos = [];
      for (int i = 0; i < jsonResponseVideo.length; i++) {
        //converto la news corrente
        final Tutorial currentTutorial =
            Tutorial.fromJSON(jsonResponseVideo[i]);
        //aggiungo news alla lista
        listVideos.add(currentTutorial);
      }
      // print("eccoci: $listVideos");
      return listVideos;
    } else {
      print("errore richiesta tutorials, status_code: ${response.statusCode}");
      throw ("Error: ${response.statusCode}");
    }
  }
}
