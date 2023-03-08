import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/settings_provider.dart';
import '../../../responsive_widget/size_config.dart';
import '../../../helpers.dart';

import '../../common_widget/custom_clipper.dart';
import 'helpers/enums.dart';
import 'views/crea_contatti_assistito.dart';
import 'views/crea_dati_assistito.dart';
import 'views/crea_residenza_assistito.dart';
import 'widgets/button_crea_assistito.dart';
import 'widgets/step_radiobtn.dart';

class CreaAssistito extends StatefulWidget {
  const CreaAssistito({Key? key}) : super(key: key);

  @override
  State<CreaAssistito> createState() => _CreaAssistitoState();
}

class _CreaAssistitoState extends State<CreaAssistito> {
  ClientCreationPhase clientCreationPhase =
      ClientCreationPhase.informazioniAssistito;
  @override
  Widget build(BuildContext context) {
    final sizeConfig = context.read<SettingsProvider>().config;
    return Scaffold(
      body: GestureDetector(
        onTap: () => checkFocus(context),
        child: _buildBody(context),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: sizeConfig.blockSizeVertical * 8,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _buildBtns(context),
        ),
      ),
      extendBody: true,
    );
  }

  Stack _buildBody(BuildContext context) {
    final sizeConfig = context.read<SettingsProvider>().config;
    return Stack(children: <Widget>[
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: drawLines(
          context,
          isTopDraw: false,
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: drawLines(context),
      ),
      //!   Form
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: _buildForm(context, sizeConfig),
      ),
    ]);
  }

  _buildForm(BuildContext context, SizeConfig size) => Container(
        width: double.infinity,
        height: size.screenHeight,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: SingleChildScrollView(
          child: Column(
            children: _buildFormElements(size),
          ),
        ),
      );

  List<Widget> _buildFormElements(SizeConfig size) => [
        //* logo app - testo
        SizedBox(
          height: size.safeBlockVertical * 15,
          child: StepRadioBtn(creationPhase: clientCreationPhase),
        ),
        //* login form - register form
        SizedBox(
          width: double.infinity,
          height:
              size.safeBlockVertical * 75 - MediaQuery.of(context).padding.top,
          child:
              clientCreationPhase == ClientCreationPhase.informazioniAssistito
                  ? const CreaDatiAssistito()
                  : clientCreationPhase == ClientCreationPhase.residenza
                      ? const CreaResidenzaAssistito()
                      : const CreaContattiAssistito(),
        ),
      ];

  _buildBtns(BuildContext context) => ButtonCreaAssistito(
        clientCreationPhase: clientCreationPhase,
        //quando premo il bottone
        onBtnPressed: (newPhase) {
          setState(() {
            clientCreationPhase = newPhase;
          });
        },
        onIconBtnPressed: onIconButtonPressed,
      );

//quando premo l'icona a sinistra del bottone
  void onIconButtonPressed() {
    switch (clientCreationPhase) {
      case ClientCreationPhase.informazioniAssistito:
        //torno a home Page
        Navigator.of(context).pop();
        break;
      case ClientCreationPhase.residenza:
        clientCreationPhase = ClientCreationPhase.informazioniAssistito;
        break;
      case ClientCreationPhase.informazioniDiContatto:
        clientCreationPhase = ClientCreationPhase.residenza;
        break;
    }
    setState(() {});
  }
}
