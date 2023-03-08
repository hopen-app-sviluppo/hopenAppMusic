import 'package:flutter/material.dart';
import 'package:music/constant.dart';
import '../../../common_widget/custom_rounded_card.dart';
import '../widgets/client_text_field.dart';
import '../widgets/custom_dropdown_btn.dart';

//* step 1 della creazione assistito

class CreaDatiAssistito extends StatelessWidget {
  const CreaDatiAssistito({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNomeCognome(context),
        _buildCodiceFiscaleSesso(context),
        // Mettere un controllo => data decesso non può essere prima di data nascita
        _buildCittadinanzaDataNascita(context),
        _buildStatoCivileDataDecesso(context),
        _buildIstruzioneComDiNascita(context),
        _buildCondProfessionale(context),
      ],
    );
  }

  Row _buildNomeCognome(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            flex: 4,
            child: RoundedCard(
              child: ClientTextField(
                labelText: "Cognome *",
                maxLength: 15,
                prefixIcon: Icons.person,
                valToValidate: "cognome",
              ),
            ),
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 3,
            child: RoundedCard(
              isRoundedOnDx: false,
              child: ClientTextField(
                labelText: "Nome *",
                maxLength: 15,
                prefixIcon: Icons.person,
                valToValidate: "nome",
              ),
            ),
          ),
        ],
      );

  _buildCodiceFiscaleSesso(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            flex: 4,
            child: RoundedCard(
              child: ClientTextField(
                labelText: "Codice Fiscale ",
                maxLength: 15,
                prefixIcon: Icons.code,
                valToValidate: "cc",
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
                  title: "Sesso",
                  items: sesso,
                  valToValidate: "sesso",
                ),
              )),
        ],
      );

  _buildCittadinanzaDataNascita(BuildContext context) => Row(
        children: const [
          Expanded(
            flex: 4,
            child: RoundedCard(
              child: CustomDropdownBtn(
                items: cittadinanza,
                title: "Cittadinanza",
                valToValidate: "cittadinanza",
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
              child: DatePickerField(
                labelText: "Data Nascita",
                valToValidate: "nascita",
              ),
            ),
          ),
        ],
      );

  _buildStatoCivileDataDecesso(BuildContext context) => Row(
        children: const [
          Expanded(
            flex: 4,
            child: RoundedCard(
              child: CustomDropdownBtn(
                items: statoCivile,
                title: "Stato Civile",
                valToValidate: "stato_civile",
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
              child: DatePickerField(
                labelText: "Data Decesso",
                valToValidate: "dec",
              ),
            ),
          ),
        ],
      );
  _buildIstruzioneComDiNascita(BuildContext context) => Row(
        children: const [
          Expanded(
            flex: 4,
            child: RoundedCard(
              child: CustomDropdownBtn(
                items: condizioneProfessionale,
                title: "Condizione Professionale",
                valToValidate: "cond_professionale",
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
                items: istruzione,
                title: "Istruzione",
                valToValidate: "istruzione",
              ),
            ),
          )
        ],
      );

  _buildCondProfessionale(BuildContext context) => RoundedCard(
        width: MediaQuery.of(context).size.width / 1.6,
        child: const CustomDropdownBtn(
          items: professione,
          title: "Professione",
          valToValidate: "prof",
        ),
      );
}
