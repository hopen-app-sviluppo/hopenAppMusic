import 'package:flutter/material.dart';

import 'package:music/router.dart';

import 'widgets/lista_assistiti.dart';

class ListaAssistitiPage extends StatelessWidget {
  const ListaAssistitiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          const Expanded(
            child: ListaAssistiti(
              showListView: true,
            ),
          ),
          Align(alignment: Alignment.bottomRight, child: _buildFab(context))
        ]),
      );

  Widget _buildFab(BuildContext context) => ElevatedButton(
        child: const Text("Crea Assistito !"),
        onPressed: () =>
            Navigator.of(context).pushNamed(AppRouter.creaAssistito),
      );
}
