import 'package:flutter/material.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/common_widget/machform_form_field.dart';

import '../../../models/machform_models/form_elements.dart';

//* Elemento del machform di tipo url (la voce è Website) => casella di testo in cui inserire numero un link
class UrlElement extends StatelessWidget {
  final FormElements machFormElement;
  const UrlElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(machFormElement.elementTitle ?? "Web Site"),
        MachformFormField(columnName: 'element_${machFormElement.elementId}'),
      ],
    );
  }
}
