import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/models/form_assistito.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';

import '../helpers/compilazione_form_provider.dart';
import '../helpers/compilazione_type.dart';

//ogni domanda deve essere risposta dal terapista attribuendo un putneggio
class RadioBtns extends StatefulWidget {
  final int domandaId;
  const RadioBtns({
    Key? key,
    required this.domandaId,
  }) : super(key: key);

  @override
  State<RadioBtns> createState() => _RadioBtnsState();
}

class _RadioBtnsState extends State<RadioBtns> {
  late Domanda domanda;

  @override
  void initState() {
    super.initState();
    domanda = context
        .read<CompilazioneFormProvider>()
        .getDomandaById(widget.domandaId);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _buildRadioBtns(),
    );
  }

  List<Widget> _buildRadioBtns() {
    List<Widget> tiles = [];
    for (int i = 0; i < domanda.punteggioMax!; i++) {
      tiles.add(
        Column(children: [
          Theme(
            data: Theme.of(context).copyWith(
              // unselectedWidgetColor: MainColor.primaryColor,
              unselectedWidgetColor: Colors.white,
            ),
            child: Transform.scale(
              scale: Platform.isIOS || Platform.isAndroid
                  ? MediaQuery.of(context).size.width * 0.002
                  : MediaQuery.of(context).size.width * 0.001,
              child: Radio(
                value: i + 1,
                activeColor: MainColor.secondaryColor,
                groupValue: int.tryParse(domanda.response ?? ""),
                onChanged: (newVal) {
                  // se è in sola lettura (sto leggendo una compilazione) non posso modificarla
                  if (context.read<CompilazioneFormProvider>().compType ==
                      CompilazioneType.reading) {
                    return;
                  }
                  context.read<CompilazioneFormProvider>().setDomandaScore(
                        newVal as int,
                        domanda.domandaId,
                      );
                  setState(() {
                    domanda.response = newVal.toString();
                  });
                  //aggiorno lo score della domanda
                  // widget.domandaCorrente.score = newVal as int;
                },
              ),
            ),
          ),
          Text("${i + 1}"),
        ]),
      );
    }
    return tiles;
  }
}
