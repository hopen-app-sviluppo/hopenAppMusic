import 'package:flutter/material.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/common_widget/machform_form_field.dart';

import '../../../models/machform_models/form_elements.dart';

//* textarea nel machform è un elemento in cui viene inserito, potenzialmente, molto testo
class TextareaElement extends StatelessWidget {
  final FormElements machFormElement;
  const TextareaElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Column(
        children: [
          Flexible(
            child: Text(machFormElement.elementTitle ?? 'Area di testo'),
          ),
          Expanded(
            child: MachformFormField(
              columnName: 'element_${machFormElement.elementId}',
              maxLines: 10,
            ),
          ),
        ],
      ),
    );
  }
}
