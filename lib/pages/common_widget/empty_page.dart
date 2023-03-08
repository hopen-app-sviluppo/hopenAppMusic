import 'package:flutter/material.dart';

//* pagina mostrata quando non ho elementi, pagina vuota !

//*es: quando utente non ha assistiti, quando non ha fatto compilazioni, quando non ci sono news o toturial disponibili. . .

class EmptyPage extends StatelessWidget {
  final String title;
  final String? btnText;
  final void Function()? onBtnPressed;
  const EmptyPage({
    Key? key,
    required this.title,
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
                  image: AssetImage("assets/empty.png"),
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

  Widget _buildText() => Text(title);
}
