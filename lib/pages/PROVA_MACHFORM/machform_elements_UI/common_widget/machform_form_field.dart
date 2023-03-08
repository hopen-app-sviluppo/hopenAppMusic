import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../theme.dart';
import '../../provider/machform_provider.dart';

//* casella di testo del MachForm, la usano molti elementi
class MachformFormField extends StatelessWidget {
  final String columnName;
  final int maxLines;
  const MachformFormField(
      {Key? key, required this.columnName, this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print("vediamo column name: ${columnName}  e vediamo se è null: ${context.read<MachFormProvider>().formValues[columnName] == null}");
    return Card(
      child: TextField(
        readOnly: context.read<MachFormProvider>().compType ==
            CompilazioneType.reading,
        controller: context.read<MachFormProvider>().formValues[columnName],
        style: const TextStyle(
          color: MainColor.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        maxLines: maxLines,
        decoration: _buildDecoration(),
      ),
    );
  }

  InputDecoration _buildDecoration() => InputDecoration(
        border: InputBorder.none,
        fillColor: MainColor.primaryColor,
      );
}
