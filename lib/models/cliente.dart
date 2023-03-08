//assistito
class Cliente {
  //per ora id non è final
  int? id;
  final int userId;
  final String nome;
  final String cognome;
  final String sigla;
  String? codiceFiscale;
  String? sesso;
  String? cittadinanza;
  //le salvo come stringhe, del tipo => "2022-07-10"
  String? dataDiNascita;
  String? dataDecesso;
  String? statoCivile;
  String? condProfessionale;
  String? istruzione;
  String? professione;
  String? comuneDiNascita;
  String? nazione;
  String? aslDiAppartenenza;
  String? provDiNascita;
  String? telefono;
  String? telefono2;
  String? telefono3;
  String? telefono4;
  String? email;
  String? emailPec;
  String? indirizzoResidenza;
  String? indirizzo2Residenza;
  String? cittaResidenza;
  String? provResidenza;
  String? capResidenza;
  String? nazioneResidenza;
  String? indirizzoDomicilio;
  String? indirizzo2Domicilio;
  String? cittaDomicilio;
  String? provDomicilio;
  String? capDomicilio;
  String? nazioneDomicilio;

  Cliente({
    required this.userId,
    required this.nome,
    required this.cognome,
    this.id,
    this.codiceFiscale,
    this.sesso,
    this.cittadinanza,
    this.dataDiNascita,
    this.dataDecesso,
    this.statoCivile,
    this.condProfessionale,
    this.istruzione,
    this.professione,
    this.comuneDiNascita,
    this.nazione,
    this.aslDiAppartenenza,
    this.provDiNascita,
    this.telefono,
    this.telefono2,
    this.telefono3,
    this.telefono4,
    this.email,
    this.emailPec,
    this.indirizzoResidenza,
    this.indirizzo2Residenza,
    this.cittaResidenza,
    this.provResidenza,
    this.capResidenza,
    this.nazioneResidenza,
    this.indirizzoDomicilio,
    this.indirizzo2Domicilio,
    this.cittaDomicilio,
    this.provDomicilio,
    this.capDomicilio,
    this.nazioneDomicilio,
  }) : sigla = "${nome[0].toUpperCase()} ${cognome[0].toUpperCase()}";

  //* utile per definire colonne su database
  static final List<String> clienteValues = [
    "client_id",
    "client_name",
    "client_cognome",
    "client_codice_fiscale",
    "client_sesso",
    "client_cittadinanza",
    "client_data_nascita",
    "client_data_decesso",
    "client_stato_civile",
    "client_condizione_professionale",
    "client_istruzione",
    "client_professione",
    "client_comune_nascita",
    "client_asl_appartenenza",
    "client_provincia_nascita",
    "client_phone",
    "client_phone2",
    "client_phone3",
    "client_phone4",
    "client_email",
    "client_email_pec",
    "client_address_1",
    "client_address_2",
    "client_city",
    "client_country",
    "client_residenza_cap",
    "client_state",
    "client_domicilio_address_1",
    "client_domicilio_address_2",
    "client_domicilio_city",
    "client_domicilio_country",
    "client_domicilio_cap",
    "client_domicilio_state",
    "id",
  ];

//prendere assistito dal db
  static Cliente fromJSON(Map<String, dynamic> data) {
    final newAssistito = Cliente(
      userId: data["user_id"],
      id: data["client_id"],
      nome: data["client_name"],
      cognome: data["client_cognome"],
      codiceFiscale: data["client_codice_fiscale"],
      sesso: data["client_sesso"],
      cittadinanza: data["client_cittadinanza"],
      dataDiNascita: data["client_data_nascita"],
      dataDecesso: data["client_data_decesso"],
      statoCivile: data["client_stato_civile"],
      condProfessionale: data["client_condizione_professionale"],
      istruzione: data["client_istruzione"],
      professione: data["client_professione"],
      comuneDiNascita: data["client_comune_nascita"],
      nazione: data["client_state"],
      aslDiAppartenenza: data["client_asl_appartenenza"],
      provDiNascita: data["client_provincia_nascita"],
      telefono: data["client_phone"],
      telefono2: data["client_phone2"],
      telefono3: data["client_phone3"],
      telefono4: data["client_phone4"],
      email: data["client_email"],
      emailPec: data["client_email_pec"],
      indirizzoResidenza: data["client_address_1"],
      indirizzo2Residenza: data["client_address_2"],
      cittaResidenza: data["client_city"],
      provResidenza: data["client_country"],
      capResidenza: data["client_residenza_cap"],
      nazioneResidenza: data["client_residenza_state"],
      indirizzoDomicilio: data["client_domicilio_address_1"],
      indirizzo2Domicilio: data["client_domicilio_address_2"],
      cittaDomicilio: data["client_domicilio_city"],
      provDomicilio: data["client_domicilio_country"],
      capDomicilio: data["client_domicilio_cap"],
      nazioneDomicilio: data["client_domicilio_state"],
    );
    return newAssistito;
  }

//per salvare l'assistito nel db
  Map<String, dynamic> toJSON() {
    return <String, dynamic>{
      "user_id": userId,
      "client_id": id,
      "client_name": nome,
      "client_cognome": cognome,
      "client_codice_fiscale": codiceFiscale,
      "client_sesso": sesso,
      "client_cittadinanza": cittadinanza,
      "client_data_nascita": dataDiNascita,
      "client_data_decesso": dataDecesso,
      "client_stato_civile": statoCivile,
      "client_condizione_professionale": condProfessionale,
      "client_istruzione": istruzione,
      "client_professione": professione,
      "client_comune_nascita": comuneDiNascita,
      "client_state": nazione,
      "client_asl_appartenenza": aslDiAppartenenza,
      "client_provincia_nascita": provDiNascita,
      "client_phone": telefono,
      "client_phone2": telefono2,
      "client_phone3": telefono3,
      "client_phone4": telefono4,
      "client_email": email,
      "client_email_pec": emailPec,
      "client_address_1": indirizzoResidenza,
      "client_address_2": indirizzo2Residenza,
      "client_city": cittaResidenza,
      "client_country": provResidenza,
      "client_residenza_cap": capResidenza,
      "client_residenza_state": nazioneResidenza,
      "client_domicilio_address_1": indirizzoDomicilio,
      "client_domicilio_address_2": indirizzo2Domicilio,
      "client_domicilio_city": cittaDomicilio,
      "client_domicilio_country": provDomicilio,
      "client_domicilio_cap": capDomicilio,
      "client_domicilio_state": nazioneDomicilio,
    };
  }

