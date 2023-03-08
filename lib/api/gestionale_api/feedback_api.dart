import 'package:http/http.dart' as http;
import 'package:music/models/feedbacks.dart';
import 'dart:convert' as convert;
import 'gestionale_key.dart';

class FeedbackApi {
//* GET => torna la lista dei feedback di quell'utente !
//todo! PROBLEMA => POSSO FARE QUERY SOLAMETNE INDICANDO L'ID DEL POST (SOLO LA CHIAVE PRIMARIA) E NON CON L'ID DELL'UTENTE, SENTIRE ANDREA
//? PER ORA prendo tutti i feedback e li filtro in dart
  static Future<List<Feedbacks?>> getUserFeedbacks(String userId) async {
    final url = Uri.parse(apiUrl + 'feedback/all');
    final response = await http.get(url, headers: key);
    //Get all'endpoint news/all
    if (response.statusCode == 200) {
      //converto stringa in Json Format
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      //print("jsonResponse: $jsonResponse");
      final List jsonResponseFeedback = jsonResponse['data']['feedback'];
      List<Feedbacks> feedbacks = [];
      for (var feed in jsonResponseFeedback) {
        if (feed['user_id'] == userId) {
          feedbacks.add(Feedbacks.fromJSON(feed));
        }
      }
      return feedbacks;
    } else {
      print("errore: ${response.statusCode} e body: ${response.body}");
      throw ("Error: ${response.statusCode}");
    }
  }

  static Future<bool> sendFeedback(Feedbacks feedback) async {
    final url = Uri.parse(apiUrl + 'feedback/add');
    final response = await http.post(
      url,
      headers: key,
      body: feedback.toJson(),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print("errore: ${response.statusCode} e data: ${response.body}");
      return false;
    }
  }

  static Future<Feedbacks> getFeedbackById(int feedbackId) async {
    final url = Uri.parse(apiUrl + 'feedback/detail?id=7');
    final response = await http.get(url, headers: key);
    //Get all'endpoint news/all
    if (response.statusCode == 200) {
      // print("status: ${response.statusCode} e body: ${response.body}");
      //converto stringa in Json Format
      final jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      // print("ecco la risposta: $jsonResponse");
      //print("jsonResponse: $jsonResponse");
      return Feedbacks.fromJSON(jsonResponse['data']['feedback']);
    } else {
      print("errore: ${response.statusCode} e body: ${response.body}");
      throw ("Error: ${response.statusCode}");
    }
  }
}
