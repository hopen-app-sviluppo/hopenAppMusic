import 'package:flutter/material.dart';
import 'package:music/api/gestionale_api/tutorial_api.dart';
import 'package:music/models/news_tutorial/tutorial.dart';

class TutorialProvider with ChangeNotifier {
  // lista di video tutorials
  List<Tutorial> tutorials = [];

  //lista di categorie, utile per i filtri
  Set<String> idCategorie = {};

  Future<void> getTutorials() async {
    try {
      final List<Tutorial> items = await TutorialApi.getTutorials();
      tutorials = items;
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

  List<Tutorial> filterTutorial() {
    if (tutorials.isEmpty) return [];
    if (idCategorie.isEmpty) return tutorials;

    List<Tutorial> filteredTutorials = [
      ...tutorials.where((tutorialElement) {
        //per ogni tutorial, controllo se il suo id si trova in uno dei filtri
        if (idCategorie.contains(tutorialElement.categoria.id)) {
          return true;
        }
        return false;
      }).toList()
    ];
    return filteredTutorials;
  }
}
