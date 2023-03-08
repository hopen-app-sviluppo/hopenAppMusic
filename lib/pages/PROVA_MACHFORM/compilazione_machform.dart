import 'package:flutter/material.dart';
import 'package:music/helpers.dart';
import 'package:music/models/machform_models/form_element_type.dart';
import 'package:music/models/machform_models/form_elements.dart';
import 'package:music/models/machform_models/machform.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/address_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/date_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/email_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/matrix_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/number_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/phone_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/radio_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/section_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/select_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/simple_name_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/single_line_text_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/textarea_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/time_element.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/url_element.dart';
import 'package:music/pages/PROVA_MACHFORM/provider/machform_provider.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

import '../../models/cliente.dart';
import '../../provider/user_provider.dart';
import '../../router.dart';
import '../common_widget/empty_page.dart';
import '../common_widget/error_page.dart';
import '../common_widget/list_item.dart';
import 'machform_elements_UI/checkbox_element.dart';

class CompilazioneMachForm extends StatefulWidget {
  late final ScrollListener _model;
  final double _bottomNavBarHeight;
  final ScrollController _controller;
  final MachForm machForm;

  CompilazioneMachForm({
    Key? key,
    required this.machForm,
  })  : _controller = ScrollController(),
        _bottomNavBarHeight = kToolbarHeight,
        super(key: key) {
    _model = ScrollListener.initialise(_controller);
  }

  @override
  State<CompilazioneMachForm> createState() => _CompilazioneMachFormState();
}

class _CompilazioneMachFormState extends State<CompilazioneMachForm> {
  @override
  void dispose() {
    widget._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => checkFocus(context),
        child: Scrollbar(
          thumbVisibility: true,
          controller: widget._controller,
          child: AnimatedBuilder(
              animation: widget._model,
              builder: (context, child) {
                return Consumer<MachFormProvider>(builder: (ctx, formProv, _) {
                  return Stack(
                    children: [
                      //* APPBAR e BODY
                      Positioned(
                        right: 0.0,
                        left: 0.0,
                        top: widget._model.bottom,
                        bottom: kToolbarHeight,
                        child: Column(
                          children: [
                            //* APPBAR
                            _buildAppBar(context),
                            const SizedBox(height: 10),
                            //se ci sono elementi del tipo page break => grafica cambia drasticamente
                            if (widget
                                .machForm.pageBreakformElements.isNotEmpty) ...[
                              pageBreakUI(context, formProv.pageSelected),
                              const SizedBox(height: 10),
                            ],
                            //* BODY
                            Expanded(child: _buildBody(context, formProv)),
                          ],
                        ),
                      ),
                      //* bottom navigation bar
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: widget._model.bottom,
                        child: _bottomNavBar(context),
                      ),
                    ],
                  );
                });
              }),
        ),
      ),
    );
  }

