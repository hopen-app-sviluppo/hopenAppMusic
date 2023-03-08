import 'package:flutter/material.dart';
import 'package:music/provider/user_provider.dart';
import 'package:music/router.dart';
import 'package:provider/provider.dart';
import '../../../../helpers.dart';
import '../helpers/crea_assistito_provider.dart';
import '../helpers/enums.dart';

//bottone usato per creare un nuovo assistito !!!
class ButtonCreaAssistito extends StatefulWidget {
  final ClientCreationPhase clientCreationPhase;
  //ritorna il cambio dell'utente
  final Function(ClientCreationPhase) onBtnPressed;
  final void Function()? onIconBtnPressed;
  const ButtonCreaAssistito({
    Key? key,
    required this.clientCreationPhase,
    required this.onBtnPressed,
    required this.onIconBtnPressed,
  }) : super(key: key);

  @override
  State<ButtonCreaAssistito> createState() => _ButtonCreaAssistitoState();
}

class _ButtonCreaAssistitoState extends State<ButtonCreaAssistito> {
  late ClientCreationPhase currentPhase;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentPhase = widget.clientCreationPhase;
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : ElevatedButton(
          child: Row(
            children: [
              IconButton(
                onPressed: widget.onIconBtnPressed,
                icon: const Icon(Icons.arrow_circle_left_outlined),
              ),
              Expanded(
                child: Center(
                  child: Text(widget.clientCreationPhase ==
                          ClientCreationPhase.informazioniDiContatto
                      ? "Aggiungi Assistito !"
                      : "Prossimo Step !"),
                ),
              ),
            ],
          ),
          onPressed: () async {
            switch (widget.clientCreationPhase) {
              case ClientCreationPhase.informazioniAssistito:
                widget.onBtnPressed(ClientCreationPhase.residenza);
                break;
              case ClientCreationPhase.residenza:
                widget.onBtnPressed(ClientCreationPhase.informazioniDiContatto);
                break;
              case ClientCreationPhase.informazioniDiContatto:
                //! creo Assistito !
                await _addAssistito(context);
                setState(() => isLoading = false);
                break;
            }
            setState(() {});
          },
        );

  Future<void> _addAssistito(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final bool canAdd =
        context.read<CreaAssistitoProvider>().canCreateAssistito();
    if (!canAdd) {
      showSnackBar(context, "Errore: Specificare Nome e Cognome",
          isError: true);
      return;
    }
    //aggiungo assistito nel db interno !
    final bool isAssistitoCreated = await context
        .read<CreaAssistitoProvider>()
        .createAssistito(context.read<UserProvider>().currentUser!.id, context);
    if (isAssistitoCreated) {
      showSnackBar(context, "Assistito creato con successo !");
      Navigator.pushNamedAndRemoveUntil(
          context, AppRouter.listaAssistiti, (route) => false);
    } else {
      showSnackBar(context, "Errore: per favore riprovare", isError: true);
      Navigator.of(context).pop();
      return;
    }
  }
}
