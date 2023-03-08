//account utente nel DB interno, ha tutti i dati dell'utente che non stanno nel social

class InternalAccount {
  final String token;
  final int id;
  String? company;
  String? partitaIva;
  String? attivita;
  int? numPazienti;
  int? feedbackInviati;

  InternalAccount({
    required this.token,
    required this.id,
    this.company,
    this.partitaIva,
    this.attivita,
    this.numPazienti = 0,
    this.feedbackInviati = 0,
  });

//lo uso quando creo un utente nel DB, in quel caso i valori sono l'ID (primary key), e il Token
  InternalAccount.empty(this.id, this.token)
      : company = null,
        partitaIva = null,
        attivita = null,
        numPazienti = 0,
        feedbackInviati = 0;

//aggiungere id
  InternalAccount.fromDB(Map<String, dynamic> dbData)
      : id = dbData['user_id'],
        token = dbData['token'],
        company = dbData['company'],
        partitaIva = dbData['partita_iva'],
        attivita = dbData['attivita'],
        numPazienti = dbData['num_pazienti'],
        feedbackInviati = dbData['feedback_inviati'];

//aggiungere id nel DB interno
  Map<String, dynamic> toDB() => {
        "user_id": id,
        "token": token,
        "company": company,
        "partita_iva": partitaIva,
        "attivita": attivita,
        "num_pazienti": numPazienti,
        "feedback_inviati": feedbackInviati,
      };

  void updateVal(String valToUpdate, String newVal) {
    switch (valToUpdate) {
      case "company":
        company = newVal;
        return;
      case "partita_iva":
        partitaIva = newVal;
        return;
      case "attivita":
        attivita = newVal;
        return;
      default:
        return;
    }
  }

  @override
  String toString() =>
      "internal: company: $company, piva: $partitaIva, attivita: $attivita, numPazienti: $numPazienti, feedback inviati: $feedbackInviati, token: $token";
}
