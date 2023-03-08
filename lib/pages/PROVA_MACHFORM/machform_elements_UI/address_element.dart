import 'package:flutter/material.dart';
import 'package:music/pages/PROVA_MACHFORM/machform_elements_UI/common_widget/machform_form_field.dart';
import 'package:provider/provider.dart';

import '../../../models/machform_models/form_elements.dart';
import '../provider/machform_provider.dart';

//* elemento address nel sistema machform => sono 6 textfield
//element_id_1 è street address
//element_id_2 è address line 2
//element_id_3 è city
//element_id_4 è stato - provincia - regione
//element_id_5 è postal code - zip
//element_id_6 è country

class AddressElement extends StatelessWidget {
  final FormElements machFormElement;
  const AddressElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Address", style: TextStyle(fontWeight: FontWeight.bold)),
        Text("Street Address"),
        MachformFormField(columnName: 'element_${machFormElement.elementId}_1'),
        Text("Address line 2"),
        MachformFormField(columnName: 'element_${machFormElement.elementId}_2'),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text("City"),
                  MachformFormField(
                      columnName: 'element_${machFormElement.elementId}_3'),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text("State"),
                  MachformFormField(
                      columnName: 'element_${machFormElement.elementId}_4'),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text("Postal code"),
                  MachformFormField(
                      columnName: 'element_${machFormElement.elementId}_5'),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text("Country"),
                  MachformFormField(
                      columnName: 'element_${machFormElement.elementId}_6')
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
