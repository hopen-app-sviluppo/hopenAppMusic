import 'package:music/pages/initial_pages/introduction_page/introduction_page.dart';

import 'initial_pages/main_page/main_page.dart';
import 'initial_pages/authentication/authentication_page.dart';
import 'initial_pages/splash_page.dart';
import 'initial_pages/authentication/helper/auth_validator.dart';
import '../provider/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

//* controllo se utente è gia autenticato
//* Se è autenticato => HomePage
//* se non è autenticato => AuthenticationPage
//* durante il caricamento => SplashPage
//* monitoro anche la connessione ad internet
class LaunchPage extends StatelessWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //* se utente preme back button mi assicuro che voglia davvero uscire dall'app
      onWillPop: () => _showExitPopUp(context),
      child: FutureBuilder(
          future: context.read<AuthenticationProvider>().onInitialize(),
          builder: (context, data) {
            return Consumer<AuthenticationProvider>(
                builder: (context, authProv, _) {
              //print("authState changed, now user is logged ? ${authState.isUserLoggedIn}");
              if (data.connectionState == ConnectionState.waiting) {
                return const SplashPage();
              }
              if (authProv.authState == AuthState.error) {
                return const IntroductionPage();
              }
              if (authProv.authState == AuthState.loggedIn) {
                //* utente loggato = mostro HomePage
                return const MainPage();
              } else {
                //* utente non loggato => mostro Pagina di autenticazione
                return ChangeNotifierProvider<AuthValidator>(
                  create: (context) => AuthValidator(),
                  child: const AuthenticationPage(),
                );
              }
            });
          }),
    );
  }

  /*  return Stack(children: [
              Consumer<AuthenticationProvider>(
                  builder: (context, authState, _) {
                print(
                  "authState changed, now user is logged ? ${authState.isUserLoggedIn}",
                );
                if (data.connectionState == ConnectionState.waiting) {
                  return const SplashPage();
                }
                if (authState.isUserLoggedIn) {

                  return const MainPage();
                } else {
                 
                  return ChangeNotifierProvider<AuthValidator>(
                    create: (context) => AuthValidator(),
                    child: const AuthenticationPage(),
                  );
                }
              }),
            
                Selector<SettingsProvider, ConnectivityResult>(
                  selector: (context, settProv) => settProv.connectionStatus,
                  builder: (context, currentConnection, _) {
                    return Positioned(
                      top: MediaQuery.of(context).padding.top,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        height: 15.0,
                        decoration: BoxDecoration(
                          color: getConnectionColor(currentConnection),
                        ),
                        child: Center(
                          child: Text(
                            "connessione: $currentConnection",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8.0,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ]);
          }),
    );
  }
*/
  Future<bool> _showExitPopUp(BuildContext context) async => await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Vuoi Chiudere l'App ?"),
              SizedBox(height: 20),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text("Annulla !"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text("Esci !"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      });

  Border getConnectionPadding(ConnectivityResult results) {
    switch (results) {
      case ConnectivityResult.bluetooth:
        return Border.all(width: 20.0, color: Colors.blue);
      case ConnectivityResult.wifi:
        return Border.all(width: 20.0, color: Colors.green);
      case ConnectivityResult.ethernet:
        return Border.all(width: 20.0, color: Colors.amber);
      case ConnectivityResult.mobile:
        return Border.all(width: 20.0, color: Colors.orange);
      case ConnectivityResult.none:
        return Border.all(width: 40.0, color: Colors.red);
    }
  }

  MaterialColor getConnectionColor(ConnectivityResult results) {
    switch (results) {
      case ConnectivityResult.bluetooth:
        return Colors.blue;
      case ConnectivityResult.wifi:
        return Colors.green;
      case ConnectivityResult.ethernet:
        return Colors.amber;
      case ConnectivityResult.mobile:
        return Colors.orange;
      case ConnectivityResult.none:
        return Colors.red;
    }
  }
}
