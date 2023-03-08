import 'package:flutter/material.dart';
import 'package:music/database/form_operations.dart';
import 'package:music/models/form_assistito.dart';
import 'package:music/models/cliente.dart';
import 'package:music/models/compilazione_form.dart';
import 'package:music/models/form_domanda_enum.dart';
import 'package:music/models/risultati_comp_musicoterapia.dart';
import 'compilazione_type.dart';

class CompilazioneFormProvider with ChangeNotifier {
  final FormAss currentForm;
  late Sezione currentSection;
  late final CompilazioneType compType;
  Cliente? cliente;
  int? compilazioneId;
  List<TableDomandaComp>? domandeCompilateOnDb;
  List<RispostaCheckBox>? risposteCheckBox;
  //sarà del tipo: yyyy-mm-dd : hh:mm:ss
  DateTime? compilazioneData;
  //PER ora  segnalare errore se utente vuole visualizzare compilazione e fallisco nell'ottenere le domande dal DB
  String? error;

  CompilazioneFormProvider({
    required this.currentForm,
    //è una compilazione o una visualizzazione ?
    required bool isCompilingForm,
    this.cliente,
    this.compilazioneId,
    this.domandeCompilateOnDb,
  }) {
    currentSection = currentForm.sezioni.first;
    if (isCompilingForm) {
      compType = CompilazioneType.writing;
    } else {
      compType = CompilazioneType.reading;
      addScore(domandeCompilateOnDb!);
    }
    //* controllo se esiste gia un'istanza, se esiste allora appare un PopUp => hai già un form aperto, vuoi continuare a compilarlo?
  }

//aggiorno sezione corrente
  void updateCurrentSection(Sezione newSection) {
    currentSection = newSection;
    notifyListeners();
  }

//aggiorno assistito
  void updateCliente(Cliente newCliente) {
    cliente = newCliente;
    notifyListeners();
  }

  //aggiorno l'errore !
  void updateError(String? newError) {
    error = newError;
    notifyListeners();
  }

  //funzione che attribuisce score alla domanda
  void setDomandaScore(int newScore, int domandaId) {
    for (var domanda in currentSection.domande) {
      if (domanda.domandaId == domandaId) {
        domanda.response = newScore.toString();
        domanda.response = newScore.toString();
        break;
      }
    }
    notifyListeners();
  }

  void setDomandaResponse(String? newResponse, int domandaId) {
    for (var domanda in currentSection.domande) {
      if (domanda.domandaId == domandaId) {
        domanda.response = newResponse;
        break;
      }
    }
    notifyListeners();
  }

  void setDomandaCheckBoxResponse(Set<String> risposteCheckBox, int domandaId) {
    for (var domanda in currentSection.domande) {
      if (domanda.domandaId == domandaId) {
        domanda.responseCheckBox = risposteCheckBox;
        break;
      }
    }
    notifyListeners();
  }

  Domanda getDomandaById(int id) =>
      currentSection.domande.firstWhere((domanda) => domanda.domandaId == id);

  //si può passare alla sezione successiva solo se l'utente ha dato un voto a tutte le domande obbligatorie
  //altrimenti appare un errore => rispondere a tutte le domande Obbligatorie !
  //? QUA mi salvo i punteggi delle domande, per ottenere i risultati nella compilazione !
  bool domandeCompilate() {
    bool success = true;

    //filtro solo le domande obbligatorie dalla sezione
    final domandeObbligatorie = currentSection.domande
        .where((domanda) => domanda.isObbligatoria)
        .toList();

    //controllo se ogni domanda obbligatoria è stata risposta (se ha uno score allora si)
    for (var domanda in domandeObbligatorie) {
      //  print("score: ${domanda.score}");
      if (domanda.response == null || int.parse(domanda.response!) == 0) {
        success = false;
        break;
      }
    }
    return success;
  }

