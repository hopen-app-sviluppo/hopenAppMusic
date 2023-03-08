import 'package:flutter/material.dart';

//ricorda login, per ora non fa nulla, il login se lo ricorda di default

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) => Checkbox(
        checkColor: Colors.white,
        value: isChecked,
        onChanged: (bool? value) {
          setState(() {
            isChecked = !isChecked;
          });
        },
      );
}
