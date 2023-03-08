import 'package:flutter/material.dart';
import 'package:music/models/machform_models/form_elements.dart';
import 'package:music/pages/PROVA_MACHFORM/provider/machform_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/machform_models/form_element_options.dart';

class CheckboxElement extends StatelessWidget {
  final FormElements machFormElement;
  const CheckboxElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  //Elemento di tipo section => mostro testo come se fosse un titolo

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
    }
  }

  Widget buildOneColumn(
    BuildContext context,
    List<FormElementsOptions> elementOptions,
  ) =>
      Column(
        children: checkBoxes(context, elementOptions),
      );

  Widget buildInline(BuildContext context) => Wrap(
        children: checkBoxes(context, machFormElement.formElementsOptions),
      );

  List<Widget> checkBoxes(
    BuildContext context,
    List<FormElementsOptions> elementOptions,
  ) {
    //per i checkbox aggiungo un valore per ogni checkbox, se è selezionata il valore prende 1, altrimenti 0
    //checbox es: => element_6_1:true o false => quando metto nel DB convertire a 0 - 1
    return List.generate(
        elementOptions.length,
        (i) => Row(
              children: [
                Checkbox(
                  value: context
                      .read<MachFormProvider>()
                      .formValues[checkBoxColumnName(elementOptions[i])],
                  onChanged: (val) => context
                      .read<MachFormProvider>()
                      .updateFormVal(
                        checkBoxColumnName(elementOptions[i]),
                        !context
                            .read<MachFormProvider>()
                            .formValues[checkBoxColumnName(elementOptions[i])],
                      ),
                ),
                Flexible(
                  child: Text(
                      elementOptions[i].option ??
                          'Elemento ${elementOptions[i].elementId}',
                      maxLines: 3),
                ),
              ],
            ));
  }

  String checkBoxColumnName(FormElementsOptions opt) =>
      'element_${machFormElement.elementId}_${opt.position}';
}
