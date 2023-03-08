import 'package:flutter/material.dart';
import 'package:music/models/machform_models/form_elements.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/common_widget/machform_form_field.dart';

//* elemento del machform di tipo simple_name => nel DB viene salvato come element_elementId_1 è il nome, element_elementId_2 è il cognome
class SimpleNameElement extends StatelessWidget {
  final FormElements machFormElement;
  const SimpleNameElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(machFormElement.elementTitle ?? "Nome e Cognome"),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: MachformFormField(
                columnName: 'element_${machFormElement.elementId}_1',
              ),
            ),
            Spacer(),
            Expanded(
              flex: 2,
              child: MachformFormField(
                columnName: 'element_${machFormElement.elementId}_2',
              ),
            ),
          ],
        )
      ],
    );
  }
}
