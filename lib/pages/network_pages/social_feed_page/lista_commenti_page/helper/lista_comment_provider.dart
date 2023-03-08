import 'package:flutter/material.dart';

import '../../../../../models/social_models/comment.dart';

class ListaCommentiProvider with ChangeNotifier {
  //per aprire - chiduere la keyboar (se utente preme su rispondi commento si apre la keyboard)
  FocusNode focusNode = FocusNode();
  CommentoSocial? selectedComment;
  bool showCommentReplies = false;
  //di base è -1 => tutte le risposte ai commenti nascoste
  //ogni volta che voglio vedere risposte ad un commento, passo a sto valore un intero (id del commento)
  //così solo le risposte del commento con quell'id verranno visualizzate
  String showCommentIdReplies = "";
  CommentoPost? commentToReply;
  String? textFieldVal;

//quando utente vuole rispondere ad un commento
  void onFocusRequesting(CommentoPost comment) {
    focusNode.requestFocus();
    commentToReply = comment;
    notifyListeners();
  }

//quando utente chiude il box di risposta ad un commento
  void onUnfocus() {
    focusNode.unfocus();
    commentToReply = null;
    notifyListeners();
  }

//quando utente vuole mostrare le risposte ai commenti
  void showCommentReply(String commentId) {
    showCommentIdReplies = commentId;
    notifyListeners();
  }

//pulisco questo valore
  void clearCommentIdReply() {
    showCommentIdReplies = "";
    notifyListeners();
  }

  void clearTextFieldVal() {
    textFieldVal = null;
    notifyListeners();
  }

  void onTextFieldValUpdate(String? newVal) {
    textFieldVal = newVal;
    notifyListeners();
  }
}
