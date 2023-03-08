import 'package:flutter/material.dart';

//! all'avvio dell'app calcolo le dimensioni dello schermo e attribuisco a tutti i testi - icone le dimensioni
//! in questo modo mi evito di chiamare su ogni pagina - widget - componente le dimensioni dei testi - icone - ecc., gestisco tutto dal theme !

//! da controllare: utente non può girare il telefono e andare in landscape (chiaramente)!
//! ma se potesse ruotarlo? le dimensioni del teso e icone rimarrebbero le stesse di prima

//provare ad usare expanded - fractionally sizedBox e fittedBox per rendere tutto automatico

class SizeConfig {
  //larghezza schermo
  final double screenWidth;

  //altezza schermo
  final double screenHeight;

  //dalla larghezza totale tolgo le dimensioni a sx e a dx => ottengo una Safe Area (area sicura dove poter lavorare)
  final double _safeAreaHorizontal;

  //dall'altezza tolgo le dimensioni della barra in alto, e la barra in basso (su iphone è presente)
  final double _safeAreaVertical;

  //divido la larghezza del dispositivo in 100 blocchi
  late final double blockSizeHorizontal;

  //divido l'altezza del dispositivo in 100 blocchi
  late final double blockSizeVertical;

  //* 100 blocchi formano l'area sicura orizzontale
  late final double safeBlockHorizontal;

  //* 100 blocchi formano l'area sicura verticale
  late final double safeBlockVertical;

  //dimensioni testo
  late final double fontSize;
  //dimensioni icone
  late final double iconSize;

  SizeConfig(MediaQueryData data)
      : screenHeight = data.size.height,
        screenWidth = data.size.width,
        _safeAreaHorizontal = data.padding.left + data.padding.right,
        _safeAreaVertical = data.padding.top + data.padding.bottom {
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
    fontSize = safeBlockHorizontal * 3.7;
    iconSize = getIconSize();
  }

  double getIconSize() {
    //se è un mobile
    if (screenWidth < 800) {
      return 24.0;
      //se è un tablet (Screen Width > 800 && < 1200)
    } else {
      return 40.0;
    }
  }

//* altezza Dei TextField (Campi dove utente scrive testo)
  double getTextFieldHeight() {
    if (screenWidth < 800) {
      return safeBlockVertical * 9;
    } else {
      return safeBlockVertical * 9;
    }
  }
}
