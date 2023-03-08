import 'package:flutter/material.dart';
import 'package:music/database/client_operations.dart';
import 'package:music/database/user_operations.dart';
import 'package:music/models/cliente.dart';

import 'package:music/pages/common_widget/custom_expansion_tile.dart';
import 'package:music/pages/common_widget/immagine_profilo.dart';
import 'package:music/pages/credenziali_page/models.dart';
import 'package:music/provider/user_provider.dart';
import 'package:music/theme.dart';
import 'package:provider/provider.dart';
import '../../helpers.dart';

//TODO modifiche social su credenziali utente !
//TODO: per ora la modifica è solo testuale (se voglio cambiare, per esempio, provincia) si dovrebbe scegliere una lista di item tra le province

//Pagina che mostra le credenziali, o di un terapista oppure di un assistito !
class CredenzialiPage extends StatefulWidget {
  final Cliente? currentClient;
  const CredenzialiPage({
    Key? key,
    this.currentClient,
  }) : super(key: key);

  @override
  State<CredenzialiPage> createState() => _CredenzialiPageState();
}

class _CredenzialiPageState extends State<CredenzialiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currentClient == null
            ? "Le tue Credenziali"
            : "Credenziali di ${widget.currentClient!.nome}"),
        centerTitle: true,
      ),
      body: widget.currentClient == null
          ? _buildUserCredentialBody(context)
          : _buildClientCredentialBody(context),
    );
  }

  Widget _buildUserCredentialBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ImmagineProfilo(
              avatar: context
                  .read<UserProvider>()
                  .currentUser!
                  .socialAccount
                  .avatar,
              backgroundColor: Colors.blue.withOpacity(0.3),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Nome ",
                currentVal: context
                    .read<UserProvider>()
                    .currentUser!
                    .socialAccount
                    .nome,
                dbName: "first_name",
              ),
              showIcon: false,
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Cognome ",
                currentVal: context
                    .read<UserProvider>()
                    .currentUser!
                    .socialAccount
                    .cognome,
                dbName: "last_name",
              ),
              showIcon: false,
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Email ",
                currentVal: context
                    .read<UserProvider>()
                    .currentUser!
                    .socialAccount
                    .email,
                dbName: "email",
              ),
              showIcon: false,
            ),
            //* modifica nel social
            _buildField(
              context,
              CampoTestuale(
                displayText: "Attività ",
                currentVal: context
                    .read<UserProvider>()
                    .currentUser!
                    .internalAccount
                    .attivita,
                dbName: "attivita",
              ),
            ),
            //* modifica nel social
            _buildField(
              context,
              CampoTestuale(
                displayText: "Città  ",
                currentVal: context
                    .read<UserProvider>()
                    .currentUser!
                    .socialAccount
                    .citta,
                dbName: "city",
              ),
              showIcon: false,
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Ente ",
                currentVal: context
                    .read<UserProvider>()
                    .currentUser!
                    .internalAccount
                    .company,
                dbName: "company",
              ),
            ),
            //* modifica nel social
            _buildField(
              context,
              CampoTestuale(
                displayText: "Telefono ",
                currentVal: context
                    .read<UserProvider>()
                    .currentUser!
                    .socialAccount
                    .telefono,
                dbName: "phone_number",
              ),
              showIcon: false,
              isKeyboardText: false,
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Partita Iva ",
                currentVal: context
                    .read<UserProvider>()
                    .currentUser!
                    .internalAccount
                    .partitaIva,
                dbName: "partita_iva",
              ),
              isKeyboardText: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientCredentialBody(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Text(
                "${widget.currentClient!.nome} ${widget.currentClient!.cognome}"),
            _buildBoxResidenza(context),
            _buildBoxDomicilio(context),
            _buildBoxRecapiti(context),
            _buildField(
              context,
              CampoTestuale(
                displayText: "ASL di appartenenza",
                currentVal: widget.currentClient!.aslDiAppartenenza,
                dbName: "client_asl_appartenenza",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Cittadinanza",
                currentVal: widget.currentClient!.cittadinanza,
                dbName: "client_cittadinanza",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Sesso",
                currentVal: widget.currentClient!.sesso,
                dbName: "client_sesso",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "CC",
                currentVal: widget.currentClient!.codiceFiscale,
                dbName: "client_codice_fiscale",
              ),
            ),
            //TODO: è UNA DATA !
            _buildField(
              context,
              CampoTestuale(
                displayText: "Nato il",
                currentVal: widget.currentClient!.dataDiNascita,
                dbName: "client_data_nascita",
              ),
              isDate: true,
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Comune di nascita",
                currentVal: widget.currentClient!.comuneDiNascita,
                dbName: "client_comune_nascita",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Provincia di nascita ",
                currentVal: widget.currentClient!.provDiNascita,
                dbName: "client_provincia_nascita",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Nazione di nascita ",
                currentVal: widget.currentClient!.nazione,
                dbName: "client_state",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Stato civile ",
                currentVal: widget.currentClient!.statoCivile,
                dbName: "client_stato_civile",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Condizione Professionale",
                currentVal: widget.currentClient!.condProfessionale,
                dbName: "client_condizione_professionale",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Istruzione",
                currentVal: widget.currentClient!.istruzione,
                dbName: "client_istruzione",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Professione ",
                currentVal: widget.currentClient!.professione,
                dbName: "client_professione",
              ),
            ),
          ]),
        ),
      );

  Widget _buildBoxResidenza(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: MainColor.secondaryColor,
            ),
            borderRadius: BorderRadius.circular(25.0)),
        child: CustomExpansionTile(
          title: const Text(
            "Residenza",
            style: TextStyle(color: Colors.white),
          ),
          children: [
            _buildField(
              context,
              CampoTestuale(
                displayText: "Indirizzo1",
                currentVal: widget.currentClient!.indirizzoResidenza,
                dbName: "client_address_1",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Indirizzo2",
                currentVal: widget.currentClient!.indirizzo2Residenza,
                dbName: "client_address_2",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Città",
                currentVal: widget.currentClient!.cittaResidenza,
                dbName: "client_city",
              ),
            ),
            //todo: non modificare con testo, ma scegliendo il nuovo valore dalla lista
            _buildField(
              context,
              CampoTestuale(
                displayText: "Provincia",
                currentVal: widget.currentClient!.provResidenza,
                dbName: "client_country",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Nazione",
                currentVal: widget.currentClient!.nazioneResidenza,
                dbName: "client_residenza_state",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "CAP ",
                currentVal: widget.currentClient!.capResidenza,
                dbName: "client_residenza_cap",
              ),
              isKeyboardText: false,
            ),
          ],
        ),
      );

  Widget _buildBoxDomicilio(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: MainColor.secondaryColor),
            borderRadius: BorderRadius.circular(25.0)),
        child: CustomExpansionTile(
          title: const Text("Domicilio", style: TextStyle(color: Colors.white)),
          children: [
            _buildField(
              context,
              CampoTestuale(
                displayText: "Indirizzo1",
                currentVal: widget.currentClient!.indirizzoDomicilio,
                dbName: "client_domicilio_address_1",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Indirizzo2",
                currentVal: widget.currentClient!.indirizzo2Domicilio,
                dbName: "client_domicilio_address_2",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Città",
                currentVal: widget.currentClient!.cittaDomicilio,
                dbName: "client_domicilio_city",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Provincia",
                currentVal: widget.currentClient!.provDomicilio,
                dbName: "client_domicilio_country",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Nazione",
                currentVal: widget.currentClient!.nazioneDomicilio,
                dbName: "client_domicilio_state",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "CAP",
                currentVal: widget.currentClient!.capDomicilio,
                dbName: "client_domicilio_cap",
              ),
              isKeyboardText: false,
            ),
          ],
        ),
      );

  Widget _buildBoxRecapiti(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: MainColor.secondaryColor),
            borderRadius: BorderRadius.circular(25.0)),
        child: CustomExpansionTile(
          title: const Text("Recapiti", style: TextStyle(color: Colors.white)),
          children: [
            _buildField(
              context,
              CampoTestuale(
                displayText: "Email",
                currentVal: widget.currentClient!.email,
                dbName: "client_email",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Email PEC",
                currentVal: widget.currentClient!.emailPec,
                dbName: "client_email_pec",
              ),
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Telefono1",
                currentVal: widget.currentClient!.telefono,
                dbName: "client_phone_1",
              ),
              isKeyboardText: false,
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Telefono2",
                currentVal: widget.currentClient!.telefono2,
                dbName: "client_phone_2",
              ),
              isKeyboardText: false,
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Telefono3",
                currentVal: widget.currentClient!.telefono3,
                dbName: "client_phone_3",
              ),
              isKeyboardText: false,
            ),
            _buildField(
              context,
              CampoTestuale(
                displayText: "Telefono4",
                currentVal: widget.currentClient!.telefono4,
                dbName: "client_phone_4",
              ),
              isKeyboardText: false,
            ),
          ],
        ),
      );

  Widget _buildField(
    BuildContext context,
    CampoTestuale campoTestuale, {
    bool showIcon = true,
    bool isDate = false,
    bool isKeyboardText = true,
  }) =>
      Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(width: 2.0, color: MainColor.secondaryColor),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                campoTestuale.displayText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                campoTestuale.currentVal == null ||
                        campoTestuale.currentVal == ""
                    ? "non specificato"
                    : campoTestuale.currentVal!,
              ),
            ),
            if (isDate)
              Expanded(
                  child: GestureDetector(
                onTap: () async {
                  DateTime? date = DateTime.now();
                  date = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: date.subtract(const Duration(days: 36500)),
                    lastDate: date,
                  );
                  if (date != null) {
                    //aggiorno valore nel DB locale
                    try {
                      final String dateFormat = formatDateToString(date);
                      await ClienteOperations.updateClientField(
                        clientId: widget.currentClient!.id!,
                        fieldToUpdate: campoTestuale.dbName,
                        valToInsert: dateFormat,
                      );
                      widget.currentClient!
                          .updateVal(campoTestuale.dbName, dateFormat);
                      setState(() {});
                      showSnackBar(context, "Success !");
                    } catch (e) {
                      showSnackBar(context, "Errore", isError: true);
                    }
                  }
                },
                child: const Icon(Icons.date_range),
              ))
            else
              Expanded(
                child: showIcon
                    ? GestureDetector(
                        onTap: () async {
                          final result = await aggiornaCampo(
                            context,
                            campoTestuale: campoTestuale,
                            isKeyboardText: isKeyboardText,
                          );
                          if (result != null && result) {
                            setState(() {});
                            showSnackBar(context, "Success !");
                          }
                        },
                        child: const Icon(Icons.edit_outlined),
                      )
                    : const SizedBox.shrink(),
              ),
          ],
        ),
      );

  Future<bool?> aggiornaCampo(
    BuildContext context, {
    required CampoTestuale campoTestuale,
    bool isKeyboardText = true,
  }) async =>
      await showDialog<bool?>(
          context: context,
          builder: (context) {
            // ignore: unused_local_variable
            String? newVal;
            return AlertDialog(
              backgroundColor: MainColor.primaryColor,
              title: Text("Modifica ${campoTestuale.displayText}"),
              content: Card(
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    style: const TextStyle(
                      color: MainColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: isKeyboardText
                        ? TextInputType.text
                        : TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onChanged: (val) {
                      newVal = val;
                    },
                    decoration: InputDecoration(
                      label: campoTestuale.currentVal != null
                          ? Text(
                              campoTestuale.currentVal!,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          : null,
                      prefixIcon: Icon(
                        Icons.edit,
                        color: MainColor.primaryColor,
                        size: Theme.of(context).iconTheme.size,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    "Annulla !",
                  ),
                ),
                ElevatedButton(
                  child: const Text("Modifica !"),
                  onPressed: () async {
                    //pusho cambiamento nel db e se tutto va bene torno qualcosa
                    try {
                      if (widget.currentClient != null) {
                        await ClienteOperations.updateClientField(
                          clientId: widget.currentClient!.id!,
                          fieldToUpdate: campoTestuale.dbName,
                          valToInsert: newVal,
                        );
                        widget.currentClient!
                            .updateVal(campoTestuale.dbName, newVal!);
                      } else {
                        //aggiorno db interno dell'utente
                        await UserOperations.updateUserInternalField(
                          userId: context.read<UserProvider>().currentUser!.id,
                          fieldToUpdate: campoTestuale.dbName,
                          valToInsert: newVal,
                        );
                        context
                            .read<UserProvider>()
                            .currentUser!
                            .internalAccount
                            .updateVal(campoTestuale.dbName, newVal!);
                      }

                      Navigator.of(context).pop(true);
                    } catch (e) {
                      Navigator.of(context).pop(false);
                    }
                  },
                )
              ],
            );
          });
}
