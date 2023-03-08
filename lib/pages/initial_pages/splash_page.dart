import 'package:flutter/material.dart';

//* pagina di caricamento (appare quando il sistema sta checkando se utente è loggato o no)

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Text(
                    "Musica per la Relazione di Aiuto \n\n Un progetto di Hopen Up S.r.l.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  CircularProgressIndicator(),
                ]),
          ),
        ),
      );
}