  void updateVal(String valToUpdate, String newVal) {
    switch (valToUpdate) {
      case "client_codice_fiscale":
        codiceFiscale = newVal;
        return;
      case "client_sesso":
        sesso = newVal;
        return;
      case "client_cittadinanza":
        cittadinanza = newVal;
        return;
      case "client_data_nascita":
        dataDiNascita = newVal;
        return;
      case "client_data_decesso":
        dataDecesso = newVal;
        return;
      case "client_stato_civile":
        statoCivile = newVal;
        return;
      case "client_condizione_professionale":
        condProfessionale = newVal;
        return;
      case "client_istruzione":
        istruzione = newVal;
        return;
      case "client_professione":
        professione = newVal;
        return;
      case "client_comune_nascita":
        comuneDiNascita = newVal;
        return;
      case "client_state":
        nazione = newVal;
        return;
      case "client_asl_appartenenza":
        aslDiAppartenenza = newVal;
        return;
      case "client_provincia_nascita":
        provDiNascita = newVal;
        return;
      case "client_phone":
        telefono = newVal;
        return;
      case "client_phone2":
        telefono2 = newVal;
        return;
      case "client_phone3":
        telefono3 = newVal;
        return;
      case "client_phone4":
        telefono4 = newVal;
        return;
      case "client_email":
        email = newVal;
        return;
      case "client_email_pec":
        emailPec = newVal;
        return;
      case "client_address_1":
        indirizzoResidenza = newVal;
        return;
      case "client_address_2":
        indirizzo2Residenza = newVal;
        return;
      case "client_city":
        cittaResidenza = newVal;
        return;
      case "client_country":
        provResidenza = newVal;
        return;
      case "client_residenza_cap":
        capResidenza = newVal;
        return;
      case "client_residenza_state":
        nazioneResidenza = newVal;
        return;
      case "client_domicilio_address_1":
        indirizzoDomicilio = newVal;
        return;
      case "client_domicilio_address_2":
        indirizzo2Domicilio = newVal;
        return;
      case "client_domicilio_city":
        cittaDomicilio = newVal;
        return;
      case "client_domicilio_country":
        provDomicilio = newVal;
        return;
      case "client_domicilio_cap":
        capDomicilio = newVal;
        return;
      case "client_domicilio_state":
        nazioneDomicilio = newVal;
        return;
      default:
        return;
    }
  }

  @override
  String toString() =>
      "id: $id, nome: $nome, cognome: $cognome, email: $email, comune di nascita: $comuneDiNascita";
}

/*TODO: unifrmare DATABASE fi_clients con questo, qua sono le voci mancanti

'client_date_created'
'client_date_modified`'
'client_zip`'
'client_active'
'client_partita_iva'
'client_attivita_svolta'
'client_cittadinanza_id`'
'client_statocivile_id'
'client_istruzione_id`'
'client_condizioneprofessionale_id`'
'client_professione_id`'
'client_invaliditacivile`'
'client_servizio_entita_corrente`'
'client_servizio_rete_geografica_territoriale'
'client_servizio_in_mobilita'
'client_cap_nascita`'
'client_nazione_nascita`'
'client_tipo_assistito`'
'client_phone5`'
'client_domicilio_zip`'
'client_coreset_id`'
'client_giornate'


*/