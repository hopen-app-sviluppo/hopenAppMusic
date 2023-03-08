import 'package:flutter/material.dart';

import '../../../../theme.dart';
import '../../../common_widget/custom_radiobtn.dart';
import '../helpers/enums.dart';

class StepRadioBtn extends StatelessWidget {
  final ClientCreationPhase creationPhase;
  const StepRadioBtn({
    Key? key,
    required this.creationPhase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> btns = [
      creationPhase == ClientCreationPhase.informazioniAssistito
          ? CustomRadioBtn(
              isStepChecked:
                  creationPhase == ClientCreationPhase.informazioniAssistito,
              text: "Anagrafica",
              number: "1",
            )
          : CustomRadioBtn(
              isStepChecked: creationPhase == ClientCreationPhase.residenza,
              text: "Residenza",
              number: "2",
            ),
      const Expanded(
        child: Divider(
          thickness: 2.0,
          color: MainColor.secondaryAccentColor,
        ),
      ),
      creationPhase == ClientCreationPhase.informazioniAssistito
          ? CustomRadioBtn(
              isStepChecked: creationPhase == ClientCreationPhase.residenza,
              text: "Residenza",
              number: "2",
              isBlueColor: false,
            )
          : CustomRadioBtn(
              isStepChecked:
                  creationPhase == ClientCreationPhase.informazioniDiContatto,
              text: "Contatti",
              number: "3",
              isBlueColor: false,
            ),
    ];
    return Row(
      children: btns,
    );
  }
}
