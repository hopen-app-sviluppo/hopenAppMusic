import 'package:music/models/user/internal_account.dart';
import 'package:music/models/user/social_account.dart';

class User {
  final int id;
  final SocialAccount socialAccount;
  final InternalAccount internalAccount;

  User({
    required this.id,
    required this.socialAccount,
    required this.internalAccount,
  });

  //todo: per risparmiare codice nell'UI, posso mettere qua delle get

  //es: int get id => internalAccount.id;

  //così anzichè scrivere ogni votlta user.internalAccount.id, scrivo solo user.id

  //e farlo per tutti i campi !

  @override
  String toString() => "user: id: $id, $socialAccount, $internalAccount";
}
