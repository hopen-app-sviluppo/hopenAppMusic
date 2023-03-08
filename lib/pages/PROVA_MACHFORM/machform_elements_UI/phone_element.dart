import 'package:flutter/material.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/common_widget/machform_form_field.dart';
import 'package:provider/provider.dart';

import '../../../models/machform_models/form_elements.dart';
import '../../../theme.dart';
import '../provider/machform_provider.dart';

//* Elemento del machform di tipo Phone => casella di testo in cui inserire numero di telefono
//* PERCHE SUL DB DI MACHFORM è DI TIPO DOUBLE ????
class PhoneElement extends StatelessWidget {
  final FormElements machFormElement;
  const PhoneElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(machFormElement.elementTitle ?? "Telefono"),
        MachformFormField(
          columnName: 'element_${machFormElement.elementId}',
        )
      ],
    );
  }
}
