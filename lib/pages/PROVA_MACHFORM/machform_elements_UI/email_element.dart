import 'package:flutter/material.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/common_widget/machform_form_field.dart';
import '../../../models/machform_models/form_elements.dart';

//* Elemento del machform email => un titolo e un campo di testo in cui scrivere email
class EmailElement extends StatelessWidget {
  final FormElements machFormElement;
  const EmailElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(machFormElement.elementTitle ?? "Email"),
        MachformFormField(columnName: 'element_${machFormElement.elementId}'),
      ],
    );
  }
}
