import 'package:flutter/material.dart';

import '../../../common_widget/custom_rounded_card.dart';
import '../widgets/client_text_field.dart';

//* step 3 (ultimo step) creazione assistito
class CreaContattiAssistito extends StatelessWidget {
  const CreaContattiAssistito({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTelefono1_2(context),
        _buildTelefono3_4(context),
        _buildEmailPec(context),
      ],
    );
  }

  _buildTelefono1_2(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            flex: 4,
            child: RoundedCard(
              child: ClientTextField(
                labelText: "Numero di Telefono",
                maxLength: 10,
                prefixIcon: Icons.local_phone,
                textInputType: TextInputType.phone,
                valToValidate: "tel",
              ),
            ),
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 3,
            child: RoundedCard(
              isRoundedOnDx: false,
              child: ClientTextField(
                labelText: "Numero di Telefono 2",
                maxLength: 10,
                prefixIcon: Icons.local_phone,
                textInputType: TextInputType.phone,
                valToValidate: "2tel",
              ),
            ),
          ),
        ],
      );
  _buildTelefono3_4(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            flex: 4,
            child: RoundedCard(
              child: ClientTextField(
                labelText: "Numero di Telefono 3",
                maxLength: 10,
                prefixIcon: Icons.local_phone,
                textInputType: TextInputType.phone,
                valToValidate: "3tel",
              ),
            ),
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 3,
            child: RoundedCard(
              isRoundedOnDx: false,
              child: ClientTextField(
                labelText: "Numero di Telefono 4",
                maxLength: 10,
                prefixIcon: Icons.local_phone,
                textInputType: TextInputType.phone,
                valToValidate: "4tel",
              ),
            ),
          ),
        ],
      );

  _buildEmailPec(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            flex: 4,
            child: RoundedCard(
              child: ClientTextField(
                labelText: "Indirizzo Email",
                maxLength: 20,
                prefixIcon: Icons.local_phone,
                textInputType: TextInputType.emailAddress,
                valToValidate: "email",
              ),
            ),
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 3,
            child: RoundedCard(
              isRoundedOnDx: false,
              child: ClientTextField(
                labelText: "Email PEC",
                maxLength: 20,
                prefixIcon: Icons.email,
                textInputType: TextInputType.emailAddress,
                valToValidate: "pec",
              ),
            ),
          ),
        ],
      );
}
