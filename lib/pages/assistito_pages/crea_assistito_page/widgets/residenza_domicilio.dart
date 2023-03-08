import 'package:flutter/material.dart';
import 'package:music/constant.dart';
import '../../../common_widget/custom_rounded_card.dart';
import 'client_text_field.dart';
import 'custom_dropdown_btn.dart';

class ResidenzaDomicilio extends StatefulWidget {
  const ResidenzaDomicilio({Key? key}) : super(key: key);

  @override
  State<ResidenzaDomicilio> createState() => _ResidenzaDomicilioState();
}

class _ResidenzaDomicilioState extends State<ResidenzaDomicilio> {
  bool showResidenza = true;
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      //TODO: CAMBIARE TUTTE LE ICONE
      child: ListView(
        physics: const PageScrollPhysics(),
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: [
          _buildBoxResidenza(),
          _buildBoxDomicilio(),
        ],
      ),
    );
  }

  Widget _buildBoxResidenza() {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Row(children: [
        const Text(
          "Residenza 1/2",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: !showResidenza
              ? null
              : () {
                  _controller.animateTo(
                    _controller.offset + MediaQuery.of(context).size.width,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeIn,
                  );
                  setState(() => showResidenza = false);
                },
          child: const Icon(
            Icons.arrow_right,
          ),
        ),
      ]),
      _buildIndirizzo1(context),
      _buildCittaProv(context),
      _buildCapNazione(context),
    ]);
  }

  Widget _buildBoxDomicilio() =>
      Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Row(children: [
          GestureDetector(
            onTap: showResidenza
                ? null
                : () {
                    _controller.animateTo(
                      _controller.offset - MediaQuery.of(context).size.width,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeIn,
                    );
                    setState(() => showResidenza = true);
                  },
            child: const Icon(
              Icons.arrow_left,
            ),
          ),
          const Text(
            "Domicilio 2/2",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
        _buildIndirizzo1(context),
        _buildCittaProv(context),
        _buildCapNazione(context),
      ]);

  _buildIndirizzo1(BuildContext context) => Row(
        children: [
          RoundedCard(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ClientTextField(
              labelText: "Indirizzo",
              maxLength: 15,
              prefixIcon: Icons.domain,
              valToValidate: showResidenza ? "ind_res" : "ind_dom",
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          RoundedCard(
            isRoundedOnDx: false,
            width: MediaQuery.of(context).size.width * 0.45,
            child: ClientTextField(
              labelText: "Indirizzo 2",
              maxLength: 15,
              prefixIcon: Icons.domain,
              valToValidate: showResidenza ? "2ind_res" : "2ind_dom",
            ),
          ),
        ],
      );

  _buildCittaProv(BuildContext context) => Row(
        children: [
          RoundedCard(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ClientTextField(
              labelText: "Città",
              maxLength: 15,
              prefixIcon: Icons.location_city,
              valToValidate: showResidenza ? "citta_res" : "citta_dom",
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          RoundedCard(
            width: MediaQuery.of(context).size.width * 0.45,
            isRoundedOnDx: false,
            child: CustomDropdownBtn(
              items: provincia,
              title: "Provincia",
              valToValidate: showResidenza ? "prov_res" : "prov_dom",
            ),
          ),
        ],
      );

  _buildCapNazione(BuildContext context) => Row(
        children: [
          RoundedCard(
            width: MediaQuery.of(context).size.width * 0.45,
            child: ClientTextField(
              labelText: "CAP",
              maxLength: 15,
              prefixIcon: Icons.tag,
              valToValidate: showResidenza ? "cap_res" : "cap_dom",
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
          ),
          RoundedCard(
            isRoundedOnDx: false,
            width: MediaQuery.of(context).size.width * 0.45,
            child: ClientTextField(
              labelText: "Nazione",
              maxLength: 15,
              prefixIcon: Icons.flag,
              valToValidate: showResidenza ? "naz_res" : "naz_dom",
            ),
          ),
        ],
      );
}

/*

 Row(
        children: [
          GestureDetector(
            onTap: showResidenza
                ? null
                : () => setState(() => showResidenza = true),
            child: const Icon(
              Icons.arrow_left,
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(children: [
                  Text(
                    showResidenza ? "Residenza 1/2" : "Domicilio 2/2",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _padding,
                  _buildIndirizzo1(context),
                  _padding,
                  _buildCittaProv(context),
                  _padding,
                  _buildCapNazione(context),
                ])),
          ),
          GestureDetector(
            onTap: !showResidenza
                ? null
                : () => setState(() => showResidenza = false),
            child: const Icon(
              Icons.arrow_right,
            ),
          ),
        ],
      ),


*/
