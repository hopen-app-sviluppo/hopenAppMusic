import 'package:flutter/material.dart';

class NetworkProvider with ChangeNotifier {
  int percentIndicator = 0;
  bool showError = false;

  void updateLoading(int newVal) {
    percentIndicator = newVal;
    notifyListeners();
  }

  void uploadError(bool newVal) {
    showError = newVal;
    notifyListeners();
  }
}
