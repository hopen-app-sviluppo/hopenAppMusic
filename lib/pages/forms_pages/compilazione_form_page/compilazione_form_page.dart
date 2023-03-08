import 'package:flutter/material.dart';
import 'package:music/models/form_assistito.dart';
import 'package:music/provider/settings_provider.dart';
import 'package:music/provider/user_provider.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

import '../../../router.dart';
import '../../common_widget/error_page.dart';
import '../../../helpers.dart';
import 'helpers/compilazione_form_provider.dart';
import 'helpers/compilazione_type.dart';
import 'views/sezione_page.dart';
import 'views/sezione_tutorial.dart';
import 'widgets/pallina.dart';

class CompilazioneFormPage extends StatefulWidget {
  const CompilazioneFormPage({Key? key}) : super(key: key);

  @override
  State<CompilazioneFormPage> createState() => _CompilazioneFormPageState();
}

class _CompilazioneFormPageState extends State<CompilazioneFormPage> {
  //controller per gestire il cambio pagina (sx o dx)
  late final PageController _pageController;
  //controller per gestire lo scorrimento delle palline
  late final ScrollController _scrollController;
  //indice corrente => mostra pagina corrente
  late int currentIndexPage;
  //Form scelto dall'utente
  late final FormAss currentForm;
  //se è reading => utente vuole visualizzare compilazione
  //se è writing => utente vuole fare una nuova compilazione
  late final CompilazioneType compState;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scrollController = ScrollController();
    currentIndexPage = _pageController.initialPage;
    final formProv = context.read<CompilazioneFormProvider>();
    currentForm = formProv.currentForm;
    compState = formProv.compType;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //se c'è stato un errore nel leggere le domande nel DB, allora devo buttare l'utente sulla Home
    final String? error = context.select<CompilazioneFormProvider, String?>(
        (compProv) => compProv.error);
    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Torna alla Home"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ),
        body: const SafeArea(
          child: ErrorPage(
            error: "Errore indesiderato",
          ),
        ),
      );
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () => checkFocus(context),
        child: PageView(
          controller: _pageController,
          //prima pagina è quella esplicativa
          //seconda pagina è la scelta dell'assistito
          children: _buildPages(),
          onPageChanged: onPageChanged,
          //non posso scrollare per cambiare pagina
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(5),
        height: context.read<SettingsProvider>().config.safeBlockVertical * 8,
        decoration: const BoxDecoration(
          color: MainColor.primaryColor,
          //border: Border(top: BorderSide(width: 2, color: MainColor.secondaryColor)),
        ),
        child: buildPalline(context),
      ),
    );
  }

//ritorna le pagine (una pagina per sezione), la prima pagina è quella dei tutorial !
  List<Widget> _buildPages() {
    final List<Sezione> sezioniForm = currentForm.sezioni;
    //creo una pagina per ogni sezione
    List<Widget> pages = List.generate(
      sezioniForm.length,
      (index) => const SezionePage(),
      growable: true,
    );
    //Se sto compilando aggiungo in testa sezione della descrizione
    if (compState == CompilazioneType.writing) {
      pages.insert(
        0,
        SezioneTutorial(
          text: currentForm.formDesc,
          formId: currentForm.formId,
          appBarTitle: currentForm.tutorialTitle,
        ),
      );
    }

    return pages;
  }

//palline in basso
//ogni pallina rappresenta una sezione !
  Widget buildPalline(BuildContext context) {
    List<Widget> palline = [];
    final int numSezioni = compState == CompilazioneType.reading ? 0 : 1;
    //per ogni sezione genero una pallina, + 1 per la sezione descrittiva
    for (int i = 0; i < currentForm.sezioni.length + numSezioni; i++) {
      palline.add(Pallina(isSelected: currentIndexPage == i));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //bottone indietro
        ElevatedButton(
          onPressed: () {
            backToPrevSection();
          },
          child: const Text("Indietro"),
        ),
        //* lista di palline, scorrono in orizzontale
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: palline,
            ),
          ),
        ),
        //bottone avanti
        ElevatedButton(
          onPressed: onAwayBtnPressed(),
          child: Text(getBtnText()),
        ),
      ],
    );
  }

  //? FUNZIONI

  String getBtnText() {
    //se mi trovo nell'ultima sezione, il bottone servirà o per inviare la compilazione, o per chiudere tutto
    final int index = compState == CompilazioneType.reading ? -1 : 0;
    if (currentIndexPage == currentForm.sezioni.length + index) {
      if (compState == CompilazioneType.reading) {
        return "Chiudi Form !";
      }
      return "Invia !";
    } else {
      //mi trovo in una sezione che non è l'ultima => vado avanti
      return "Avanti";
    }
  }

