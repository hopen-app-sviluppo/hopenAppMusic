import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../theme.dart';
import '../helpers/crea_assistito_provider.dart';

//usato nella fase di creazione assistito
class CustomDropdownBtn extends StatefulWidget {
  final List<String> items;
  final String title;
  final String valToValidate;
  const CustomDropdownBtn({
    Key? key,
    required this.items,
    required this.title,
    required this.valToValidate,
  }) : super(key: key);

  @override
  State<CustomDropdownBtn> createState() => CustomDropdownBtnState();
}

class CustomDropdownBtnState extends State<CustomDropdownBtn> {
  late final List<DropdownMenuItem<String>> _dropDownMenuItems;
  late String? _selectedVal;

  @override
  void initState() {
    super.initState();
    _selectedVal = context
        .read<CreaAssistitoProvider>()
        .getCurrentField(widget.valToValidate);
    _dropDownMenuItems = widget.items
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
    final bool isValSelected = _selectedVal == null;
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        right: 5.0,
        bottom: 5.0,
        left: 7.0,
      ),
      //quando non ho scelto nulla, alignment.centerLeft, quando ho scelto = bottomLeft
      child: Stack(
          alignment:
              isValSelected ? Alignment.centerLeft : Alignment.bottomLeft,
          children: [
            if (!isValSelected)
              Positioned(
                top: 0.0,
                left: 0.0,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: MainColor.primaryColor,
                  ),
                ),
              ),
            //* quando scelgo valore in alto appare il nome del campo
            DropdownButton<String>(
              items: _dropDownMenuItems,
              isExpanded: true,
              underline: Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  _selectedVal ?? "",
                  style: const TextStyle(
                    color: MainColor.primaryColor,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              hint: isValSelected
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: MainColor.primaryColor,
                        ),
                      ),
                    )
                  : null,
              icon: Icon(
                Icons.arrow_drop_down,
                color: MainColor.primaryColor,
                size: Theme.of(context).iconTheme.size,
              ),
              onChanged: (String? newAct) {
                setState(() {
                  _selectedVal = newAct;
                });
                context.read<CreaAssistitoProvider>().updateField(
                      widget.valToValidate,
                      _selectedVal,
                    );
              },
              //per cambiare colore quando seleziono un elemento
              selectedItemBuilder: (BuildContext context) {
                return widget.items.map<Widget>((String item) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: MainColor.primaryColor,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ]),
    );
  }
}
