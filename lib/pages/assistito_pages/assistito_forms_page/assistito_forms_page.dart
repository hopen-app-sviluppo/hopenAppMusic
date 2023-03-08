import 'package:flutter/material.dart';

//* Pagina che mostra i form compilati per quell'assistito !

class AssistitoFormsPage extends StatelessWidget {
  const AssistitoFormsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista Form compilati per l'assistito")),
      body: const SafeArea(
          child: Center(
        child: Text("Mostro lista dei form compilati per questo assistito"),
      )),
    );
  }
}
