import 'package:flutter/material.dart';

import '../../../../constant.dart';
import '../../../common_widget/custom_rounded_card.dart';
import '../widgets/client_text_field.dart';
import '../widgets/custom_dropdown_btn.dart';
import '../widgets/residenza_domicilio.dart';

//* step 2 creazione assistito

class CreaResidenzaAssistito extends StatelessWidget {
  const CreaResidenzaAssistito({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(flex: 1, child: _buildComDiNascita(context)),
        Expanded(flex: 1, child: _buildProvinciaASL(context)),
        const Expanded(
          flex: 3,
          child: ResidenzaDomicilio(),
        ),
      ],
    );
  }

  Row _buildComDiNascita(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            flex: 3,
            child: RoundedCard(
              child: ClientTextField(
                labelText: "Comune di Nascita",
                maxLength: 15,
                prefixIcon: Icons.house,
                valToValidate: "comune_nascita",
              ),
            ),
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 3,
            child: RoundedCard(
              isRoundedOnDx: false,
              child: ClientTextField(
                labelText: "Nazione",
                maxLength: 15,
                prefixIcon: Icons.flag,
                valToValidate: "nazione",
              ),
            ),
          ),
        ],
      );

  Row _buildProvinciaASL(BuildContext context) => Row(
        children: const [
          Expanded(
            flex: 3,
            child: RoundedCard(
              child: CustomDropdownBtn(
                items: ASLdiAppartenenza,
                title: "ASL di Appartenenza",
                valToValidate: "asl",
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 3,
            child: RoundedCard(
              isRoundedOnDx: false,
              child: CustomDropdownBtn(
                items: provincia,
                title: "Provincia di Nascita",
                valToValidate: "prov_nascita",
              ),
            ),
          ),
        ],
      );
}
