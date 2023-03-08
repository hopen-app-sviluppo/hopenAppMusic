import 'package:flutter/material.dart';
import 'package:music/pages/PROVA_MACHFORM/provider/machform_provider.dart';
import 'package:provider/provider.dart';
import '../../../models/machform_models/form_elements.dart';

//* Elemento date o europe_date => è del tipo 11:30:00 => ore hh-minuti mm-secondi 14

class TimeElement extends StatelessWidget {
  final FormElements machFormElement;
  const TimeElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(machFormElement.elementTitle ?? 'Orario'),
      Row(
        children: [
          //11:45
          Text(
            "${context.read<MachFormProvider>().formValues['element_${machFormElement.elementId}'].hour}:${context.read<MachFormProvider>().formValues['element_${machFormElement.elementId}'].minute}",
          ),

          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final TimeOfDay? hour = await showTimePicker(
                  context: context, initialTime: TimeOfDay.now());
              if (hour != null) {
                context.read<MachFormProvider>().updateFormVal(
                      'element_${machFormElement.elementId}',
                      TimeOfDay(hour: hour.hour, minute: hour.minute),
                    );
              }
            },
          ),
          //ora
        ],
      ),
    ]);
  }
}
