//? classe utile a salvare i risultati delle compilazioni di musicoterapia nel DB

class RisultatiCompMusic {
  final double etaMusicale02;
  final double etaMusicale24;
  final double etaMusicale46;
  final Map<String, double> mood;
  final Map<String, double> musicofilia;
  final int compId;

  RisultatiCompMusic({
    required this.etaMusicale02,
    required this.etaMusicale24,
    required this.etaMusicale46,
    required this.mood,
    required this.musicofilia,
    required this.compId,
  });

  //* utile per definire colonne su database
  static final List<String> formValues = [
    "compilazione_id",
    "eta_musicale_02",
    "eta_musicale_24",
    "eta_musicale_46",
    "mood",
    "emotivo",
    "relazionale",
    "dentro",
    "razionale",
    "fianco",
    "intorno",
  ];

  static RisultatiCompMusic fromJSON(Map<String, dynamic> data) {
    final newRisultatiCompMusic = RisultatiCompMusic(
      etaMusicale02: data["eta_musicale_02"],
      etaMusicale24: data["eta_musicale_24"],
      etaMusicale46: data["eta_musicale_46"],
      mood: {
        "sicuro": data['sicuro'],
        "ambivalente": data['ambivalente'],
      },
      musicofilia: {
        "emotivo": data['emotivo'],
        "relazionale": data['relazionale'],
        "dentro": data['dentro'],
        "razionale": data['razionale'],
        "fianco": data['fianco'],
        "intorno": data['intorno'],
      },
      compId: data["compilazione_id"],
    );
    return newRisultatiCompMusic;
  }

  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "compilazione_id": compId,
      "eta_musicale_02": etaMusicale02,
      "eta_musicale_24": etaMusicale24,
      "eta_musicale_46": etaMusicale46,
      //? risultati mood
      "sicuro": mood['sicuro'],
      "ambivalente": mood['ambivalente'],
      //?risultati musicofilia
      "emotivo": musicofilia['emotivo'],
      "relazionale": musicofilia['relazionale'],
      "dentro": musicofilia['dentro'],
      "razionale": musicofilia['razionale'],
      "fianco": musicofilia['fianco'],
      "intorno": musicofilia['intorno'],
    };
  }
}
