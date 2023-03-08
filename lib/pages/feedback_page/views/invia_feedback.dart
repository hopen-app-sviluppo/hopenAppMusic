import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:music/api/gestionale_api/testo_api.dart';
import 'package:provider/provider.dart';
import '../../../api/gestionale_api/feedback_api.dart';
import '../../../database/user_operations.dart';
import '../../../models/feedbacks.dart';
import '../../../provider/user_provider.dart';
import '../../../router.dart';
import '../../../theme.dart';
import '../../../helpers.dart';
import '../../common_widget/custom_html_page.dart';

class InviaFeedback extends StatefulWidget {
  const InviaFeedback({Key? key}) : super(key: key);

  @override
  State<InviaFeedback> createState() => _InviaFeedbackState();
}

class _InviaFeedbackState extends State<InviaFeedback> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    String? content;
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FutureBuilder(
                  future: TestoApi.getTestoPaginaFeedback(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snap.hasError) {
                      return const Text(
                        "Aiutaci a Migliorare l'App!\n\nGrazie ai tuoi suggerimenti possiamo estendere le funzionalità ed offrire un servizio migliore a tutti !",
                      );
                    }
                    final data = snap.data as String?;
                    return data == null
                        ? const Text("Aiutaci a migliorare l'App !")
                        : HtmlPage(htmlData: data);
                    // return Text(data ??
                    //     "Aiutaci a Migliorare l'App!\n\nGrazie ai tuoi suggerimenti possiamo estendere le funzionalità ed offrire un servizio migliore a tutti !!");
                  }),
              //* Field dove inserire la proposta
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.white),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLines: 5,
                        style: const TextStyle(
                            color: MainColor.primaryColor,
                            fontWeight: FontWeight.bold),
                        onChanged: (newVal) {
                          content = newVal;
                        },
                        decoration: InputDecoration(
                          label: Text("Proponici nuove funzionalità !",
                              style: Theme.of(context).textTheme.bodyText1),
                          prefixIcon: isLoading
                              ? null
                              : const Icon(
                                  Icons.edit_outlined,
                                  color: MainColor.primaryColor,
                                ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed:
                      isLoading ? null : () => sendFeedback(context, content),
                  child: const Text("Invia Feedback !"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //*TODO: mandare feedback alla nostra email, salvare l'invio del feedback nel DB interno

  Future<void> sendFeedback(BuildContext context, String? content) async {
    if (content == null || content.length < 20) {
      showSnackBar(context, "Dicci di più sulla tua proposta !", isError: true);
      return;
    }
    setState(() => isLoading = true);
    final currentUser = context.read<UserProvider>().currentUser!;
    final int userId = currentUser.id;
    final newFeedback = Feedbacks(
      userId: userId.toString(),
      content: content,
      creatoIl: DateTime.now(),
    );
    //2 operazioni => lo invio al gestionale, lo salvo nel DB interno !
    //prima lo pusho sul gestionale, poi provo a metterlo nel DB interno
    final bool sendedToGestionale = await FeedbackApi.sendFeedback(newFeedback);
    //se c'è stato errore
    if (!sendedToGestionale) {
      showSnackBar(context, "Errore indesiderato !");
      setState(() => isLoading = false);
      return;
    }
    //ho inviato il feedback al gestionale correttamente, lo pusho nel DB
    int counter = currentUser.internalAccount.feedbackInviati ?? 0;
    final bool isPushedOnDb = await UserOperations.onFeedbackSended(
      userId,
      ++counter,
    );
    if (!isPushedOnDb) {
      //todo: in questo caso il feedback sta nel gestionale ma ho fallito nel pusharlo nel DB interno
      //salvarmi in fatto che questo sia un errore e provarci in seguito???
      //oppure mando un alert sul gestionale dicendo che c'è stato st'errore?
      showSnackBar(context, "Errore indesiderato");
      setState(() => isLoading = false);
      return;
    }
    currentUser.internalAccount.feedbackInviati = counter;
    //tutto è adnato a buon fine !
    setState(() => isLoading = false);
    Navigator.pushReplacementNamed(context, AppRouter.profiloUtente);
    showSnackBar(context, "Grazie per il Feedback !");
  }
}