//* tutti calcoli per colorare la safe area di verde, e far sparire app bar quando scrollo in basso
  Widget _buildAppBar(BuildContext context) => Container(
        height: widget._bottomNavBarHeight + MediaQuery.of(context).padding.top,
        width: double.infinity,
        padding: widget._model.bottom == 0.0
            ? EdgeInsets.only(top: MediaQuery.of(context).padding.top)
            : null,
        color: MainColor.secondaryColor,
        child: widget._model.bottom == 0.0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(widget.machForm.formName ?? ""),
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 2, color: MainColor.primaryColor),
                        borderRadius: BorderRadius.circular(25.0)),
                    child: TextButton.icon(
                      label: Text(
                        context.read<MachFormProvider>().currentClient == null
                            ? "Seleziona Assistito"
                            : "${context.read<MachFormProvider>().currentClient!.nome} ${context.read<MachFormProvider>().currentClient!.cognome}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      icon: Icon(context.read<MachFormProvider>().compType ==
                              CompilazioneType.reading
                          ? Icons.people
                          : Icons.edit_outlined),
                      onPressed: () async {
                        if (context.read<MachFormProvider>().compType ==
                            CompilazioneType.reading) {
                          return;
                        }
                        await chooseAssistito(context);
                      },
                    ),
                  ),
                ],
              )
            : null,
      );

  Future<void> chooseAssistito(BuildContext context) async {
    Cliente? selectedCliente;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: MainColor.primaryColor.withOpacity(0.9),
        title: const Text("Scegli Assistito "),
        elevation: 10.0,
        content: SizedBox(
          width: 300,
          height: 500,
          child: FutureBuilder(
              future: context.read<UserProvider>().getClients(),
              builder: (cont, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snap.hasError) {
                  final String error = snap.error.toString();
                  return ErrorPage(error: error);
                }

                final List<Cliente> clients = snap.data as List<Cliente>;
                if (clients.isEmpty) {
                  return EmptyPage(
                    title: "Non hai Assistiti !",
                    btnText: "Creane uno !",
                    onBtnPressed: () =>
                        Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRouter.creaAssistito,
                      (route) => route.isFirst,
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (ctx, index) {
                      final currentClient = clients[index];
                      return ListItem(
                          height: MediaQuery.of(context).size.height * 0.08,
                          title:
                              "${currentClient.nome} ${currentClient.cognome}",
                          leadingIcon: Icon(
                            currentClient.sesso == "maschio"
                                ? Icons.man_outlined
                                : currentClient.sesso == "femmina"
                                    ? Icons.woman_outlined
                                    : Icons.person,
                          ),
                          onTap: () {
                            context
                                .read<MachFormProvider>()
                                .updateClient(currentClient);
                            Navigator.of(ctx).pop(selectedCliente);
                          });
                    });
              }),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MachFormProvider formProv) {
    //* prendo elementi di quella pagina, e non i pageBreak
    List<FormElements> currentElements = widget.machForm.formElements
        .where((element) =>
            element.elementPageNumber == formProv.pageSelected &&
            element.elementType != FormElementType.page_break)
        .toList();
    return ListView.builder(
      controller: widget._controller,
      itemCount: currentElements.length,
      itemBuilder: (_, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: buildMachFormElement(currentElements[i])),
    );
  }

  Widget _bottomNavBar(BuildContext context) => Container(
        height: widget._bottomNavBarHeight,
        width: double.infinity,
        color: MainColor.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //se non ho page break sto pulsante non serve
            if (context.read<MachFormProvider>().pageBreakExists)
              ElevatedButton(
                onPressed: () {
                  if (context.read<MachFormProvider>().pageSelected == 1) {
                    return;
                  }
                  //per salvare tutti i valori dei textfield !
                  //! se c'è un qualche tipo di controllo da fare (tipo se campo obbligatorio), inserire
                  //! formKey.currentState?.validate();
                },
                child: Text("Previous"),
              ),
            ElevatedButton(
              onPressed: () async {
                try {
                  //se non sono all'ultima pagina ed esistono dei page break allora vado avanti
                  if (context.read<MachFormProvider>().pageBreakExists &&
                      context.read<MachFormProvider>().pageSelected <
                          widget.machForm.pageBreakformElements.length) {
                    context.read<MachFormProvider>().goToNextPage();
                    return;
                  }
                  //* se utente sta leggendo una compilazione, allora non può compilare !
                  if (context.read<MachFormProvider>().compType ==
                      CompilazioneType.reading) {
                    Navigator.of(context).pop();
                    return;
                  }
                  //altrimenti compilo il Form !
                  //formKey.currentState?.save();
                  await context.read<MachFormProvider>().compilaForm(context);
                  showSnackBar(context, "Compilazione Eseguita !");
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } catch (e) {
                  print("ERROREEEE: $e");
                  showSnackBar(
                    context,
                    e.toString(),
                    isError: true,
                  );
                }
              },
              child: Text(getButtonText(context)),
            ),
          ],
        ),
      );

  String getButtonText(BuildContext ctx) {
    final bool isReadingComp =
        ctx.read<MachFormProvider>().compType == CompilazioneType.reading;

    //se esistono pagebreak allora devo vedere la lunghezza degli elementi

    //se non esistono allora vedo se è una compilazione

    if (ctx.read<MachFormProvider>().pageBreakExists) {
      //se sono all'ultima pagina
      if (context.read<MachFormProvider>().pageSelected ==
          widget.machForm.pageBreakformElements.length) {
        if (isReadingComp) {
          return "Chiudi";
        } else {
          return "Compila !";
        }
      } else {
        return "Continua";
      }
    } else {
      //non esistono pageBreak
      if (isReadingComp) {
        return "Chiudi";
      } else {
        return "Compila !";
      }
    }
  }

