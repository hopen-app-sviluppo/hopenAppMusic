import 'package:flutter/material.dart';
import 'package:music/models/machform_models/form_elements.dart';

class SectionElement extends StatelessWidget {
  final FormElements machFormElement;
  const SectionElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  //Elemento di tipo section => mostro testo come se fosse un titolo

  @override
  Widget build(BuildContext context) {
    return Text(
      machFormElement.elementTitle ?? "Sezione ${machFormElement.elementId}",
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
