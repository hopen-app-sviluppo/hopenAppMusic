import 'package:flutter/material.dart';

//sta sul profilo utente, profilo assistito, pagina credenziali utente, pagina grafici assistito
class ImmagineProfilo extends StatelessWidget {
  final String? sigla;
  final String? avatar;
  final Color backgroundColor;
  final double? width;
  final double? height;
  const ImmagineProfilo({
    Key? key,
    this.sigla,
    this.avatar,
    this.width,
    this.height,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width * 0.25,
      height: height ?? MediaQuery.of(context).size.width * 0.25,
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        backgroundImage: avatar != null ? NetworkImage(avatar!) : null,
        child: sigla != null
            ? FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  sigla!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
