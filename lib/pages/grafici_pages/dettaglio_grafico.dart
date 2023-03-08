import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/pages/grafici_pages/widgets/custom_radar_chart.dart';

//la pagina mstra il grafico nel dettaglio, PAGINA IN LANDSCAPE !
//possibiliyà di esportare grafico in PDF
class DettaglioGrafico extends StatefulWidget {
  final String appBarTitle;
  final Widget currentGraphic;
  const DettaglioGrafico({
    Key? key,
    required this.currentGraphic,
    required this.appBarTitle,
  }) : super(key: key);

  @override
  State<DettaglioGrafico> createState() => _DettaglioGraficoState();
}

class _DettaglioGraficoState extends State<DettaglioGrafico> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    //* setto la pagina in landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    //* risetto la pagina in portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() => AppBar(
        title: Text(widget.appBarTitle),
      );

  Widget _buildBody() => Padding(
        padding: const EdgeInsets.all(5.0),
        child: widget.currentGraphic is CustomRadarChart
            ? Card(elevation: 3.0, child: widget.currentGraphic)
            : widget.currentGraphic,
      );
}
