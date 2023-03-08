import 'package:flutter/material.dart';
import 'package:music/models/feedbacks.dart';
import 'package:music/helpers.dart';

//* pagina che viene mostrata quando clicco su un feedback dalla lista di quelli che ho inviati !
class FeedbackProfile extends StatelessWidget {
  final Feedbacks currentFeed;
  final int feedIndex;
  const FeedbackProfile({
    Key? key,
    required this.currentFeed,
    required this.feedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback numero $feedIndex"),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      const Text("Inviato il: "),
                      const Spacer(),
                      Text(formatDateToString(currentFeed.creatoIl)),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Contenuto del Feedback: ")),
                ),
                Expanded(
                  flex: 8,
                  child: Center(
                    child: Text(
                      currentFeed.content,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

//TODO: AGGIUNGERLO AL ROUTER E PASSARGLI COME ARGOMENTO UN FEEDBACK
