import 'package:flutter/material.dart';
import '../../../../constant.dart';
import '../../../../theme.dart';

class DropdownAttivita extends StatefulWidget {
  const DropdownAttivita({Key? key}) : super(key: key);

  @override
  State<DropdownAttivita> createState() => _DropdownAttivitaState();
}

class _DropdownAttivitaState extends State<DropdownAttivita> {
  late final List<DropdownMenuItem<String>> _dropDownMenuItems;
  String? selectedVal;
  @override
  void initState() {
    super.initState();
    selectedVal = ".";
    //  context.read<AuthValidator>().fieldsValidator["attivita"]?["content"];
    _dropDownMenuItems = attivitaSvolte
        .map(
          (String act) => DropdownMenuItem<String>(
            value: act,
            child: Text(
              act,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: DropdownButton<String>(
        value: selectedVal,
        items: _dropDownMenuItems,
        isExpanded: true,
        iconSize: 40,
        underline: const SizedBox(),
        hint: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Attività Svolta",
            style: TextStyle(color: MainColor.primaryColor),
          ),
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: MainColor.primaryColor,
        ),
        onChanged: (String? newAct) {
          setState(() {
            selectedVal = newAct;
          });
          /*   context.read<AuthValidator>().onValiding(
                itemsToValidate: "attivita",
                valToValidate: newAct,
              );*/
        },
        //per cambiare colore quando seleziono un elemento
        selectedItemBuilder: (BuildContext context) {
          return attivitaSvolte.map<Widget>((String item) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item,
                style: const TextStyle(color: MainColor.primaryColor),
              ),
            );
          }).toList();
        },
      ),
    );
  }
}
