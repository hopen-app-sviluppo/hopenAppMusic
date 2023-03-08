import 'package:flutter/material.dart';
import 'package:music/pages/grafici_pages/helpers/enums.dart';
import 'package:music/pages/grafici_pages/widgets/btn_save_pdf.dart';
import 'package:provider/provider.dart';
import '../../../router.dart';
import '../../../theme.dart';
import '../helpers/grafici_client_provider.dart';

//* grafico Mood => Radar !
class GraficoMoodMusicofilia extends StatelessWidget {
  //* se true allora è grafico mood, altrimenti è grafico musicofilia
  final bool isMood;
  const GraficoMoodMusicofilia({
    Key? key,
    required this.isMood,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? pdfGraph;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        elevation: 3.0,
        child: _buildGraphic(context),
      ),
    );
  }

  Widget _buildGraphic(BuildContext context) {
    Widget pdfGraph = _buildPdfGraph(isMood
        ? context.read<GraficiClientProvider>().graficoMood!
        : context.read<GraficiClientProvider>().graficoMusicofilia!);
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: isMood
              ? context.read<GraficiClientProvider>().graficoMood!
              : context.read<GraficiClientProvider>().graficoMusicofilia!,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildEspandi(
                    context,
                    isMood
                        ? context.read<GraficiClientProvider>().graficoMood!
                        : context
                            .read<GraficiClientProvider>()
                            .graficoMusicofilia!,
                  ),
                  _buildLegenda(context)
                ]),
          ),
        ),
      ],
    );
  }

  Widget _buildLegenda(BuildContext context) => InkWell(
        onTap: () => context.read<GraficiClientProvider>().showBtmSheet(
            context, context.read<GraficiClientProvider>().selectedComps!),
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Legenda",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: MainColor.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget _buildEspandi(BuildContext context, Widget graph) => InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(AppRouter.dettaglioGrafico, arguments: [
          graph,
          isMood
              ? "Mood di" +
                  context.read<GraficiClientProvider>().currentClient!.nome
              : "Musicofilia di" +
                  context.read<GraficiClientProvider>().currentClient!.nome,
        ]),
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Espandi grafico",
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: MainColor.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget _buildPdfGraph(
    Widget graph,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isMood ? "Profilo Mood" : "Profilo Musicofilia",
          style: const TextStyle(color: Colors.black, fontSize: 24),
        ),
        SizedBox(width: 350, height: 400, child: graph),
      ],
    );
  }
}
