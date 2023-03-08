import 'package:flutter/material.dart';
import 'package:music/pages/PROVA_MACHFORM/provider/machform_provider.dart';
import 'package:provider/provider.dart';

import '../../../helpers.dart';
import '../../../models/machform_models/form_elements.dart';

//* Elemento date o europe_date => è del tipo 2022-09-14 => anno yyyy-mese 09-giorno 14

class DateElement extends StatelessWidget {
  final FormElements machFormElement;
  const DateElement({
    Key? key,
    required this.machFormElement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(machFormElement.elementTitle ?? 'Data'),
      Row(
        children: [
          Text(
            formatYear(
              context
                  .read<MachFormProvider>()
                  .formValues['element_${machFormElement.elementId}'],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 360)),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                context.read<MachFormProvider>().updateFormVal(
                      'element_${machFormElement.elementId}',
                      date,
                    );
                //   final TimeOfDay? hour = await showTimePicker(
                //       context: context, initialTime: TimeOfDay.now());
                //   if (hour != null) {
                //     context
                //         .read<CompilazioneFormProvider>()
                //         .compilazioneData = DateTime(
                //       date.year,
                //       date.month,
                //       date.day,
                //       hour.hour,
                //       hour.minute,
                //     );
                //     setState(() {});
                //   }
              }
            },
          ),
          //ora
        ],
      ),
    ]);
  }
}
