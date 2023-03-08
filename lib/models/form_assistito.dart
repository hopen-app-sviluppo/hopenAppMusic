import 'package:music/models/form_domanda_enum.dart';

class FormAss {
  final int formId;
  final String formName;
  final String formDesc;
  final String tutorialTitle;
  final List<Sezione> sezioni;
  int _score = 0;
  late final int? maxScore;

  FormAss({
    required this.formId,
    required this.formName,
    required this.formDesc,
    required this.tutorialTitle,
    required this.sezioni,
  }) {
    maxScore = _initializeMaxScore();
  }

  //maxScore della Sezione = somma del massimo punteggio di ogni domanda
  int _initializeMaxScore() {
    int scoreSum = 0;
    for (int i = 0; i < sezioni.length; i++) {
      scoreSum += sezioni[i].maxScore ?? 0;
    }
    return scoreSum;
  }

  FormAss.fromJson(Map<String, dynamic> json)
      : formId = json['form_id'],
        formName = json['form_name'],
        formDesc = json['form_desc'],
        tutorialTitle = json['tutorial_title'],
        sezioni = List.from(json['sezioni'])
            .map((e) => Sezione.fromJson(e))
            .toList() {
    maxScore = _initializeMaxScore();
  }

  //sommo lo score di tutte le sezioni di quel Form
  int get score {
    int punteggiSezione = 0;
    for (int i = 0; i < sezioni.length; i++) {
      punteggiSezione += sezioni[i].score;
    }
    _score = punteggiSezione;
    return _score;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['form_id'] = formId;
    _data['form_name'] = formName;
    _data['form_desc'] = formDesc;
    _data['sezioni'] = sezioni.map((e) => e.toJson()).toList();
    return _data;
  }

  @override
  String toString() => "id: $formId, name: $formName, sezioni: $sezioni";
}

class Sezione {
  final int sezioneId;
  final String sezioneTitle;
  final String sezioneDesc;
  final String? imagePath;
  final List<Domanda> domande;
  late final int? maxScore;
  //la somma del punteggio di ogni domanda !
  int _score = 0;

  Sezione({
    required this.sezioneId,
    required this.sezioneTitle,
    required this.sezioneDesc,
    required this.imagePath,
    required this.domande,
  }) {
    maxScore = _initializeMaxScore();
  }

  Sezione.fromJson(Map<String, dynamic> json)
      : sezioneId = json['sezione_id'],
        sezioneTitle = json['sezione_title'],
        sezioneDesc = json['sezione_desc'],
        imagePath = json['image_path'] ??= null,
        domande = List.from(json['domande'])
            .map((e) => Domanda.fromJson(e))
            .toList() {
    maxScore = _initializeMaxScore();
  }

//maxScore della Sezione = somma del massimo punteggio di ogni domanda
  int? _initializeMaxScore() {
    int scoreSum = 0;
    int count = 0;
    for (int i = 0; i < domande.length; i++) {
      if (domande[i].domandaType == FormDomandaType.score) {
        scoreSum += domande[i].punteggioMax!;
      } else {
        count++;
      }
    }
    if (count == domande.length) {
      return null;
    }
    return scoreSum;
  }

  //sommo lo score di tutte le domande di quella sezione
//se lo score di una domanda è null => sommo 0
  int get score {
    int punteggiDomande = 0;
    for (int i = 0; i < domande.length; i++) {
      if (domande[i].domandaType == FormDomandaType.score &&
          domande[i].response != null) {
        punteggiDomande += int.parse(domande[i].response!);
      }
    }
    _score = punteggiDomande;
    return _score;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['sezione_id'] = sezioneId;
    _data['sezione_title'] = sezioneTitle;
    _data['sezione_desc'] = sezioneDesc;
    _data['domande'] = domande.map((e) => e.toJson()).toList();
    return _data;
  }

  @override
  String toString() => "sez_id: $sezioneId, domande: $domande";
}

