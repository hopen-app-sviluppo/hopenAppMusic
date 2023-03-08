import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/machform_models/form_elements.dart';
import '../../../theme.dart';
import '../provider/machform_provider.dart';

//* elemento matrix di un machform
//ogni riga della matrice è un elemento del form (sta in ap_form_elements)

// ogni riga (che è un elemento) ha tante opzioni quante sono le colonne.

//problema, se ho 2 matrici ??

//sul db ho element_id e valore (sarebbe la posizione data in quella riga)

//capisco che finisce una matrice quando vedo element_guidelines che ha un valore (vuol dire che ne inizia un'altra)

class MatrixElement extends StatelessWidget {
  final List<FormElements> matrixElements;
  const MatrixElement({
    required this.matrixElements,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: matrixElements
          .map(
            (elem) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: buildOptions(context, elem),
            ),
          )
          .toList(),
    );
  }

  List<Widget> buildOptions(BuildContext context, FormElements element) {
    print("ecco matrix elemet: ${matrixElements.length}");
    final values = context
        .read<MachFormProvider>()
        .formValues['element_${element.elementId}'];

    return element.formElementsOptions
        .map((option) => SizedBox(
              width: 70,
              height: 90,
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        (option.option ?? "element ${option.optionId}"),
                      ),
                    ),
                  ),
                  Radio(
                    value: option.position,
                    activeColor: MainColor.secondaryColor,
                    groupValue: values,
                    onChanged: (newVal) => context.read<MachFormProvider>()
                      ..updateFormVal('element_${element.elementId}', newVal),
                  ),
                ],
              ),
            ))
        .toList()
      ..insert(
          0,
          SizedBox(
            width: 70,
            child: Text(element.elementTitle ?? "Element ${element.elementId}"),
          ));
  }
}
