import 'package:flutter/material.dart';
import 'package:music/database/client_operations.dart';

import 'package:provider/provider.dart';

import '../../../../models/cliente.dart';
import '../../../../provider/user_provider.dart';

class CreaAssistitoProvider with ChangeNotifier {
  String? nome;
  String? cognome;
  String? codiceFiscale;
  String? sesso;
  String? cittadinanza;
  //inserisco sottoforma di stringa, se mi dovessero servire operazioni temporali: Convertire in datetime!
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

  void updateField(String valToUpdate, String? newVal) {
    switch (valToUpdate) {
      case "nome":
        nome = newVal;
        break;
      case "cognome":
        cognome = newVal;
        break;
      case "cc":
        codiceFiscale = newVal;
        break;
      case "sesso":
        sesso = newVal;
        break;
      case "cittadinanza":
        cittadinanza = newVal;
        break;
      case "stato_civile":
        statoCivile = newVal;
        break;
      case "cond_professionale":
        condProfessionale = newVal;
        break;
      case "istruzione":
        istruzione = newVal;
        break;
      case "prof":
        professione = newVal;
        break;
      case "comune_nascita":
        comuneDiNascita = newVal;
        break;
      case "nazione":
        nazione = newVal;
        break;
      case "asl":
        aslDiAppartenenza = newVal;
        break;
      case "prov_nascita":
        provDiNascita = newVal;
        break;
      case "tel":
        telefono = newVal;
        break;
      case "2tel":
        telefono2 = newVal;
        break;
      case "3tel":
        telefono3 = newVal;
        break;
      case "4tel":
        telefono4 = newVal;
        break;
      case "email":
        email = newVal;
        break;
      case "pec":
        emailPec = newVal;
        break;
      case "ind_res":
        codiceFiscale = newVal;
        break;
      case "2ind_res":
        indirizzo2Residenza = newVal;
        break;
      case "citta_res":
        cittaResidenza = newVal;
        break;
      case "cap_res":
        capResidenza = newVal;
        break;
      case "naz_res":
        nazioneResidenza = newVal;
        break;
      case "prov_res":
        provResidenza = newVal;
        break;
      case "ind_dom":
        indirizzoDomicilio = newVal;
        break;
      case "2ind_dom":
        indirizzo2Domicilio = newVal;
        break;
      case "citta_dom":
        cittaDomicilio = newVal;
        break;
      case "cap_dom":
        capDomicilio = newVal;
        break;
      case "naz_dom":
        nazioneDomicilio = newVal;
        break;
      case "prov_dom":
        provDomicilio = newVal;
        break;
    }
  }

  void updateDate(String valToValidate, String newTime) {
    switch (valToValidate) {
      case "nascita":
        dataDiNascita = newTime;
        break;
      case "dec":
        dataDecesso = newTime;
        break;
    }
  }

  bool canCreateAssistito() => nome != null && cognome != null;

//funzione usata per i valori iniziali dei textfield
//risolve problema: perdevo il valore visualizzato switchando tra le pagine
  String? getCurrentField(String valToGet) {
    switch (valToGet) {
      case "nome":
        return nome;
      case "cognome":
        return cognome;
      case "cc":
        return codiceFiscale;
      case "sesso":
        return sesso;
      case "cittadinanza":
        return cittadinanza;
      case "stato_civile":
        return statoCivile;
      case "cond_professionale":
        return condProfessionale;
      case "istruzione":
        return istruzione;
      case "prof":
        return professione;
      case "comune_nascita":
        return comuneDiNascita;
      case "nazione":
        return nazione;
      case "asl":
        return aslDiAppartenenza;
      case "prov_nascita":
        return provDiNascita;
      case "tel":
        return telefono;
      case "2tel":
        return telefono2;
      case "3tel":
        return telefono3;
      case "4tel":
        return telefono4;
      case "email":
        return email;
      case "pec":
        return emailPec;
      case "ind_res":
        return indirizzoResidenza;
      case "2ind_res":
        return indirizzo2Residenza;
      case "citta_res":
        return cittaResidenza;
      case "cap_res":
        return capResidenza;
      case "naz_res":
        return nazioneResidenza;
      case "prov_res":
        return provResidenza;
      case "ind_dom":
        return indirizzoDomicilio;
      case "2ind_dom":
        return indirizzo2Domicilio;
      case "citta_dom":
        return cittaDomicilio;
      case "cap_dom":
        return capDomicilio;
      case "naz_dom":
        return nazioneDomicilio;
      case "prov_dom":
        return provDomicilio;
      case "nascita":
        return dataDiNascita;
      case "dec":
        return dataDecesso;
      default:
        return null;
    }
  }

  Future<bool> createAssistito(int userId, BuildContext context) async {
    //creo cliente con i dati immessi dall'utente
    //non gli passo l'id, lui fa da solo sul db
    final assistito = Cliente(
      //id dell'utente !
      userId: userId,
      nome: nome!,
      cognome: cognome!,
      codiceFiscale: codiceFiscale,
      sesso: sesso,
      cittadinanza: cittadinanza,
      dataDiNascita: dataDiNascita,
      dataDecesso: dataDecesso,
      statoCivile: statoCivile,
      condProfessionale: condProfessionale,
      istruzione: istruzione,
      professione: professione,
      comuneDiNascita: comuneDiNascita,
      nazione: nazione,
      aslDiAppartenenza: aslDiAppartenenza,
      provDiNascita: provDiNascita,
      telefono: telefono,
      telefono2: telefono2,
      telefono3: telefono3,
      telefono4: telefono4,
      email: email,
      emailPec: emailPec,
      indirizzoResidenza: indirizzoResidenza,
      indirizzo2Residenza: indirizzo2Residenza,
      cittaResidenza: cittaResidenza,
      provResidenza: provResidenza,
      capResidenza: capResidenza,
      nazioneResidenza: nazioneResidenza,
      indirizzoDomicilio: indirizzoDomicilio,
      indirizzo2Domicilio: indirizzo2Domicilio,
      cittaDomicilio: cittaDomicilio,
      provDomicilio: provDomicilio,
      capDomicilio: capDomicilio,
      nazioneDomicilio: nazioneDomicilio,
    );

    //opero sul db
    try {
      await ClienteOperations.createClient(assistito);
      //? creato l'assistito aggiorno la tabella User, riga num_pazienti e l'aumento di 1
      await context.read<UserProvider>().updateNumPazienti();
      //print("ecco assistito: $assistito");
      return true;
    } catch (e) {
      //! gestire errore in qualche modo?
      return false;
    }
  }
}
