import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music/api/gestionale_api/testo_api.dart';
import 'package:music/theme.dart';

import '../../../common_widget/custom_html_page.dart';

class SezioneTutorial extends StatelessWidget {
  final int formId;
  final String text;
  final String appBarTitle;
  //se formId è 0, allora è musicoerapia (quindi nel gestionale ha id 2), altrimenti è diario (nel gestionale ha id 3)
  const SezioneTutorial({
    Key? key,
    required this.formId,
    required this.text,
    required this.appBarTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(children: [
        AppBar(
          title: Text(appBarTitle),
          centerTitle: true,
        ),
        Expanded(
          child: Platform.isAndroid || Platform.isIOS
              ? RawScrollbar(
                  thumbVisibility: true,
                  thumbColor: MainColor.secondaryAccentColor,
                  scrollbarOrientation: ScrollbarOrientation.right,
                  thickness: 4,
                  child: _buildContent(),
                )
              : _buildContent(),
        ),
      ]);

  Widget _buildContent() => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
              future: formId == 0
                  ? TestoApi.getDescrizioneMusicoterapia()
                  : TestoApi.getDescrizioneDiarioMus(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snap.hasError) {
                  return Text(
                    text,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  );
                }

                final testoGestionale = snap.data as String?;
                if (testoGestionale == null) {
                  return Text(
                    text,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  );
                }
                return HtmlPage(
                  htmlData: testoGestionale,
                );
                // return Text(
                //   testoGestionale,
                //   textAlign: TextAlign.start,
                //   style: const TextStyle(
                //     color: Colors.white,
                //   ),
                // );
              }),
        ),
      );
}
