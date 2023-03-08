import 'package:music/helpers.dart';

class CompilazioneForm {
  final int? compilazioneId;
  final int userId;
  final int assistitoId;
  //final int formId;
  //quando lo prendo dal db poi lo converto in DateTime format
  final DateTime creatoIl;
  //magari un domani daremo la possibilità di fare modifiche??? semmai ci vuole una lista => ogni elemento è una modifica? bho
  final DateTime ultimaModifica;
  final String assistitoName;
  final String assistitoCognome;
  final int formId;
  final String formName;
  final int? score;
  final int? maxScore;

  CompilazioneForm({
    this.compilazioneId,
    required this.userId,
    required this.assistitoId,
    required this.creatoIl,
    required this.ultimaModifica,
    required this.assistitoName,
    required this.assistitoCognome,
    required this.formId,
    required this.formName,
    required this.score,
    required this.maxScore,
  });

  //* utile per definire colonne su database
  static final List<String> formValues = [
    "compilazione_id",
    "client_id",
    "client_name",
    "client_cognome",
    "user_id",
    "creato_il",
    "ultima_modifica",
    "form_id",
    "form_name",
    "score",
    "max_score",
  ];

  //prendere assistito dal db
  static CompilazioneForm fromJSON(Map<String, dynamic> data) {
    //convertire Stringa to DateTime
    //final DateTime creatoIl =;
    final newCompilazioneForm = CompilazioneForm(
      compilazioneId: data["compilazione_id"],
      userId: data["user_id"],
      assistitoId: data["client_id"],
      creatoIl: formtStringToDate(data['creato_il']),
      ultimaModifica: formtStringToDate(data['ultima_modifica']),
      //DateTime.parse(data['ultima_modifica']), //2022-09-02 08:21:00.0000
      assistitoName: data["client_name"],
      assistitoCognome: data["client_cognome"],
      formId: data["form_id"],
      formName: data["form_name"],
      score: data["score"],
      maxScore: data["max_score"],
    );
    return newCompilazioneForm;
  }

  //per salvare l'assistito nel db
  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "compilazione_id": compilazioneId,
      "user_id": userId,
      "client_id": assistitoId,
      "creato_il": formatHour(creatoIl),
      "ultima_modifica": formatHour(ultimaModifica),
      "client_name": assistitoName,
      "form_id": formId,
      "form_name": formName,
      "client_cognome": assistitoCognome,
      //solo se è il form di musicoterapia (allora c'ho sta cosa)
      "score": score,
      "max_score": maxScore,
    };
  }

  @override
  String toString() =>
      "user_id: $userId, assistito id: $assistitoId,creato: $creatoIl, ultimaModifica: $ultimaModifica";
}


//** ESEMPIO COMPILAZIONE
//
// compilazione_id : 0
// user_id: 0
// assistito_id: 0
// assistito_name: Giancarlo
// gruppo_id: 0   QUESTE LE INSERIRO' POI
// app_id: 0  QUESTE LE INSERIRO' POI
// creato il : 28-08-22
// ultima modifica: 30-08-22
// form_id : 0
// form_name : musicoterapia
// score: 20 //score di tutte le domande
// max_score: score massimo
// INSERIRE DOMANDE, COME?????
// */

//* TABELLA DOMANDE
// domanda:id: 0 CHIAVE PRIMARIA
// form_id : 0 CHIAVE ESTERNA
// sezione_id: 0 CHIAVE ESTERNA
// score: 3
// max_score: 5
// compilazione_id : 0 CHIAVE ESTERNA


//SULLA LISTA DEI FORM COMPILATI, FACCIO UNA SELECT SULLA TABELLA COMPILAZIONI => SELECT * FROM compilazione WHERE user_id = 0
//OGNI ELEMENTO MOSTRA: assistito_name, form_name, data_creazione, data_modifica, punteggio-punteggioMax
//cliccandoci => apro pagina compilazione (in sola lettura chiaramente), e mostro: 
//Varie Sezioni con le domande e i putneggi gia inseriti, quindi devo fare tipo:
//SELECT * FROM domanda where compilazione_id = 0
//poi da questa lista, filtro le domande in base alle sezioni => sto nella sezione 0 => 