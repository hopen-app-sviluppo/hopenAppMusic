import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/models/form_assistito.dart';
import 'package:music/models/form_domanda_enum.dart';
import 'package:music/helpers.dart';
import 'package:music/pages/forms_pages/compilazione_form_page/helpers/compilazione_form_provider.dart';
import 'package:provider/provider.dart';
import '../../../../theme.dart';
import '../helpers/compilazione_type.dart';
import 'radio_btns.dart';

//Grafica di una domanda

//5 tipi diversi di domanda: se è testuale, label, checkbox, data, score
class DomandaBox extends StatefulWidget {
  final Domanda domanda;
  const DomandaBox({
    Key? key,
    required this.domanda,
  }) : super(key: key);

  @override
  State<DomandaBox> createState() => _DomandaBoxState();
}

class _DomandaBoxState extends State<DomandaBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.08,
          right: widget.domanda.isObbligatoria
              ? 0
              : MediaQuery.of(context).size.width * 0.08),
      child: !widget.domanda.isObbligatoria
          ? _buildDomandaBox()
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDomandaBox(),
                ),
                if (widget.domanda.isObbligatoria)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.08,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () => showDomandaObbligatoria(context),
                        child: const Icon(
                          Icons.emergency,
                          color: MainColor.secondaryColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildDomandaBox() => Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: MainColor.primaryColor,
          border: Border.all(width: 4, color: MainColor.secondaryColor),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: [
            ..._buildDomandaTitle(),
            currentBox(context),
          ],
        ),
      );

  List<Widget> _buildDomandaTitle() {
    if (widget.domanda.domandaTitle == null) {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
          child: Text(
            widget.domanda.domandaDesc,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ];
    }
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 5.0),
        child: Text(
          widget.domanda.domandaTitle!,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const Divider(
        color: MainColor.secondaryColor,
        thickness: 2,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          widget.domanda.domandaDesc,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ];
  }

  Widget currentBox(BuildContext context) {
    //todo riciclare queste funzioni (cambia solo UI)
    switch (widget.domanda.domandaType) {
      case FormDomandaType.label:
        return labelBox(context);
      case FormDomandaType.checkValue:
        return checkBox();
      case FormDomandaType.text:
        return textBox();
      case FormDomandaType.score:
        return RadioBtns(domandaId: widget.domanda.domandaId);
      case FormDomandaType.data:
        return dataBox();
    }
  }

  Future<void> showDomandaObbligatoria(BuildContext context) async =>
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: MainColor.primaryColor,
                title: const Text(
                  "La domanda è obbligatoria !",
                  style: TextStyle(color: Colors.white),
                ),
                actions: [
                  TextButton(
                    child: const Text("Chiudi"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));

//domanda di tipo label
  Widget labelBox(BuildContext context) {
    return Column(
      children: List.generate(widget.domanda.labels!.length, (i) {
        return Row(children: [
          Theme(
            data: Theme.of(context).copyWith(
              // unselectedWidgetColor: MainColor.primaryColor,
              unselectedWidgetColor: Colors.white,
            ),
            child: Radio<int?>(
              value: i,
              activeColor: MainColor.secondaryColor,
              groupValue: int.tryParse(widget.domanda.response ?? ""),
              onChanged: (newVal) {
                if (context.read<CompilazioneFormProvider>().compType ==
                    CompilazioneType.reading) {
                  return;
                }
                setState(() {
                  widget.domanda.response = newVal.toString();
                });
                context.read<CompilazioneFormProvider>().setDomandaResponse(
                    newVal.toString(), widget.domanda.domandaId);
              },
            ),
          ),
          Text(widget.domanda.labels![i]),
        ]);
      }),
    );
  }

//domanda di tipo text
  Widget textBox() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      color: Colors.white,
      child: context.read<CompilazioneFormProvider>().compType ==
              CompilazioneType.reading
          ? Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                widget.domanda.response ?? "",
                style: const TextStyle(color: MainColor.primaryColor),
              ),
            )
          : TextField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              maxLines: 5,
              style: const TextStyle(
                  color: MainColor.primaryColor, fontWeight: FontWeight.bold),
              onChanged: (newVal) {
                widget.domanda.response = newVal;
                context.read<CompilazioneFormProvider>().setDomandaResponse(
                    newVal.toString(), widget.domanda.domandaId);
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.edit_outlined,
                  color: MainColor.primaryColor,
                ),
                border: InputBorder.none,
              ),
            ),
    );
  }

//Domanda di tipo Data (utente deve inserire la data !)
  Widget dataBox() {
    return Row(
      children: [
        Text(context.read<CompilazioneFormProvider>().compilazioneData == null
            ? formatHour(DateTime.now())
            : formatHour(
                context.read<CompilazioneFormProvider>().compilazioneData!)),
        //data
        IconButton(
          icon: const Icon(Icons.date_range),
          onPressed: context.read<CompilazioneFormProvider>().compType ==
                  CompilazioneType.reading
              ? null
              : () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 360)),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    final TimeOfDay? hour = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (hour != null) {
                      context
                          .read<CompilazioneFormProvider>()
                          .compilazioneData = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        hour.hour,
                        hour.minute,
                      );
                      setState(() {});
                    }
                  }
                },
        ),
        //ora
      ],
    );
  }

  Widget checkBox() {
    final isListNotNull = widget.domanda.responseCheckBox != null;
    return Column(
      children: List.generate(widget.domanda.checkValues!.length, (i) {
        return Row(
          children: [
            Checkbox(
                value: isListNotNull &&
                    widget.domanda.responseCheckBox!.contains(
                      i.toString(),
                    ),
                onChanged: (newVal) {
                  if (context.read<CompilazioneFormProvider>().compType ==
                      CompilazioneType.reading) {
                    return;
                  }
                  if (newVal == null) return;

                  if (newVal) {
                    if (widget.domanda.responseCheckBox == null) {
                      widget.domanda.responseCheckBox = {i.toString()};
                    } else {
                      widget.domanda.responseCheckBox!.add(i.toString());
                    }
                  } else {
                    widget.domanda.responseCheckBox?.remove(i.toString());
                  }
                  context
                      .read<CompilazioneFormProvider>()
                      .setDomandaCheckBoxResponse(
                          widget.domanda.responseCheckBox!,
                          widget.domanda.domandaId);
                  setState(() {});
                }),
            Expanded(
              child: Text(
                widget.domanda.checkValues![i],
                softWrap: true,
                maxLines: 5,
              ),
            ),
          ],
        );
      }),
    );
  }
}
