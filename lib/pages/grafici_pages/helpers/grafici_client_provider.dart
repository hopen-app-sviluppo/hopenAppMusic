import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:music/database/form_operations.dart';
import 'package:music/models/compilazione_form.dart';
import 'package:music/models/risultati_comp_musicoterapia.dart';
import 'package:music/pages/grafici_pages/helpers/enums.dart';
import '../../../helpers.dart';
import '../../../models/cliente.dart';
import '../../../theme.dart';
import '../widgets/custom_radar_chart.dart';

//2 casi => o ho già l'assistito scelto, oppure no
//se ho l'assistito come parametro, allora aggiorno solo l'assistito corrente
//altrimenti query sulla lista degli assistiti dell'utente => se lo sceglie aggiorno ecc ecc

const defaultGraphColors = [
  Colors.green,
  Colors.blue,
  Colors.red,
  Colors.orange,
  Colors.purple,
  Colors.brown,
  Colors.amberAccent,
  Colors.grey,
  Colors.black,
  Colors.white,
];

class GraficiClientProvider with ChangeNotifier {
  // in base a questo capisco se assistito può essere cambiato nella schermata dei grafici oppure no
  late final bool isAssistitoProfile;
  List<Cliente>? userClients;
  Cliente? currentClient;
  GraphicType? graphType;
  //lista di compilazioni dell'assistito scelto ! è una lista immodificabile
  List<CompilazioneForm>? _assistitoCompilazioni;
  List<CompilazioneForm>? selectedComps;
  //grafico età musicale
  // grafico mood
  // grafico musicofilia
  Widget? graficoEtaMusicale;
  Widget? graficoMood;
  Widget? graficoMusicofilia;

  GraficiClientProvider({
    List<Cliente>? clients,
    Cliente? client,
    List<CompilazioneForm>? compilazioni,
  }) {
    if (client != null) {
      currentClient = client;
      isAssistitoProfile = true;
      _assistitoCompilazioni = compilazioni;
    }
    if (clients != null) {
      userClients = clients;
      isAssistitoProfile = false;
    }
  }

  List<CompilazioneForm>? get allCompilazioni => _assistitoCompilazioni;

  void updateSelectedComps(List<CompilazioneForm> comps) {
    selectedComps = comps;
    if (comps.isEmpty) {
      graphType = null;
    } else {
      graphType ??= GraphicType.eta;
    }
    notifyListeners();
  }

  String getAppBarText() {
    if (currentClient == null) {
      return "Monitora l'andamento dei tuoi assistiti";
    } else {
      if (graphType == null) {
        return "Seleziona le compilazioni per ${currentClient!.nome}";
      }
      if (graphType == GraphicType.eta) {
        return "VMtD età musicale di ${currentClient!.nome}";
      }
      if (graphType == GraphicType.mood) {
        return "Profilo MOOD di ${currentClient!.nome}";
      }
      if (graphType == GraphicType.musocifilia) {
        return "Profilo Musicofilia di ${currentClient!.nome}";
      }
    }
    return "";
  }

//aggiorno il tipo di grafico visualizzato
  void updateGraphicType(GraphicType newType) {
    graphType = newType;
    notifyListeners();
  }

//aggiorno l'assistito di riferimento
  Future<void> updateClient(int userId, Cliente? newClient) async {
    currentClient = newClient;
    selectedComps = null;
    graphType = null;
    //!query sul numero di compilazioni del cliente !
    if (currentClient != null) {
      await getAssistitoCompilations(userId);
    }
    notifyListeners();
  }