//bottone "Avanti" premuto
  VoidCallback? onAwayBtnPressed() => () async {
        //* se e' modalità reading => utente sta visualizzando Form Compilato !
        if (compState == CompilazioneType.reading) {
          if (currentIndexPage == currentForm.sezioni.length - 1) {
            //in questo caso ha premuto pulsante chiudi Form, torno alla Home
            Navigator.of(context).popUntil((route) => route.isFirst);
            return;
          }
          //vado avanti senza check
          goToNextSection();
          return;
        }
        //* SONO IN MODALITA' WRITING (CIOE' UTENTE STA COMPILANDO FORM!)
        if (currentIndexPage == 0) {
          //vado subito avanti perchè sto su tutorial page
          goToNextSection();
          return;
        }
        //* Utente vuole andare Avanti nella prossima Sezione
        if (currentIndexPage != currentForm.sezioni.length) {
          //check se tutte le domande obbligatorie sono state rispsote
          final canGoAway =
              context.read<CompilazioneFormProvider>().domandeCompilate();
          if (!canGoAway) {
            showSnackBar(context, "Errore: Alcune Domande sono Obbligatorie !",
                isError: true);
            return;
          }
          //se ha risposto a tutte le domande obbligatorie vado alla sezione successiva
          goToNextSection();
          return;
        }
        //*utente ha premuto invia Form
        if (currentIndexPage == currentForm.sezioni.length) {
          //check se è stato scelto assistito
          final assistito = context.read<CompilazioneFormProvider>().cliente;
          if (assistito == null) {
            showSnackBar(
                context, "Seleziona l'Assistito per cui Compilare il Form !",
                isError: true);
            return;
          }
          //check se tutte le domande sono correttamente compilate
          final canGoAway =
              context.read<CompilazioneFormProvider>().domandeCompilate();
          if (!canGoAway) {
            showSnackBar(context, "Errore: Alcune Domande sono Obbligatorie !",
                isError: true);
            return;
          }
          //!posso procedere alla compilazione del form
          try {
            await context.read<CompilazioneFormProvider>().compilaForm(
                  userId: context.read<UserProvider>().currentUser!.id,
                );

            showSnackBar(context, "Form Compilato con Successo !");

            //torno alla HomePage
            //Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.profiloUtente,
              (route) => false,
            );
            context.read<CompilazioneFormProvider>().resetForm();
          } catch (e) {
            print(e);
            showSnackBar(context, "Errore nel creare il Form !", isError: true);
          }
        }
      };

  //da usare sto metodo sotto per riciclare
  /* void checkDomande() {
    final canGoAway =
        context.read<CompilazioneFormProvider>().domandeCompilate();
    if (!canGoAway) {
      showSnackBar(context, "Errore: Alcune Domande sono Obbligatorie !");
      return;
    }
  }*/

  void goToNextSection() {
    final int index = compState == CompilazioneType.reading ? 0 : -1;
    _pageController.jumpToPage(currentIndexPage + 1);
    context.read<CompilazioneFormProvider>().updateCurrentSection(
          currentForm.sezioni[currentIndexPage + index],
        );
    animateScrollController(20.0);
  }

  void backToPrevSection() {
    if (currentIndexPage == 0) {
      Navigator.of(context).pop();
      return;
    }
    final int index = compState == CompilazioneType.reading ? 0 : -1;
    _pageController.jumpToPage(currentIndexPage - 1);
    if (compState == CompilazioneType.writing && currentIndexPage == 0) {
      //in questo caso NON aggiorno la sezione corrente, perchè torno su Sezione Tutorial
      animateScrollController(-20.0);
      return;
    }
    context.read<CompilazioneFormProvider>().updateCurrentSection(
          currentForm.sezioni[currentIndexPage + index],
        );
    animateScrollController(-20.0);
  }

  //cambio pagina, aggiorno index
  void onPageChanged(int newVal) => setState(() {
        currentIndexPage = newVal;
      });

//*animazione sullo scroll delle Palline !
  void animateScrollController(double index) {
    _scrollController.animateTo(
      index * currentIndexPage,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeIn,
    );
  }
}
