import 'package:flutter/material.dart';

//* pagina mostrata quando ho  un qualche tipo di errore !
//* l'errore, in genere, è dato da una qualche chiamata API o al database

class ErrorPage extends StatelessWidget {
  final String error;
  final String? btnText;
  final void Function()? onBtnPressed;
  const ErrorPage({
    Key? key,
    required this.error,
    this.btnText,
    this.onBtnPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, cons) => Stack(children: [
          Positioned(
            top: 5.0,
            left: 0.0,
            right: 0.0,
            bottom: cons.maxHeight * 0.3,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/error.jpg"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            left: 5.0,
            right: 5.0,
            top: cons.maxHeight * 0.7,
            bottom: 0.0,
            child: Center(
              child: btnText == null
                  ? _buildText()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildText(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            child: Text(btnText!),
                            onPressed: onBtnPressed,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ]),
      );

  Widget _buildText() => Text(error);
}