  //*ottengo tutte le compilazioni fatte all'assistito
  Future<void> getAssistitoCompilations(int userId) async {
    try {
      //tutte le compilazioni di musicoterapia (id form è 0)
      final List<CompilazioneForm>? compilazioni =
          await FormOperations.getMusicoterapiaCompilations(
              userId, currentClient!.id!, 0);
      _assistitoCompilazioni = compilazioni;
    } catch (e) {
      //!che fo se da errore??
      rethrow;
    }
  }

//? funzione che prende i risultati delle compilazioni dal DB
  Future<List<RisultatiCompMusic>> getRisultatiCompMusic(
      List<CompilazioneForm> comps) async {
    try {
      //per ogni compilazione mi prendo i risultati
      //sarebbe una lista di risultati
      List<RisultatiCompMusic> results = [];
      for (int i = 0; i < comps.length; i++) {
        final RisultatiCompMusic resComp =
            await FormOperations.getRisultatiComp(comps[i].compilazioneId!);
        results.add(resComp);
      }
      return results;
    } catch (e) {
      rethrow;
    }
  }

//? funzione che prende i risultati delle compilazioni dal DB di mood
  Future<List<Map<String, double>>> getRisultatiMood(
    List<CompilazioneForm> comps,
  ) async {
    try {
      //per ogni compilazione mi prendo i risultati
      //sarebbe una lista di risultati
      List<RisultatiCompMusic> results = [];
      for (int i = 0; i < comps.length; i++) {
        final RisultatiCompMusic resComp =
            await FormOperations.getRisultatiComp(comps[i].compilazioneId!);
        results.add(resComp);
      }
      //per ogni elemento di result, prendo musicofilia
      List<Map<String, double>> res =
          List.generate(results.length, (index) => results[index].mood);
      return res;
    } catch (e) {
      rethrow;
    }
  }

//? funzione che prende i risultati delle compilazioni dal DB di musicofilia
  Future<List<Map<String, double>>> getRisultatiMusicofilia(
    List<CompilazioneForm> comps,
  ) async {
    try {
      //per ogni compilazione mi prendo i risultati
      //sarebbe una lista di risultati
      List<RisultatiCompMusic> results = [];
      for (int i = 0; i < comps.length; i++) {
        final RisultatiCompMusic resComp =
            await FormOperations.getRisultatiComp(comps[i].compilazioneId!);
        results.add(resComp);
      }
      //per ogni elemento di result, prendo musicofilia
      List<Map<String, double>> res =
          List.generate(results.length, (index) => results[index].musicofilia);
      return res;
    } catch (e) {
      rethrow;
    }
  }

  //quando selezioni compilazioni di un assistito => carico i 3 grafici in quelle variabili

  Future<void> initializeGraphics(List<CompilazioneForm> comps) async {
    try {
      final List<RisultatiCompMusic> etaMusicaleResults =
          await getRisultatiCompMusic(comps);
      final List<Map<String, double>> moodResults =
          await getRisultatiMood(comps);
      final List<Map<String, double>> musicofiliaResults =
          await getRisultatiMusicofilia(comps);
      graficoEtaMusicale = BarChart(getChartData(etaMusicaleResults, comps));
      graficoMood = _buildMoodChart(moodResults, comps);
      graficoMusicofilia = _buildMusicofiliaChart(musicofiliaResults, comps);
    } catch (e) {
      graficoEtaMusicale = null;
      graficoMood = null;
      graficoMusicofilia = null;
      rethrow;
    }
  }

//grafico età musicale
  BarChartData getChartData(
    List<RisultatiCompMusic> results,
    List<CompilazioneForm> compilazioni,
  ) {
    return BarChartData(
      backgroundColor: Colors.white,
      alignment: BarChartAlignment.spaceEvenly,
      maxY: 100,
      minY: 0,
      barTouchData: BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 10,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                color: rodIndex == 0
                    ? Colors.blue
                    : rodIndex == 1
                        ? Colors.red
                        : Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      titlesData: FlTitlesData(
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 5.0,
              showTitles: true,
              reservedSize: 38.0,
              getTitlesWidget: (value, meta) {
                String? text;
                if (value == 25) {
                  text = '25%';
                } else if (value == 50) {
                  text = '50%';
                } else if (value == 75) {
                  text = '75%';
                } else if (value == 100) {
                  text = '100%';
                } else {
                  return const SizedBox.shrink();
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 0,
                  child: FittedBox(child: Text(text)),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) =>
                  bottomTitles(value, meta, compilazioni),
              reservedSize: 42,
            ),
          ),
          topTitles: AxisTitles()),
      //* per ogni compilazione ho un istogramma
      barGroups: List.generate(
        compilazioni.length,
        (index) {
          return BarChartGroupData(
              x: index,
              barsSpace: 3.0,
              showingTooltipIndicators: [
                0,
                1,
                2
              ],
              barRods: [
                _buildBarChartRodData(
                    results[index].etaMusicale02, Colors.blue),
                _buildBarChartRodData(results[index].etaMusicale24, Colors.red),
                _buildBarChartRodData(
                    results[index].etaMusicale46, Colors.amber),
              ]);
        },
        growable: false,
      ),
    );
  }

