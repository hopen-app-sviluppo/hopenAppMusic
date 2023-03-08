enum FormDomandaType {
  //ho una lista di item, ne deve selezionare 1
  label,
  //ho una lsita di items, può selezionarne quanti ne vuole
  checkValue,
  //scrive testo libero
  text,
  //ha un punteggio da dare
  score,
  //inserisco una data ! (da calendario)
  data,
}

String getName(FormDomandaType type) {
  switch (type) {
    case FormDomandaType.label:
      return "label";
    case FormDomandaType.checkValue:
      return "check_value";
    case FormDomandaType.text:
      return "text";
    case FormDomandaType.score:
      return "score";
    case FormDomandaType.data:
      return "data";
  }
}

FormDomandaType getTypeByName(String name) {
  switch (name) {
    case "label":
      return FormDomandaType.label;
    case "check_value":
      return FormDomandaType.checkValue;
    case "score":
      return FormDomandaType.score;
    case "data":
      return FormDomandaType.data;
    default:
      return FormDomandaType.text;
  }
}


//nel form ho sempre varie sezioni, con domande

//per ogni sezioni, buildo una pagina

//per ogni sezione, buildo tanti box quante sono le domande

//ogni domanda può essere di tipo: labels, check....(vedi sopra)


//in merito alle risposte date:

//se è labels, allora sul DB ci va in testuale, 
//se è text, allora sul DB ci va in testuale,
// se è data, allora sul DB ci va in testuale,
//se è score, allora sul DB ci va in testuale,

//se è checkValues ??? creo tabella con tutti i possibili check values ? e sul DB ci metto chiave esternadei values creati??
  //però serve tabella con tutti i check values, e sul db ci metto una lista?? nah.
  // sul db non posso mettere liste, 


//creo database di domande, per ogni domanda inserisco le risposte (che possono essere punteggi, testi, date ecc)