  //todo: da riciclare con quello della musicoterapia
  Future<void> compilaForm({
    required int userId,
  }) async {
    try {
      if (currentForm.formId == 0) {
        await compilaFormMusicoterapia(userId: userId);
      } else {
        await compilaDiario(userId: userId);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> compilaDiario({
    required int userId,
  }) async {
    final DateTime now = compilazioneData ?? DateTime.now();
    //devo creare tante tabelle quante sono le domande !
    final form = CompilazioneForm(
      userId: userId,
      assistitoId: cliente!.id!,
      assistitoName: cliente!.nome,
      assistitoCognome: cliente!.cognome,
      creatoIl: now,
      //all'inizio prende lo stesso valore di creatoIl
      ultimaModifica: now,
      formId: currentForm.formId,
      formName: currentForm.formName,
      maxScore: currentForm.maxScore,
      score: currentForm.maxScore == null ? null : currentForm.score,
    );
    try {
      //?creo compilazione
      int compilazioneId = await FormOperations.createCompilazioneForm(form);
      List<TableDomandaComp> tableDomandeComp = [];
      List<RispostaCheckBox> risposteCheckBox = [];
      for (int i = 0; i < currentForm.sezioni.length; i++) {
        //per ogni sezione
        final sezione = currentForm.sezioni[i];
        List<TableDomandaComp> domandeComp = [];
        for (int j = 0; j < sezione.domande.length; j++) {
          //per ogni domanda
          final domanda = sezione.domande[j];
          //se c'è una risposta alla domanda, allora
          if (domanda.response != null || domanda.responseCheckBox != null) {
            domandeComp.add(
              TableDomandaComp(
                domandaId: domanda.domandaId,
                compilazioneId: compilazioneId,
                sezioneId: sezione.sezioneId,
                type: getName(domanda.domandaType),
                response: domanda.domandaType == FormDomandaType.checkValue
                    ? domanda.responseCheckBox!.join(',')
                    : domanda.response,
                maxScore: domanda.punteggioMax,
              ),
            );
            if (domanda.domandaType == FormDomandaType.checkValue) {
              for (var risposta in domanda.responseCheckBox!) {
                risposteCheckBox.add(RispostaCheckBox(
                  domandaId: domanda.domandaId,
                  sezioneId: sezione.sezioneId,
                  formId: currentForm.formId,
                  compilazioneId: compilazioneId,
                  position: int.parse(risposta),
                ));
              }
            }
          }
        }
        tableDomandeComp += domandeComp;
      }
      //aggiungo le domande nel DB interno
      final result = await FormOperations.insertDomandeComp(tableDomandeComp);
      if (!result) {
        //!se fallisco nell'inserire le domande nel DB, allora devo cancellare compilazione ! è errata !
        await FormOperations.deleteCompilazioneForm(compilazioneId);
        updateError("Si è Verificato un Errore Indesiderato");
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  //*funzione che inserisce il form Compilato nel Db !
  Future<void> compilaFormMusicoterapia({required int userId}) async {
    final DateTime now = compilazioneData ?? DateTime.now();
    //devo creare tante tabelle quante sono le domande !
    final form = CompilazioneForm(
      userId: userId,
      assistitoId: cliente!.id!,
      assistitoName: cliente!.nome,
      assistitoCognome: cliente!.cognome,
      creatoIl: now,
      //all'inizio prende lo stesso valore di creatoIl
      ultimaModifica: now,
      formId: currentForm.formId,
      formName: currentForm.formName,
      maxScore: currentForm.maxScore,
      score: currentForm.maxScore == null ? null : currentForm.score,
    );
    //* Risultati della compilazione
    double resultEtaMusic02 = 0.0;
    double resultEtaMusic24 = 0.0;
    double resultEtaMusic46 = 0.0;
    Map<String, double> mood = {};
    Map<String, double> musicofilia = {};
    //salvo Form nel database interno
    try {
      //?creo compilazione
      int compilazioneId = await FormOperations.createCompilazioneForm(form);
      //ogni elemento è una riga che aggiungo nel DB (tabella Domanda)
      List<TableDomandaComp> tableDomandeComp = [];
      for (int i = 0; i < currentForm.sezioni.length; i++) {
        //per ogni sezione
        final sezione = currentForm.sezioni[i];
        List<TableDomandaComp> domandeComp = [];
        for (int j = 0; j < sezione.domande.length; j++) {
          //per ogni domanda
          final domanda = sezione.domande[j];
          //se c'è una risposta alla domanda, allora
          if (domanda.response != null) {
            domandeComp.add(
              TableDomandaComp(
                domandaId: domanda.domandaId,
                compilazioneId: compilazioneId,
                sezioneId: sezione.sezioneId,
                type: getName(domanda.domandaType),
                response: domanda.domandaType == FormDomandaType.checkValue
                    ? domanda.responseCheckBox!.join(',')
                    : domanda.response,
                //!score: domanda.score,
                maxScore: domanda.punteggioMax,
              ),
            );
          }
        }
        tableDomandeComp += domandeComp;
        //? salvo risultati
        if (i == 0) {
          resultEtaMusic02 = getEtaMusicaleScore(domandeComp, 7);
          continue;
        }
        if (i == 1) {
          resultEtaMusic24 = getEtaMusicaleScore(domandeComp, 5);
          continue;
        }
        if (i == 2) {
          resultEtaMusic46 = getEtaMusicaleScore(domandeComp, 4);
          continue;
        }
        if (i == 3) {
          //mood
          mood = getMoodScore(domandeComp);
          continue;
        }
        if (i == 4) {
          musicofilia = getMusicofiliaScore(domandeComp);
          continue;
        }
      }
      final bool isDomandeInsertedToDb =
          await FormOperations.insertDomandeComp(tableDomandeComp);
      if (isDomandeInsertedToDb) {
        //! creo tabella dei risultati, se da errore qua ???
        final RisultatiCompMusic result = RisultatiCompMusic(
          etaMusicale02: resultEtaMusic02,
          etaMusicale24: resultEtaMusic24,
          etaMusicale46: resultEtaMusic46,
          mood: mood,
          musicofilia: musicofilia,
          compId: compilazioneId,
        );
        // print("musocifilia: $musicofilia");
        await FormOperations.createRisultatoCompMusic(result);
        //una volta compilato il form pulisco tutto !
      } else {
        //!se fallisco nell'inserire le domande nel DB, allora devo cancellare compilazione ! è errata !
        await FormOperations.deleteCompilazioneForm(compilazioneId);
        updateError("Si è Verificato un Errore Indesiderato");
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  void resetForm() {
    //TODO: Funzione create per pulire istanza corrente, nel caso in cui un utente invii una compilazione o ne cominci una nuova

    //TODO: ALTRIMENTI SE COMPILO E NE VOGLIO FARE UNA NUOVA MI RICOMPARE QUELLA PRIMA

    //idea: posso pulire tutti i punteggi e settarli a null, tanto il resto è tutto uguale !

    //per ogni sezione, per ogni domanda metto punteggio a null
    for (var sezione in currentForm.sezioni) {
      for (var domanda in sezione.domande) {
        domanda.response = null;
      }
    }
    notifyListeners();
  }

//ho preso le domande nel DB interno, ho le domande prese in JSON
//con questa funzione setto i punteggi delle domande con quelli nel DB
//per matchare le giuste domande uso l'id della sezione e l'id della domanda
  //funzione da rivedere
  void addScore(List<TableDomandaComp> domandeComp) {
    for (int i = 0; i < currentForm.sezioni.length; i++) {
      //filtro le domande che hanno sezione_id == sezione_id
      final sezione = currentForm.sezioni[i];
      final domandeSezione = domandeComp
          .where((element) => element.sezioneId == sezione.sezioneId)
          .toList();
      for (int j = 0; j < sezione.domande.length; j++) {
        final domanda = sezione.domande[j];

        for (var scoreDomanda in domandeSezione) {
          if (scoreDomanda.domandaId == domanda.domandaId) {
            if (scoreDomanda.type == getName(FormDomandaType.checkValue)) {
              domanda.responseCheckBox =
                  scoreDomanda.response!.split(',').toSet();
            } else {
              domanda.response = scoreDomanda.response;
            }
          }
        }
      }
    }
  }

//? Funzioni per salvare i risultati della compilazione del Form di Musicoterapia nel DB interno

//? CALCOLA PERCENTUALE DEI RISULTATI DEL PROFILO DI ETA' MUSICALE
  //TODO: per domani vedere se posso usare i punteggi della sezione, anizchè rivedere tutte le domande
  //TODO: poi calcolare grafico Musicofilia
  //TODO: per ora aggancio le liste tramite l'indice, dovrebbe andar bene perchè stanno sempre in ordine
  //se darà problemi, allora aggancio con l'id della compilazione
  double getEtaMusicaleScore(List<TableDomandaComp> domande, int domandeCount) {
    int score = 0;
    int maxScore = 0;
    for (int i = 0; i < domande.length; i++) {
      maxScore += domande[i].maxScore!;
      score += int.parse(domande[i].response!);
    }
    return ((score - domandeCount) / (maxScore - domandeCount)) * 100;
  }

  //? Calcolo del profilo mood (sono 7 domande), gestite da 2 semplici funzioni (mood1 e mood2)

  Map<String, double> getMoodScore(List<TableDomandaComp> domande) {
    Map<String, double> res = {
      "sicuro": 0.0,
      "ambivalente": 0.0,
    };

    //sicuro, insicuro => minimo -2, massimo 2
    int sommaSicuro = mood1(int.parse(domande[0].response!)) +
        mood1(int.parse(domande[1].response!)) +
        mood1(int.parse(domande[2].response!)) +
        mood1(int.parse(domande[3].response!));
    double mediaSicuro = sommaSicuro / 4;

    int sommaAmbivalente = mood1(int.parse(domande[4].response!)) +
        mood2(
          int.parse(domande[5].response!),
          int.parse(domande[1].response!),
        ) +
        mood1(int.parse(domande[6].response!));
    double mediaAmbivalente = sommaAmbivalente / 3;

    res['sicuro'] = mediaSicuro;
    res['ambivalente'] = mediaAmbivalente;
    return res;
//? siccome il valore minimo è 1, non può venire -12 (quindi la media non può venire -3)
    // if (mediaSicuro == -3) {
    //   //niente
    // } else {
    //   res['sicuro'] = mediaSicuro;
    // }

    // if (mediaAmbivalente == -3) {
    //   //niente
    // } else {
    //   res['ambivalente'] = mediaAmbivalente;
    // }
  }

  int mood1(int n) {
    if (n < 3) {
      return n - 3;
    }
    return n - 2;
  }

//usata solo 1 volta
  int mood2(int n, int m) {
    if (n < 3) {
      return n - 3;
    }
    return m - 2;
  }

//? funzione che calcola punteggio di Profilo Musicofilia
  Map<String, double> getMusicofiliaScore(List<TableDomandaComp> domande) {
    Map<String, double> res = {
      "emotivo": 0.0,
      "relazionale": 0.0,
      "dentro": 0.0,
      "razionale": 0.0,
      "fianco": 0.0,
      "intorno": 0.0
    };
    for (int i = 0; i < domande.length; i++) {
      //! final currentScore = domande[i].score;
      final currentScore = int.parse(domande[i].response!);
      //domanda: comp_id,score,maxScore,domandaId, sezId
      //domanda[0] => mimica
      //domanda[1] => attività vocalica
      //domanda[2] => attività motoria
      //domanda[3] => stereotipie
      //domanda[4] => aggancio oculare
      //?_____________  //?mimica     //? att.vocalica    //? att. motoria  //?stereotipie  //? aggancio oculare
      //* emotivo =     function2()   + function1()       + function1()     + function2()     + function2()
      //* relazionale = function1()   + function1()       + function1()     + function3()     + function1()
      //* dentro =      function4()   + function4()       + function1()     + function1()     + function3()
      //* razionale =   function3()   + function3()       + function3()     + function3()     + function3()
      //* a fianco =    function2()   + function2()       + function2()     + function2()     + function2()
      //* intorno =     function2()   + function2()       + function2()     + function2()     + function2()

      if (i == 0) {
        //mimica
        res["emotivo"] = res["emotivo"]! + function2(currentScore);
        res["relazionale"] = res["relazionale"]! + function1(currentScore);
        res["dentro"] = res["dentro"]! + function4(currentScore);
        res["razionale"] = res["razionale"]! + function3(currentScore);
        res["fianco"] = res["fianco"]! + function2(currentScore);
        res["intorno"] = res["intorno"]! + function2(currentScore);
        continue;
      }
      if (i == 1) {
        //att vocalica
        res["emotivo"] = res["emotivo"]! + function1(currentScore);
        res["relazionale"] = res["relazionale"]! + function1(currentScore);
        res["dentro"] = res["dentro"]! + function4(currentScore);
        res["razionale"] = res["razionale"]! + function3(currentScore);
        res["fianco"] = res["fianco"]! + function2(currentScore);
        res["intorno"] = res["intorno"]! + function2(currentScore);
        continue;
      }
      if (i == 2) {
        //att. motoria
        res["emotivo"] = res["emotivo"]! + function1(currentScore);
        res["relazionale"] = res["relazionale"]! + function1(currentScore);
        res["dentro"] = res["dentro"]! + function1(currentScore);
        res["razionale"] = res["razionale"]! + function3(currentScore);
        res["fianco"] = res["fianco"]! + function2(currentScore);
        res["intorno"] = res["intorno"]! + function2(currentScore);
        continue;
      }
      if (i == 3) {
        //stereotipie
        res["emotivo"] = res["emotivo"]! + function2(currentScore);
        res["relazionale"] = res["relazionale"]! + function3(currentScore);
        res["dentro"] = res["dentro"]! + function1(currentScore);
        res["razionale"] = res["razionale"]! + function3(currentScore);
        res["fianco"] = res["fianco"]! + function2(currentScore);
        res["intorno"] = res["intorno"]! + function2(currentScore);
        continue;
      }
      if (i == 4) {
        //aggancio oculare
        res["emotivo"] = res["emotivo"]! + function2(currentScore);
        res["relazionale"] = res["relazionale"]! + function1(currentScore);
        res["dentro"] = res["dentro"]! + function3(currentScore);
        res["razionale"] = res["razionale"]! + function3(currentScore);
        res["fianco"] = res["fianco"]! + function2(currentScore);
        res["intorno"] = res["intorno"]! + function2(currentScore);
        continue;
      }
    }
    return res;
  }

  //? 3 funzioni per calcolare i valori della musicofilia
  //? il punteggio è dato da somme pesate

  double function1(int score) {
    switch (score) {
      case 1:
        return 0;
      case 2:
        return 0.07;
      case 3:
        return 0.14;
      case 4:
        return 0.2;
      default:
        return 0;
    }
  }

  double function2(int score) {
    switch (score) {
      case 2:
        return 0.1;
      case 3:
        return 0.2;
      default:
        return 0;
    }
  }

  double function3(int score) {
    switch (score) {
      case 1:
        return 0.2;
      case 2:
        return 0.14;
      case 3:
        return 0.07;
      default:
        return 0;
    }
  }

  double function4(int score) {
    switch (score) {
      case 2:
        return 0.2;
      case 3:
        return 0.1;
      default:
        return 0;
    }
  }
}
