import 'package:flutter/material.dart';
import 'package:music/api/gestionale_api/news_api.dart';
import 'package:music/models/news_tutorial/news.dart';

class NewsProvider with ChangeNotifier {
  // lista di video tutorials
  List<News> news = [];

  //lista di categorie, utile per i filtri
  Set<String> idCategorie = {};

  Future<void> getNews() async {
    try {
      final List<News> items = await NewsApi.getNews();
      news = items;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void updateCategorie(String id, bool isSelected) {
    if (isSelected) {
      _addCategoria(id);
    } else {
      _removeCategoria(id);
    }
    notifyListeners();
  }

  void _addCategoria(String categoriaId) {
    idCategorie.add(categoriaId);
  }

  void _removeCategoria(String categoriaId) {
    idCategorie.remove(categoriaId);
  }

  List<News> filterNews() {
    if (news.isEmpty) return [];
    if (idCategorie.isEmpty) return news;

    List<News> filteredNews = [
      ...news.where((tutorialElement) {
        //per ogni tutorial, controllo se il suo id si trova in uno dei filtri
        if (idCategorie.contains(tutorialElement.categoria.id)) {
          return true;
        }
        return false;
      }).toList()
    ];
    return filteredNews;
  }
}
