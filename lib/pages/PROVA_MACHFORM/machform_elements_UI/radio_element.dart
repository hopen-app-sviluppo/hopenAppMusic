import 'package:flutter/material.dart';
import 'package:music/models/machform_models/form_element_options.dart';
import 'package:music/pages/PROVA_MACHFORM/provider/machform_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/machform_models/form_elements.dart';
import '../../../theme.dart';

class RadioElement extends StatelessWidget {
  final FormElements machFormElement;
  const RadioElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  //* elemento di tipo radio, quindi devi gestire le sue opzioni

  //se choice column == 1, ho ogni radio su 1 riga => quindi solo 1 colonna

  //se choice column == 2 => ho 2 colonne in riga

  //quando compilo form =>
  //  1) creo una tabella con con nome ap_form_idForm
  //  2) inserisco: id (della compilazione), date_created, date_updated, id_operatore, id_assistito, e poi gli elementi

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //* titolo dell'elemento
        Text(machFormElement.elementTitle ?? ""),

        //* content
        content(context),
      ],
    );
  }

  Widget content(BuildContext context) {
    switch (machFormElement.elementChoiceColumns) {
      case 1: //1 colonna
        return buildOneColumn(context, machFormElement.formElementsOptions);
      default:
        return buildInline(context);
      //! il problema è che 2 o 3 colonne non c'entrano sul telefono -.-
      // case 2: //2 colonne
      //   return buildMultipleColumn(context, 2);
      // case 3: // 3 colonne
      //   return buildMultipleColumn(context, 3);
      // case 9: // inline
      //   return buildInline(context);
      // default: //1 colonna
      //   return buildOneColumn(context, machFormElement.formElementsOptions);
    }
  }

  Widget buildOneColumn(
    BuildContext context,
    List<FormElementsOptions> elementOptions,
  ) =>
      Column(
        children: radioBtns(context, elementOptions),
      );

  Widget buildInline(BuildContext context) => Wrap(
        children: radioBtns(context, machFormElement.formElementsOptions),
      );

  // in pratica mi salvo la posizione selezionata, e  nel DB sarò uja cosa del tipo: element_3 il nome della colonna, come valore ha la posizione

  List<Widget> radioBtns(
      BuildContext context, List<FormElementsOptions> elementOptions) {
    //formValue = { 'element_4':2 }, element_4 è la colonna relativa all'elemento con id 4, 2 è la posizione selezionata, che equivarrà al valore in posizione 2 :D
    final values = context
        .read<MachFormProvider>()
        .formValues['element_${machFormElement.elementId}'];
    final radios = List.generate(
      elementOptions.length,
      (i) => Row(
        children: [
          radio(context, elementOptions[i], values),
          Flexible(child: Text(elementOptions[i].option ?? "Element $i")),
        ],
      ),
    );
    //se ha la voce altro:
    if (machFormElement.elementChoiceHasOther) {
      return [
        ...radios,
        radioElementOther(context),
      ];
    }
    return radios;
  }

  Widget radio(
    BuildContext context,
    FormElementsOptions option,
    dynamic values,
  ) =>
      Radio(
        value: option.position,
        activeColor: MainColor.secondaryColor,
        groupValue: values,
        onChanged: (newVal) => context.read<MachFormProvider>()
          ..updateFormVal('element_${machFormElement.elementId}', newVal)
          ..updateTextController(
            'element_${machFormElement.elementId}_other',
            null,
          ),
      );

//Quando viene inserito elemento ALTRO nel radio
  Widget radioElementOther(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Checkbox(
                activeColor: MainColor.secondaryColor,
                shape: const CircleBorder(),
                value: isOtherFieldChecked(context),
                onChanged: (newVal) {
                  //se seleziono questo: annullo gli altri valori
                  context.read<MachFormProvider>()
                    ..updateFormVal(
                      'element_${machFormElement.elementId}',
                      0,
                    )
                    ..updateTextController(
                      'element_${machFormElement.elementId}_other',
                      //testo che vado a scrive nel textfield
                      " ",
                    );
                },
              ),
            ),
            Expanded(
              flex: 8,
              child: Text(
                machFormElement.elementChoiceOtherLabel ?? "ALTRO:",
              ),
            ),
          ],
        ),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox.shrink(),
            ),
            Expanded(
              flex: 8,
              child: Container(
                height: kToolbarHeight * 0.8,
                color: Colors.white,
                child: TextField(
                  enabled: isOtherFieldChecked(context) &&
                      context.read<MachFormProvider>().compType ==
                          CompilazioneType.writing,
                  controller: context
                      .read<MachFormProvider>()
                      .formValues['element_${machFormElement.elementId}_other'],
                  style: const TextStyle(
                    color: MainColor.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: _buildDecoration(),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

//se il radio ALTRO è stato selezionato => in questo caso uente può scrivere nel textField
  bool isOtherFieldChecked(BuildContext context) =>
      context
          .read<MachFormProvider>()
          .formValues['element_${machFormElement.elementId}_other']
          ?.text !=
      "";

  InputDecoration _buildDecoration() => const InputDecoration(
        border: InputBorder.none,
        fillColor: MainColor.primaryColor,
      );
}


//! logica per creare radio in diverse colonne (ma sul telefono non ce ne entrano 2 o 3)
 //columnNumbers sarebbe n => cioè il numero di righe che voglio
  // Widget buildMultipleColumn(BuildContext context, int columnNumbers) {
  //   //* STEP 1 => DIVIDO LA LISTA IN N PARTI UGUALI
  //   int count = 0;
  //   List<List<FormElementsOptions>> elements = [];
  //   for (int i = 0; i < columnNumbers; i++) {
  //     int j = count +
  //         (machFormElement.formElementsOptions.length / columnNumbers).ceil();
  //     elements.add(
  //       machFormElement.formElementsOptions.sublist(
  //           count,
  //           j > machFormElement.formElementsOptions.length
  //               ? machFormElement.formElementsOptions.length
  //               : j),
  //     );
  //     count +=
  //         (machFormElement.formElementsOptions.length / columnNumbers).ceil();
  //   }
//
  //   //* STEP 2 => PER OGNI RIGA RITORNO UNA COLONNA CON QUEL NUMERO DI ELEMENTI
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: elements.map((e) => buildOneColumn(context, e)).toList(),
  //   );
  // }
