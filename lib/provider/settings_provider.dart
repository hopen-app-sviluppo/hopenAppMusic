import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/responsive_widget/size_config.dart';
import 'package:music/theme.dart';

//* provider per la lingua (internazionalizzazione) - per l'eventuale theme - per il testo - per la size dei widget - per il monitoraggio della connessione internet
class SettingsProvider with ChangeNotifier {
  final SizeConfig config;
  ThemeData? currentTheme;
  //* check connessione internet (bluetooth - wifi- ethernet - mobile)
  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  SettingsProvider(this.config) {
    currentTheme = AppTheme.mainTheme();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status $e');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    /* if (!mounted) {
      return Future.value(null);
    }*/

    return _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    // print("new result: $result");
    connectionStatus = result;
    notifyListeners();
  }
}
