import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:music/theme.dart';
import 'package:url_launcher/url_launcher.dart';

//* metodi comuni a pages differenti

//se tappo lo schermo chiude la tastiera
void checkFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

Future<void> goToUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Errore nel lanciare url $url';
  }
}

//+ mostra snackbar sopra alla nav bar e sopra al fab button
void showSnackBar(BuildContext context, String title,
    {bool isError = false, final Widget? snackBarBtn}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(milliseconds: 2500),
    content: SizedBox(
      height: kToolbarHeight,
      child: snackBarBtn == null
          ? Center(
              child: snackBarText(title, context),
            )
          : Row(children: [
              Expanded(
                child: snackBarText(title, context),
              ),
              snackBarBtn
            ]),
    ),
    elevation: 10.0,
    //* se sto sul web, non devo settare questo parametro (altrimenti la snackBar viene vista in alto)
    behavior: MediaQuery.of(context).size.width < 1200
        ? SnackBarBehavior.floating
        : null,
    backgroundColor:
        isError ? MainColor.redColor : MainColor.secondaryAccentColor,
  ));
}

Text snackBarText(String text, BuildContext context) => Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );

//+ funzione che converte datetime in stringa, secondo il format passatogli, torna 2022-01-20

String formatDateToString(DateTime date) =>
    DateFormat('yyyy-MM-dd').format(date);

DateTime formatStringToYear(String date) => DateFormat("yy-MM-dd").parse(date);

String formatHour(DateTime date) => DateFormat('yyyy-MM-dd HH:mm').format(date);

//usata nel machform elemento date e europe_date
String formatYear(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

//usata per il nome del file PDF in memoria
String formatPdfSecond(DateTime date) =>
    DateFormat('yyMMdd_HHmmss').format(date);

//usata per stampare la data nel file PDF in memoria
String formatSecond(DateTime date) =>
    DateFormat('dd-MM-yyyy HH:mm:ss').format(date);

DateTime formtStringToDate(String date) =>
    DateFormat("yy-MM-dd HH:mm").parse(date);

//funzione usata quando decodifico valori nei miei models tramite formJson
bool formatIntToBool(int val) => val == 1;

bool formatStringToBool(String val) => val == '1';

//se val = true, allora torna 1, altrimento 0
int formatBoolToInt(bool val) => val ? 1 : 0;
