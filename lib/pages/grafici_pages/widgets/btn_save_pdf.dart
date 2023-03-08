//funzioni per esportare cose in pdf
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/pages/grafici_pages/helpers/grafici_client_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../helpers.dart';
import '../../../provider/user_provider.dart';
import '../../../theme.dart';

//* bottone che salva immagini in PDF
class BtnSavePdf extends StatelessWidget {
  const BtnSavePdf({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.picture_as_pdf),
      onPressed: () async {
        // setState(() => isLoading = true);
        final Map<String, dynamic>? filePath =
            await showDialog<Map<String, dynamic>>(
                context: context,
                barrierDismissible: false,
                builder: (ctx) => AlertDialog(
                      contentPadding: const EdgeInsets.all(5.0),
                      title: const Text("Generazione file PDF. . ."),
                      actions: const [
                        FittedBox(
                            child: Text(
                                "Potresti dover attendere qualche secondo . . ."))
                      ],
                      backgroundColor: MainColor.primaryColor,
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: FutureBuilder(
                          future: generatePdfGraph(context),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (snap.hasError) {
                              Navigator.of(context).pop({
                                'success': false,
                                'content': snap.error.toString()
                              });

                              return const SizedBox.shrink();
                            }
                            Navigator.of(context).pop({
                              'success': true,
                              'content': snap.data as File
                            });

                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ));

        if (filePath != null && filePath['success']) {
          showSnackBar(
            context,
            "Documento salvato in: Download !",
            snackBarBtn: _buildSnackBarBtn(filePath['content']),
          );
        } else {
          print("errore: ${filePath!['content']}");
          showSnackBar(
            context,
            filePath?['content'] ?? "Errore",
            isError: true,
          );
        }
      },
    );
  }

//controlli i permessi, se comcessi genero i grafici in PDF e li salvo in storage
  Future<File> generatePdfGraph(BuildContext context) async {
    try {
      //i permessi di accesso alla cartella download in Android sono diversi

      await checkStoragePermission();

      final filePath = await generatePdf(context);
      return filePath;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkStoragePermission() async {
    //* Controllo i permessi dell'app di scrittura nella memoria interna
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    if (status.isGranted) {
      return;
    }

    //* PDF NON salvato (o perchè utente non ha dato i permessi, o per altro)
    throw (status.isDenied
        ? "Errore: Permesso di scrittura Non concesso"
        : "Errore nel generare il Documento !");
  }

//todo: cambiare font Type del testo del PDF generato (ad esempio usare montSerrat)), maggiori info sul warning qua => https://stackoverflow.com/questions/67928078/helvetica-has-no-unicode-support-flutter-using-pdf-package
  Future<File> generatePdf(BuildContext context) async {
    final date = DateTime.now();
    final fileName = "grafico_${formatPdfSecond(date)}";
    late File filePath;
    if (Platform.isWindows) {
      final String path = (await getDownloadsDirectory())!.path;
      filePath = File("$path/$fileName.pdf");
    } else if (Platform.isAndroid) {
      //* questo ritorna /storage/emulated/0/Android/data/it.hopenstartup.www.music/files => non mi piace, allora manualmente lo salvo in Download
      final String path = (await getExternalStorageDirectory())!.path;
      filePath = File("$path/$fileName.pdf");
      //* filePath = File("/storage/emulated/0/Download/$fileName.pdf"); SALVA IN DOWNLOAD MA DA ANNDROID 10 IN POI PROVOCA ERRORI
    } else if (Platform.isIOS) {
      final path = await getApplicationDocumentsDirectory();
      final Directory dir = await Directory("${path.path}/grafici").create();
      filePath = File("${dir.path}/$fileName.pdf");
    }
    final pdf = pw.Document(pageMode: PdfPageMode.fullscreen);
    pdf.addPage(_intestazionePage(context, date));
    //* Per ogni grafico creo una pagina nel PDF
    ScreenshotController screenshotController = ScreenshotController();
    final List<Widget> widgets = [
      context.read<GraficiClientProvider>().etaMusicaleToPdf(),
      context.read<GraficiClientProvider>().moodToPdf(),
      context.read<GraficiClientProvider>().musicofiliaToPdf()
    ];
    for (int i = 0; i < widgets.length; i++) {
      final bytes = await screenshotController.captureFromWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: widgets[i],
        ),
      );
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Image(
            pw.MemoryImage(bytes),
          ),
        ), //drawPdfContent(date, bytes),
      );
    }

//salvo il PDF nel path
    await filePath.writeAsBytes(await pdf.save());
    return filePath;
  }

//* prima pagina del PDF (Nome operatore, data del documento, breve spiegazione ??)
  pw.Page _intestazionePage(BuildContext context, DateTime date) {
    final String userName =
        context.read<UserProvider>().currentUser!.socialAccount.nome;
    final String userSurname =
        context.read<UserProvider>().currentUser!.socialAccount.cognome;
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Operatore: $userName $userSurname",
                  style:
                      const pw.TextStyle(color: PdfColors.black, fontSize: 10),
                ),
                pw.Text(
                  "Documento del ${formatSecond(date)}",
                  style:
                      const pw.TextStyle(color: PdfColors.black, fontSize: 10),
                ),
              ]),
        ],
      ),
    );
  }

//* Contenuto del PDF
  pw.Page drawPdfContent(
    final DateTime date,
    final Uint8List bytes,
    BuildContext context,
  ) {
    final String userName =
        context.read<UserProvider>().currentUser!.socialAccount.nome;
    final String userSurname =
        context.read<UserProvider>().currentUser!.socialAccount.cognome;
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Operatore: $userName $userSurname",
                  style:
                      const pw.TextStyle(color: PdfColors.black, fontSize: 10),
                ),
                pw.Text(
                  "Documento del ${formatSecond(date)}",
                  style:
                      const pw.TextStyle(color: PdfColors.black, fontSize: 10),
                ),
              ]),

          //se anonimo, altrimenti niente
          pw.Expanded(
            child: pw.Image(pw.MemoryImage(bytes)),
          ),
        ],
      ),
    );
  }

  //bottone nella snackBar, click => apre il PDF
  _buildSnackBarBtn(File filePath) => InkWell(
        onTap: () async {
          print("eccoci filePath: $filePath");
          //* su mio telefono funzia, su emulatore no, mi da result: ResultType.noAppToOpen e msg: No APP found to open this file.
          final result = await OpenFile.open(filePath.path);
          print("ecco result: ${result.type} e msg: ${result.message}");
        },
        child: Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: MainColor.primaryColor,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: const [
              Text(
                "Mostra PDF",
                style: TextStyle(color: Colors.white),
              ),
              Icon(Icons.arrow_right_alt),
            ],
          ),
        ),
      );
}
