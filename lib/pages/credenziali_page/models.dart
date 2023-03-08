
//display text => testo visualizzato
// currentVal => valore nel db interno
// dbName => come si chiama nel Db


class CampoTestuale {
  final String displayText;
  String? currentVal;
  final String dbName;

  CampoTestuale({
    required this.displayText,
    required this.currentVal,
    required this.dbName,
  });

  void onValUpdate(String newVal) {
    currentVal = newVal;
  }

  Future<void> saveNewValToDb() async {
    //salvo currentVal nel database interno
  }
}