//* Domanda strutturata come nel FORM JSON
class Domanda {
  final int domandaId;
  final String? domandaTitle;
  final String domandaDesc;
  final bool isObbligatoria;
  final FormDomandaType domandaType;
  final int? punteggioMax;
  final int? punteggioMin;
  final String? text;
  final List<String>? labels;
  final List<String>? checkValues;
  final String? data;
  String? response;
  Set<String>? responseCheckBox;

  Domanda({
    required this.domandaId,
    required this.domandaTitle,
    required this.domandaDesc,
    required this.isObbligatoria,
    required this.domandaType,
    this.punteggioMax,
    this.punteggioMin,
    this.text,
    this.labels,
    this.checkValues,
    this.data,
    this.response,
  });

  Domanda.fromJson(Map<String, dynamic> json)
      : domandaId = json['domanda_id'],
        domandaTitle = json['domanda_title'],
        domandaDesc = json['domanda_desc'],
        isObbligatoria = json['is_obbligatoria'],
        domandaType = getTypeByName(json['type']),
        punteggioMax = json['type'] == "score" ? json['punteggio_max'] : null,
        punteggioMin = json['type'] == "score" ? json['punteggio_min'] : null,
        text = json['type'] == "text" ? json['text'] : null,
        labels = json['type'] == "label" ? json['label'].cast<String>() : null,
        checkValues = json['type'] == "check_value"
            ? json['check_value'].cast<String>()
            : null,
        data = json['type'] == "data" ? json['data'] : null;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['domanda_id'] = domandaId;
    _data['domanda_title'] = domandaTitle;
    _data['domanda_desc'] = domandaDesc;
    _data['is_obbligatoria'] = isObbligatoria;
    _data['punteggio_max'] = punteggioMax;
    _data['punteggio_min'] = punteggioMin;
    _data['type'] = getName(domandaType);
    //aggiungere response
    return _data;
  }

  @override
  String toString() =>
      "domanda_id: $domandaId, type: $domandaType, punteggioMax: $punteggioMax, response: $response e responseChechBox: $responseCheckBox";
}

//? posso fare una classe unica? bhoo

//* Domanda strutturata come la Tabella nel Db interno
class TableDomandaComp {
  final int domandaId; //uguale all'id della domanda presa dal json
  final int sezioneId; //stessa cosa dell'id domanda
  final int compilazioneId;
  final String type;
  //risposta data dall'utente alla domanda
  final String? response;
  final int? maxScore;

  TableDomandaComp({
    required this.domandaId,
    required this.sezioneId,
    required this.compilazioneId,
    required this.response,
    required this.type,
    required this.maxScore,
  });

  Map<String, dynamic> domandaToDb() {
    return {
      'domanda_id': domandaId,
      'sezione_id': sezioneId,
      'compilazione_id': compilazioneId,
      'type': type,
      'response': response,
      'max_score': maxScore,
    };
  }

  TableDomandaComp.fromDB(Map<String, dynamic> json)
      : domandaId = json['domanda_id'],
        sezioneId = json['sezione_id'],
        compilazioneId = json['compilazione_id'],
        response = json['response'],
        maxScore = json['max_score'],
        type = json['type'];

  @override
  String toString() =>
      "id: $domandaId, sezId: $sezioneId, response: $response, max score: $maxScore, type: $type";
}

class RispostaCheckBox {
  final int domandaId;
  final int sezioneId;
  final int formId;
  final int compilazioneId;
  final int position;

  RispostaCheckBox({
    required this.domandaId,
    required this.sezioneId,
    required this.formId,
    required this.compilazioneId,
    required this.position,
  });

  Map<String, dynamic> rispostaToDB() {
    return {
      "compilazione_id": compilazioneId,
      "form_id": formId,
      "sezione_id": sezioneId,
      "domanda_id": domandaId,
      "position": position
    };
  }

  RispostaCheckBox.fromJSON(Map<String, dynamic> data)
      : domandaId = data['domanda_id'],
        sezioneId = data['sezione_id'],
        formId = data['form_id'],
        compilazioneId = data['compilazione_id'],
        position = data['position'];
}
