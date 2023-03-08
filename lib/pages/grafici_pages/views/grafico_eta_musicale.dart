import 'package:flutter/material.dart';

import 'package:music/pages/common_widget/custom_expansion_tile.dart';

import 'package:music/pages/grafici_pages/helpers/enums.dart';
import 'package:music/pages/grafici_pages/helpers/grafici_client_provider.dart';
import 'package:music/pages/grafici_pages/widgets/btn_save_pdf.dart';
import 'package:music/router.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

//* grafico eta musicale => Istogramma !
class GraficoEtaMusicale extends StatelessWidget {
  const GraficoEtaMusicale({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          CustomExpansionTile(
            title: const Text("Legenda"),
            initiallyExpanded: false,
            collapsedTextColor: Colors.white,
            textColor: MainColor.secondaryColor,
            collapsedIconColor: Colors.white,
            iconColor: MainColor.secondaryColor,
            children: [
              Row(
                children: [
                  Container(width: 25.0, height: 25.0, color: Colors.blue),
                  const Expanded(child: Text("EM 0 a 2/4 anni")),
                  Container(width: 25.0, height: 25.0, color: Colors.red),
                  const Expanded(child: Text("EM 2/4 a 3/5 anni"))
                ],
              ),
              Row(
                children: [
                  Container(width: 25.0, height: 25.0, color: Colors.amber),
                  const Expanded(child: Text("EM 3/5 a 4/6 anni"))
                ],
              ),
            ],
          ),
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: _buildGraphic(context))),
        ],
      ),
    );
  }

  Widget _buildGraphic(BuildContext context) {
    Widget pdfGraph = _buildPdfGraph(
        context.read<GraficiClientProvider>().graficoEtaMusicale!);
    return Column(
      children: [
        Expanded(
          child: Stack(children: [
            context.read<GraficiClientProvider>().graficoEtaMusicale!
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(AppRouter.dettaglioGrafico, arguments: [
                context.read<GraficiClientProvider>().graficoEtaMusicale!,
                "Età musicale di ${context.read<GraficiClientProvider>().currentClient!.nome}",
              ]),
              child: const Text(
                "Espandi grafico",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _buildPdfGraph(Widget graphic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Profilo Età musicale",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        SizedBox(width: 350, height: 300, child: graphic),
      ],
    );
  }
}
