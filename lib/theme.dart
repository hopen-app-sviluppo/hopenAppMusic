import 'package:flutter/material.dart';

class AppTheme {
  //palette app

//tutti i colori vengono gestiti in modo centralizzato da questo punto
  static ThemeData mainTheme() => ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        primaryColor: MainColor.primaryColor,
        canvasColor: MainColor.primaryColor,
        fontFamily: 'Roboto',
        typography: Typography.material2018(),
        appBarTheme: const AppBarTheme(
          backgroundColor: MainColor.secondaryColor,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          type: BottomNavigationBarType.fixed,
          backgroundColor: MainColor.secondaryColor,
          elevation: 10.0,
          selectedItemColor: MainColor.primaryColor,
        ),
        textTheme: _buildTextTheme2(),
        cardTheme: const CardTheme(color: Colors.white),
        elevatedButtonTheme: _buildElevatedBtnTheme(),
        textButtonTheme: _buildTextBtnTheme(),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      );

  // definisco i colori per i vari tipi di testo
  static TextTheme _buildTextTheme2() {
    return const TextTheme(
      //* colore dell'hint text dei textField
      bodyText1: TextStyle(color: MainColor.primaryColor),
      //* colore del testo del body
      bodyText2: TextStyle(color: MainColor.textColor),
      caption: TextStyle(color: Colors.brown),
      button: TextStyle(color: Colors.redAccent),
      overline: TextStyle(color: Colors.purpleAccent),
    );
  }

//TODO: Cambiare il testo del textField da bianco a blu
//tema per gli elevated button
  static _buildElevatedBtnTheme() => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: MainColor.secondaryAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),

          // maximumSize: Size(300, 350),
        ),
      );

  static _buildTextBtnTheme() => TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: MainColor.textColor,
        ),
      );
}

extension MainColor on Colors {
  static const primaryColor =
      Color(0XFF0f386e); //Color.fromRGBO(17, 62, 123, 0.9);
  //static const secondaryColor = Color.fromRGBO(110, 201, 17, 0.9);
  static const secondaryColor = Color(0XFF6EC911);
  static const secondaryAccentColor = Color.fromRGBO(0, 208, 132, 0.9);
  static const redColor = Color(0XFFFF6666); //fromRGBO(255, 102, 102, 1.0);
  static const textColor = Colors.white;
  static const accentColor = Color.fromRGBO(242, 233, 220, 1.0);
  static const buttonColor = Color.fromRGBO(6, 147, 227, 1.0);
}
