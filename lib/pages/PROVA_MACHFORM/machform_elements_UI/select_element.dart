import 'package:flutter/material.dart';
import 'package:music/models/machform_models/form_element_options.dart';
import 'package:provider/provider.dart';

import '../../../models/machform_models/form_elements.dart';
import '../../../theme.dart';
import '../provider/machform_provider.dart';

//* Elemento del machform select => Un titolo sopra e un dropdown con vari punti da scegliere
class SelectElement extends StatelessWidget {
  final FormElements machFormElement;
  const SelectElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(machFormElement.elementTitle ?? "Drop Down"),
        Card(
          child: DropdownButton<int>(
            style: const TextStyle(color: MainColor.primaryColor),
            dropdownColor: Colors.white,
            underline: const SizedBox.shrink(),
            hint: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                getDropdownText(context),
                style: const TextStyle(
                  color: MainColor.primaryColor,
                ),
              ),
            ),
            selectedItemBuilder: (BuildContext context) {
              return machFormElement.formElementsOptions
                  .map<Widget>((FormElementsOptions opt) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    opt.option ?? "Opzione id ${opt.elementId}",
                    style: const TextStyle(
                      color: MainColor.primaryColor,
                    ),
                  ),
                );
              }).toList();
            },
            items: List.generate(
              machFormElement.formElementsOptions.length,
              (i) => DropdownMenuItem(
                value: machFormElement.formElementsOptions[i].position,
                child: Text(
                  machFormElement.formElementsOptions[i].option ??
                      'Opzione id ${machFormElement.formElementsOptions[i].optionId}',
                ),
              ),
            ),
            onChanged: (selectedVal) {
              //selectedVal è la posizione dell'elemento scelto
              context.read<MachFormProvider>().updateFormVal(
                    'element_${machFormElement.elementId}',
                    selectedVal ?? 0,
                  );
            },
            icon: Icon(
              Icons.arrow_drop_down,
              color: MainColor.primaryColor,
              size: Theme.of(context).iconTheme.size,
            ),
          ),
        ),
      ],
    );
  }

//cerco nel provider la posizione del valore selezionato, ottengo l'opzione con quella posizione e mostro il testo
  String getDropdownText(BuildContext context) {
    for (var option in machFormElement.formElementsOptions) {
      if (option.position ==
          context
              .read<MachFormProvider>()
              .formValues['element_${machFormElement.elementId}']) {
        return option.option ?? "";
      }
    }
    return "";
  }
}
