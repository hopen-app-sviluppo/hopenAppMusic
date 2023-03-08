import 'package:flutter/material.dart';
import 'package:music/models/cliente.dart';
import 'package:music/pages/grafici_pages/helpers/grafici_client_provider.dart';
import 'package:music/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../theme.dart';

class DropdownBtn extends StatefulWidget {
  const DropdownBtn({Key? key}) : super(key: key);

  @override
  State<DropdownBtn> createState() => _DropdownBtnState();
}

class _DropdownBtnState extends State<DropdownBtn> {
  int? selectedVal;
  late final List<DropdownMenuItem<int?>> _dropDownMenuItems;
  late final List<Cliente> clients;

  @override
  void initState() {
    super.initState();
    clients = context.read<GraficiClientProvider>().userClients!;
    _dropDownMenuItems = clients
        .map(
          (Cliente act) => DropdownMenuItem<int?>(
            value: act.id,
            child: Text(
              act.nome,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final GraficiClientProvider prov = context.read<GraficiClientProvider>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButton<int?>(
        value: selectedVal,
        items: _dropDownMenuItems,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            prov.currentClient != null
                ? "${prov.currentClient!.nome} ${prov.currentClient!.cognome}"
                : "Scegli Assistito",
            style: const TextStyle(color: MainColor.primaryColor),
          ),
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: MainColor.primaryColor,
        ),
        onChanged: (int? newClientId) {
          if (newClientId != null && newClientId != selectedVal) {
            prov.updateClient(
              context.read<UserProvider>().currentUser!.id,
              clients.firstWhere((element) => element.id == newClientId),
            );
            //se il risultato scelto è != null ed è != da quello precedente, allora chiamo setState => query sul nuovo cliente e via
            setState(() {
              selectedVal = newClientId;
            });
          }
        },
        //per cambiare colore quando seleziono un elemento
        selectedItemBuilder: (BuildContext context) {
          return clients.map<Widget>((Cliente item) {
            return Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                child: Text(
                  "${item.nome} ${item.cognome}",
                  style: const TextStyle(color: MainColor.primaryColor),
                ),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