//singola linea
  BarChartRodData _buildBarChartRodData(double value, Color colors) =>
      BarChartRodData(
        toY: double.parse(value.toStringAsFixed(2)),
        color: colors,
        width: 20.0,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(5.0),
        ),
      );

  Widget bottomTitles(
      double value, TitleMeta meta, List<CompilazioneForm> compilazioni) {
    final title = List.generate(compilazioni.length,
        (index) => formatDateToString(compilazioni[index].creatoIl),
        growable: false);

    final Widget text = Text(
      title[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

//grafico Mood
  CustomRadarChart _buildMoodChart(List<Map<String, double>> results,
          List<CompilazioneForm> compilazioni) =>
      CustomRadarChart(
        ticks: const [0, 25, 50, 75, 100],
        features: const [
          'Sicuro',
          'Ambivalente',
          'Disorganizzato',
          'Insicuro',
        ],
        sides: 4,
        data: List.generate(
          compilazioni.length,
          (index) {
            final field = results[index];
            //max 2, min -2
            return [
              ((field['sicuro']! + 2) / 4) * 100,
              ((field['ambivalente']! + 2) / 4) * 100,
              //disorganizzato
              ((field['ambivalente']! - 2) / -4) * 100,
              //insicuro
              ((field['sicuro']! - 2) / -4) * 100,
            ];
          },
          growable: false,
        ),
        ticksTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        featuresTextStyle: const TextStyle(
            color: MainColor.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold),
      );

//Grafico musicofilia
  CustomRadarChart _buildMusicofiliaChart(List<Map<String, double>> results,
          List<CompilazioneForm> compilazioni) =>
      CustomRadarChart(
        ticks: const [0, 25, 50, 75, 100],
        features: const [
          'emotivo',
          'relazionale',
          'dentro',
          'razionale',
          'fianco',
          'intorno'
        ],
        sides: 6,
        data: List.generate(
          compilazioni.length,
          (index) {
            final field = results[index];
            return [
              field['emotivo']! * 100,
              field['relazionale']! * 100,
              field['dentro']! * 100,
              field['razionale']! * 100,
              field['fianco']! * 100,
              field['intorno']! * 100,
            ];
          },
          growable: false,
        ),
        ticksTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        featuresTextStyle: const TextStyle(
            color: MainColor.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold),
      );

  //* Funzione che mostra la bottomSheet nella pagina dei grafici
  void showBtmSheet(BuildContext context, List<CompilazioneForm> compilazioni) {
    Scaffold.of(context).showBottomSheet(
      (context) => SingleChildScrollView(
        child: Column(children: [
          ...List.generate(
              compilazioni.length,
              (index) => Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      shape: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: defaultGraphColors[index],
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: defaultGraphColors[index],
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: const Text(
                        "Compilazione del",
                      ),
                      subtitle: Text(formatHour(compilazioni[index].creatoIl)),
                    ),
                  )),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              child: const Text("Chiudi"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          )
        ]),
      ),
    );
  }

  Widget etaMusicaleToPdf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Profilo Età musicale",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        SizedBox(width: 350, height: 300, child: graficoEtaMusicale),
      ],
    );
  }

  Widget moodToPdf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Profilo Mood",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        SizedBox(width: 350, height: 300, child: graficoMood),
      ],
    );
  }

  Widget musicofiliaToPdf() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Profilo Musicofilia",
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
        SizedBox(width: 350, height: 300, child: graficoMusicofilia),
      ],
    );
  }
}