//Quadratini in alto che indicano la pagina corrente (appare solo se esistono dei page break)
  Widget pageBreakUI(BuildContext context, int selectedPage) => Container(
        height: kToolbarHeight,
        color: MainColor.primaryColor,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.machForm.pageBreakformElements.length,
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ActionChip(
                        label: Text("${i + 1}"),
                        backgroundColor: selectedPage == (i + 1)
                            ? MainColor.secondaryColor
                            : Colors.grey,
                        onPressed: () => context
                            .read<MachFormProvider>()
                            .onPageSelected(pageIndex: i + 1),
                      ),
                    ),
                    Text(
                      widget.machForm.pageBreakformElements[i].elementTitle ??
                          widget.machForm.pageBreakformElements[i]
                              .elementPageTitle ??
                          "Page Break",
                    )
                  ],
                ),
              );
            }),
      );

  //* OGNI ELEMENTO HA UNA PAGINA DEDICATA IN UI

  Widget buildMachFormElement(FormElements machFormElement) {
    switch (machFormElement.elementType) {
      case FormElementType.text:
        return SingleLineTextElement(machFormElement: machFormElement);

      case FormElementType.number:
        return NumberElement(machFormElement: machFormElement);

      case FormElementType.textarea:
        return TextareaElement(machFormElement: machFormElement);

      case FormElementType.checkbox:
        return CheckboxElement(machFormElement: machFormElement);

      case FormElementType.radio:
        return RadioElement(machFormElement: machFormElement);

      case FormElementType.select:
        return SelectElement(machFormElement: machFormElement);

      case FormElementType.simple_name:
        return SimpleNameElement(machFormElement: machFormElement);

      case FormElementType.date:
        return DateElement(machFormElement: machFormElement);

      case FormElementType.time:
        return TimeElement(machFormElement: machFormElement);

      case FormElementType.phone:
        return PhoneElement(machFormElement: machFormElement);

      case FormElementType.address:
        return AddressElement(machFormElement: machFormElement);

      case FormElementType.url:
        return UrlElement(machFormElement: machFormElement);

      case FormElementType.money:
        return Container();

      case FormElementType.email:
        return EmailElement(machFormElement: machFormElement);

      case FormElementType.matrix:
        {
          //creo nuova matrice quando l'elemento è di tipo matrix e ha dei constraints (se non li ha vuol dire che è solo un elemento della matrice)
          if (machFormElement.elementConstraint != "") {
            return MatrixElement(
              matrixElements: widget.machForm
                  .matrixElements['matrix_${machFormElement.elementId}']!,
            );
          }
          return const SizedBox.shrink();
        }

      case FormElementType.file:
        return Container();

      case FormElementType.section:
        return SectionElement(machFormElement: machFormElement);

      case FormElementType.page_break:
        //* qua non mi interessa
        return Container();

      case FormElementType.signature:
        return Container();

      case FormElementType.media:
        return Container();

      case FormElementType.europe_date:
        return DateElement(machFormElement: machFormElement);
    }
  }
}

//Lo uso per far scrollare la bottom navigation Bar e l'AppBar
class ScrollListener extends ChangeNotifier {
  double bottom = 0;
  double _last = 0;

  ScrollListener.initialise(ScrollController controller,
      [double height = kToolbarHeight]) {
    controller.addListener(() {
      final current = controller.offset;
      bottom += _last - current;
      if (bottom <= -height) bottom = -height;
      if (bottom >= 0) bottom = 0;
      _last = current;
      if (bottom <= 0 && bottom >= -height) notifyListeners();
    });
  }
}



//TODO: SETTIMANA DA MARTEDI' 28 A VENERDI' 3 MARZO => SE SCARICO UN FORM DAL NETWORK CON UN ID CHE HO GIA' NEL DATABASE, PROBABILMENTE DEVO FARE UN UPDATE PERCHE' E' UNA SUA MODIFICA

//MAGARI APPARE: FORM GIA' PRESENTE, SICURO DI VOLERLO SOSTITUIRE ?

//FINIRE ELEMENTI, VEDERE COMPILAZIONE, MOSTRARE RISULTATI

//CREO FORM MUSICOTERAPIA

//GRAFICA FATTA BENE