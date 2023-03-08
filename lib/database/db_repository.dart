import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as windows_db;

//* gestisco database (creo, backup, ecc)

class DbRepository {
  static final DbRepository instance = DbRepository();
  static Database? _database;
  final _databaseName = 'music.db';
  final _databaseVersion = 1;

//torna il database corrente, se non esiste lo creo
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await createInternalDb(createDb: true);
    return _database!;
  }

//funzione usata all'avvio dell'app (se l'app è installata allora cerco nel backup se c'è un database salvato)
//riprendo db se: Era stato fatto un backup in precedenza. Utente da i permessi per ottenere il file dalla memoria interna
  Future<void> initializeDatabase() async {
    //* Path differente se sto su windows
    final String dbPath = await takeDbPath();
    final String path = join(dbPath, _databaseName);
    //* se il database esiste già allora
    if (await databaseExists(path)) {
      _database = await createInternalDb(path: path, createDb: false);
      return;
    }
    //* il Db interno non esiste, allora controllo se era stato fatto un Backup in precedenza
    final backUpDir = await getExternalDir();
    File source = File(
      join(backUpDir?.path ?? "backUpDirectoryDoesnExists", _databaseName),
    );
    try {
      //se backUp del db non esiste, allora l'utente accede per la prima volta nell'app, e lo creo da zero
      if (!await source.exists()) {
        //  print("il file nel path ${source.path} non esisteee");
        //* così la chiamata produce errore => mando utente su pagina di benvenuto
        throw ("Benvenuto nell'app !");
      }
      // print("il file nel path ${source.path}  esisteee");
      //* BACKup esiste !

      await checkStoragePermission();
      //copio nel path del DB interno il File di Backup
      //* print("copio il file che sta in $source su  $path");
      final dir = Directory(dbPath);

      await dir.create(recursive: true);
      await source.copy(path);

      _database = await createInternalDb(path: path, createDb: false);
      return;
    } catch (error) {
      print("errore: $error");
      _database = await createInternalDb(
        path: path,
        createDb: true,
      );
      rethrow;
    }
  }

//* Creo il db interno (sia per windows, che per android - IOS)
  Future<Database> createInternalDb({
    String? path,
    bool createDb = false,
  }) async {
    //* ottengo il Path
    final String dbPath = path ?? await takeDbPath();

    //* Apro connessione db, lo creo solo se non esiste gia
    if (Platform.isWindows) {
      return await windows_db.databaseFactoryFfi.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: _databaseVersion,
          onCreate: createDb ? _createDb : null,
        ),
      );
    } else {
      return await openDatabase(
        dbPath,
        version: _databaseVersion,
        onCreate: createDb ? _createDb : null,
      );
    }
  }

  //? Per creare una directory in cui i file non vengano cancellati in seguito alla disinstallazione dell'app, servono i permessi di accedere ad una memoria esterna all'app !

  Future<void> createDbBackup() async {
    try {
      //permessi di accedere alla memoria interna
      // await checkStoragePermission();
      await checkExternalStoragePermission();
      //permessi di lettura scrittura concessi !
      final dbFolder = await takeDbPath();
      final source = File(join(dbFolder, _databaseName));

      //directory in cui salverò il file di Backup
      final Directory? dirCopyTo = await getExternalDir();
      if (dirCopyTo == null) {
        throw ("Errore nel trovare la directory");
      }
      //print("directory di BackUp non esiste");
      //! questi permessi sono molto sensibili (entri dove voglio nel dispositivo dell'utente)
      //! ESISTE UN BACKUP AUTOMATICO DA ANDROID 6.0 IN POI (SUL MANIFEST INSERISCO ALLOWBACKUP:TRUE E MI MANDA I FILE SUL DRIVE DELL'UTENTE)
      //! CI sono vari requisiti da soffisfare (utente deve avè google acc, e altre cose. . . in futuro da rivedere)
      //creo la directory (per questo servono i permessi di externalStorage)
      await dirCopyTo.create(recursive: true);
      // il percorso dove salverò il file di backUp (su Windows è C:\Users\andre\Downloads\music.db)
      final newPath = join(dirCopyTo.path, _databaseName);
      //copio il file in quella directory, il nome sarà music.db
      await source.copy(newPath);
    } catch (error) {
      rethrow;
    }
  }

  //* torna il path del DB (windows, android-ios)
  Future<String> takeDbPath() async {
    late String dbPath;
    if (Platform.isWindows) {
      //uso altra libreria Sqflite per windows
      windows_db.sqfliteFfiInit();
      // *questo sta su C:\Users\andre\StudioProjects\music\.dart_tool\sqflite_common_ffi\databases, ma non funziona in release mode
      // dbPath =  await windows_db.databaseFactoryFfi.getDatabasesPath();
      //* questo sta su: C:\Users\andre\AppData\Roaming\it.hopenstartup.www\music
      dbPath = (await getApplicationSupportDirectory()).path;
    } else {
      dbPath = await getDatabasesPath();
      //se platform è android, dbPath è
    }
    return dbPath;
  }

//permessi nel leggere - scrivere nella memoria interna
  Future<void> checkStoragePermission() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      //richiedo i permessi
      final userPermission = await Permission.storage.request();
      if (!userPermission.isGranted) {
        throw ("Permessi non Concessi !");
      }
    }
  }

  //permessi nel creare directory nella memoria esterna all'app
  Future<void> checkExternalStoragePermission() async {
    final status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      //richiedo i permessi
      final userPermission = await Permission.manageExternalStorage.request();
      if (!userPermission.isGranted) {
        throw ("Permessi non Concessi !");
      }
    }
  }

//ottengo la directory di download
//su windows => C:\Users\andre\Downloads
//su android => storage/emulated/0/Sqlite Backup
  Future<Directory?> getExternalDir() async {
    if (Platform.isWindows) {
      return await getDownloadsDirectory();
    }
    if (Platform.isAndroid) {
      return Directory("storage/emulated/0/Sqlite Backup");
    }
    //IOS e macOS????
    //per macOS forse va bene la stessa per windows
    return null;
  }

//creo Database vuoto !
  Future<void> _createDb(Database db, int version) async {
    //* Creo utente e pazienti!
    //print("ecco il db: $db");
    await db.execute('''
          CREATE TABLE IF NOT EXISTS user (
            user_id INTEGER PRIMARY KEY,
            first_name TEXT,
            last_name TEXT,
            email TEXT,
            avatar TEXT,
            gender TEXT,
            token TEXT,
            phone_number TEXT, 
            city TEXT, 
            state TEXT, 
            company TEXT, 
            partita_iva TEXT, 
            attivita TEXT , 
            username TEXT,
            num_pazienti INTEGER,
            feedback_inviati INTEGER
          )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS cliente (
            client_id INTEGER PRIMARY KEY AUTOINCREMENT,
            client_name TEXT,
            client_cognome TEXT,
            client_codice_fiscale TEXT,
            client_sesso TEXT,
            client_cittadinanza TEXT,
            client_data_nascita TEXT,
            client_data_decesso TEXT,
            client_stato_civile TEXT,
            client_condizione_professionale TEXT,
            client_istruzione TEXT,
            client_professione TEXT,
            client_comune_nascita TEXT,
            client_state TEXT,
            client_asl_appartenenza TEXT,
            client_provincia_nascita TEXT,
            client_phone TEXT,
            client_phone2 TEXT,
            client_phone3 TEXT,
            client_phone4 TEXT,
            client_email TEXT,
            client_email_pec TEXT,
            client_address_1 TEXT,
            client_address_2 TEXT,
            client_city TEXT,
            client_country TEXT,
            client_residenza_cap TEXT,
            client_residenza_state TEXT,
            client_domicilio_address_1 TEXT,
            client_domicilio_address_2 TEXT,
            client_domicilio_city TEXT,
            client_domicilio_country TEXT,
            client_domicilio_cap TEXT,
            client_domicilio_state TEXT,
            user_id INTEGER NOT NULL,
            FOREIGN KEY (user_id) REFERENCES user (id) 
          )
          ''');

    //* tabella per i MachForm

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ap_forms(
        form_id INTEGER PRIMARY KEY AUTOINCREMENT,
        creator_id INTEGER NOT NULL,
        form_name TEXT,
        form_description TEXT,
        form_name_hide INTEGER NOT NULL,
        form_tags TEXT,
        form_email TEXT,
        form_redirect TEXT,
        form_redirect_enable INTEGER NOT NULL,
        form_success_message TEXT,
        form_disabled_message TEXT,
        form_password TEXT,
        form_unique_ip INTEGER NOT NULL,
        form_unique_ip_maxcount INTEGER NOT NULL,
        form_unique_ip_period TEXT NOT NULL,
        form_frame_height INTEGER,
        form_has_css INTEGER NOT NULL,
        form_captcha INTEGER NOT NULL,
        form_captcha_type TEXT NOT NULL,
        form_active INTEGER NOT NULL,
        form_theme_id INTEGER NOT NULL,
        form_review INTEGER NOT NULL,
        form_resume_enable INTEGER NOT NULL,
        form_resume_subject TEXT,
        form_resume_content TEXT,
        form_resume_from_name TEXT,
        form_resume_from_email_address TEXT,
        form_custom_script_enable INTEGER NOT NULL,
        form_custom_script_url TEXT,
        form_limit_enable INTEGER NOT NULL,
        form_limit INTEGER NOT NULL,
        form_label_alignment TEXT NOT NULL,
        form_language TEXT,
        form_page_total INTEGER NOT NULL,
        form_lastpage_title TEXT,
        form_submit_primary_text TEXT NOT NULL,
        form_submit_secondary_text TEXT NOT NULL,
        form_submit_primary_img TEXT,
        form_submit_secondary_img TEXT,
        form_submit_use_image INTEGER NOT NULL,
        form_review_primary_text TEXT NOT NULL,
        form_review_secondary_text TEXT NOT NULL,
        form_review_primary_img TEXT,
        form_review_secondary_img TEXT,
        form_review_use_image INTEGER NOT NULL,
        form_review_title TEXT,
        form_review_description TEXT,
        form_pagination_type TEXT NOT NULL,
        form_schedule_enable INTEGER NOT NULL,
        form_schedule_start_date TEXT,
        form_schedule_end_date TEXT,
        form_schedule_start_hour TEXT,
        form_schedule_end_hour TEXT,
        form_approval_enable INTEGER NOT NULL,
        form_created_date TEXT,
        form_created_by INTEGER,
        esl_enable INTEGER NOT NULL,
        esl_from_name TEXT,
        esl_from_email_address TEXT,
        esl_bcc_email_address TEXT,
        esl_replyto_email_address TEXT,
        esl_subject TEXT, 
        esl_content TEXT,
        esl_plain_text INTEGER NOT NULL,
        esl_pdf_enable INTEGER NOT NULL,
        esl_pdf_content TEXT,
        esr_enable INTEGER NOT NULL,
        esr_email_address TEXT,
        esr_from_name TEXT,
        esr_from_email_address TEXT,
        esr_bcc_email_address TEXT,
        esr_replyto_email_address TEXT,
        esr_subject TEXT,
        esr_content TEXT,
        esr_plain_text INTEGER,
        esr_pdf_enable INTEGER NOT NULL,
        esr_pdf_content TEXT,
        payment_enable_merchant INTEGER NOT NULL,
        payment_merchant_type TEXT NOT NULL,
        payment_paypal_email TEXT,
        payment_paypal_language TEXT NOT NULL,
        payment_currency TEXT NOT NULL,
        payment_show_total INTEGER NOT NULL,
        payment_total_location TEXT NOT NULL,
        payment_enable_recurring INTEGER NOT NULL,
        payment_recurring_cycle INTEGER NOT NULL,
        payment_recurring_unit TEXT NOT NULL,
        payment_enable_trial INTEGER NOT NULL,
        payment_trial_period INTEGER NOT NULL,
        payment_trial_unit TEXT NOT NULL,
        payment_trial_amount REAL NOT NULL,
        payment_enable_setupfee INTEGER NOT NULL,
        payment_setupfee_amount REAL NOT NULL,
        payment_price_type TEXT NOT NULL,
        payment_price_amount REAL NOT NULL,
        payment_price_name TEXT,
        payment_stripe_live_secret_key TEXT,
        payment_stripe_live_public_key TEXT,
        payment_stripe_test_secret_key TEXT,
        payment_stripe_test_public_key TEXT,
        payment_stripe_enable_test_mode INTEGER NOT NULL,
        payment_stripe_enable_receipt INTEGER NOT NULL,
        payment_stripe_receipt_element_id INTEGER,
        payment_stripe_enable_payment_request_button INTEGER NOT NULL,
        payment_stripe_account_country TEXT,
        payment_paypal_rest_live_clientid TEXT,
        payment_paypal_rest_live_secret_key TEXT,
        payment_paypal_rest_test_clientid TEXT,
        payment_paypal_rest_test_secret_key TEXT,
        payment_paypal_rest_enable_test_mode INTEGER NOT NULL,
        payment_authorizenet_live_apiloginid TEXT,
        payment_authorizenet_live_transkey TEXT,
        payment_authorizenet_test_apiloginid TEXT,
        payment_authorizenet_test_transkey TEXT,
        payment_authorizenet_enable_test_mode INTEGER NOT NULL,
        payment_authorizenet_save_cc_data INTEGER NOT NULL,
        payment_authorizenet_enable_email INTEGER NOT NULL,
        payment_authorizenet_email_element_id INTEGER,
        payment_braintree_live_merchant_id TEXT,
        payment_braintree_live_public_key TEXT,
        payment_braintree_live_private_key TEXT,
        payment_braintree_live_encryption_key TEXT,
        payment_braintree_test_merchant_id TEXT,
        payment_braintree_test_public_key TEXT,
        payment_braintree_test_private_key TEXT,
        payment_braintree_test_encryption_key TEXT,
        payment_braintree_enable_test_mode INTEGER NOT NULL,
        payment_paypal_enable_test_mode INTEGER NOT NULL,
        payment_enable_invoice INTEGER NOT NULL,
        payment_invoice_email TEXT,
        payment_delay_notifications INTEGER NOT NULL,
        payment_ask_billing INTEGER NOT NULL,
        payment_ask_shipping INTEGER NOT NULL,
        payment_enable_tax INTEGER NOT NULL,
        payment_tax_rate REAL NOT NULL,
        payment_enable_discount INTEGER NOT NULL,
        payment_discount_type TEXT NOT NULL,
        payment_discount_amount REAL NOT NULL,
        payment_discount_code TEXT,
        payment_discount_element_id INTEGER,
        payment_discount_max_usage INTEGER NOT NULL,
        payment_discount_expiry_date TEXT,
        logic_field_enable INTEGER NOT NULL,
        logic_page_enable INTEGER NOT NULL,
        logic_email_enable INTEGER NOT NULL,
        logic_webhook_enable INTEGER NOT NULL,
        logic_success_enable INTEGER NOT NULL,
        webhook_enable INTEGER NOT NULL,
        webhook_url TEXT,
        webhook_method TEXT NOT NULL,
        form_encryption_enable INTEGER NOT NULL,
        form_encryption_public_key TEXT,
        FOREIGN KEY (creator_id) REFERENCES user (id)
      )
    ''');

    //* tabella per gli elementi di un form

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ap_form_elements(
        element_id INTEGER NOT NULL,
        form_id INTEGER NOT NULL,
        element_title TEXT,
        element_guidelines TEXT,
        element_size TEXT NOT NULL,
        element_is_required INTEGER NOT NULL,
        element_is_unique INTEGER NOT NULL,
        element_is_readonly INTEGER NOT NULL,
        element_is_private INTEGER NOT NULL,
        element_is_encrypted INTEGER NOT NULL,
        element_type TEXT,
        element_position INTEGER NOT NULL,
        element_default_value TEXT,
        element_enable_placeholder INTEGER NOT NULL,
        element_constraint TEXT,
        element_total_child INTEGER NOT NULL,
        element_css_class TEXT NOT NULL,
        element_range_min INTEGER NOT NULL,
        element_range_max INTEGER NOT NULL,
        element_range_limit_by TEXT NOT NULL,
        element_status INTEGER NOT NULL,
        element_choice_columns INTEGER NOT NULL,
        element_choice_has_other INTEGER NOT NULL,
        element_choice_other_label TEXT,
        element_choice_limit_rule TEXT NOT NULL,
        element_choice_limit_qty INTEGER NOT NULL,
        element_choice_limit_range_min INTEGER NOT NULL,
        element_choice_limit_range_max INTEGER NOT NULL,
        element_choice_max_entry INTEGER NOT NULL,
        element_time_showsecond INTEGER NOT NULL,
        element_time_24hour INTEGER NOT NULL,
        element_address_hideline2 INTEGER NOT NULL,
        element_address_us_only INTEGER NOT NULL,
        element_date_enable_range INTEGER NOT NULL,
        element_date_range_min TEXT,
        element_date_range_max TEXT,
        element_date_enable_selection_limit INTEGER NOT NULL,
        element_date_selection_max INTEGER NOT NULL,
        element_date_past_future TEXT NOT NULL,
        element_date_disable_past_future INTEGER NOT NULL,
        element_date_disable_dayofweek INTEGER NOT NULL,
        element_date_disabled_dayofweek_list TEXT,
        element_date_disable_specific INTEGER NOT NULL,
        element_date_disabled_list TEXT,
        element_file_enable_type_limit INTEGER NOT NULL,
        element_file_block_or_allow TEXT NOT NULL,
        element_file_type_list TEXT,
        element_file_as_attachment INTEGER NOT NULL,
        element_file_enable_advance INTEGER NOT NULL,
        element_file_auto_upload INTEGER NOT NULL,
        element_file_enable_multi_upload INTEGER NOT NULL,
        element_file_max_selection INTEGER NOT NULL,
        element_file_enable_size_limit INTEGER NOT NULL,
        element_file_size_max INTEGER,
        element_matrix_allow_multiselect INTEGER NOT NULL,
        element_matrix_parent_id INTEGER NOT NULL,
        element_number_enable_quantity INTEGER NOT NULL,
        element_number_quantity_link TEXT,
        element_section_display_in_email INTEGER NOT NULL,
        element_section_enable_scroll INTEGER NOT NULL,
        element_submit_use_image INTEGER NOT NULL,
        element_submit_primary_text TEXT NOT NULL,
        element_submit_secondary_text TEXT NOT NULL,
        element_submit_primary_img TEXT,
        element_submit_secondary_img TEXT,
        element_page_title TEXT,
        element_page_number INTEGER NOT NULL,
        element_text_default_type TEXT NOT NULL,
        element_text_default_length INTEGER NOT NULL,
        element_text_default_random_type TEXT NOT NULL,
        element_text_default_prefix TEXT,
        element_text_default_case TEXT NOT NULL,
        element_email_enable_confirmation INTEGER NOT NULL,
        element_email_confirm_field_label TEXT,
        element_media_type TEXT NOT NULL,
        element_media_image_src TEXT,
        element_media_image_width INTEGER,
        element_media_image_height INTEGER,
        element_media_image_alignment TEXT NOT NULL,
        element_media_image_alt TEXT,
        element_media_image_href TEXT,
        element_media_display_in_email INTEGER NOT NULL,
        element_media_video_src TEXT,
        element_media_video_size TEXT NOT NULL,
        element_media_video_muted INTEGER NOT NULL,
        element_media_video_caption_file TEXT,
        element_excel_cell TEXT  NOT NULL,
        PRIMARY KEY (form_id, element_id),
        FOREIGN KEY (form_id) REFERENCES ap_form (form_id)
      )
    ''');

    //* tabella per le opzioni dwgli elementi del form => ap_element_options

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ap_element_options(
        aeo_id INTEGER PRIMARY KEY,
        option_id INTEGER,
        form_id INTEGER NOT NULL,
        element_id INTEGER NOT NULL,
        position INTEGER NOT NULL,
        option TEXT,
        option_is_default INTEGER NOT NULL,
        option_is_hidden INTEGER NOT NULL,
        live INTEGER NOT NULL,
        FOREIGN KEY (element_id) REFERENCES ap_form_elements (element_id),
        FOREIGN KEY (form_id) REFERENCES ap_form (form_id)
      )
    ''');

    //* tabella per salvare le compilazioni => form è la chiave esterna dell'id del form. form_id è la chiave esterna della compilazione.

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ap_forms_eseguiti(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        datetime TEXT,
        id_obiettivi TEXT,
        id_attivita TEXT,
        id_gruppo INTEGER,
        percentuale INTEGER,
        stato INTEGER,
        privato TEXT,
        id_form_parent INTEGER,
        id_form INTEGER,
        form INTEGER,
        id_operatore INTEGER,
        id_assistito INTEGER,
        FOREIGN KEY (form) REFERENCES ap_form (form_id),
        FOREIGN KEY (id_operatore) REFERENCES user (user_id),
        FOREIGN KEY (id_assistito) REFERENCES cliente (client_id)
      )
    ''');

    //* tabella per i form compilati
    await db.execute('''
          CREATE TABLE IF NOT EXISTS form_compilato (
            compilazione_id INTEGER PRIMARY KEY,
            user_id INTEGER,
            client_id INTEGER,
            client_name TEXT,
            client_cognome TEXT,
            creato_il TEXT,
            ultima_modifica TEXT,
            form_id INTEGER,
            form_name TEXT,
            score INTEGER,
            max_score INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE IF NOT EXISTS domanda(
            id INTEGER PRIMARY KEY,
            domanda_id INTEGER NOT NULL,
            sezione_id INTEGER NOT NULL,
            response TEXT NOT NULL,
            type TEXT NOT NULL,
            max_score INTEGER,
            compilazione_id INTEGER NOT NULL,
            FOREIGN KEY (compilazione_id) REFERENCES form_compilato (id)
          )
          ''');
    //? tabella in cui salvo i risultati delle compilazioni dei form di Musicoterapia
    await db.execute('''
          CREATE TABLE IF NOT EXISTS risultati_comp_musicoterapia(
            id INTEGER PRIMARY KEY,
            eta_musicale_02 REAL,
            eta_musicale_24 REAL,
            eta_musicale_46 REAL,
            sicuro REAL,
            ambivalente REAL,
            emotivo REAL,
            relazionale REAL,
            dentro REAL,
            razionale REAL,
            fianco REAL,
            intorno REAL,
            compilazione_id INTEGER NOT NULL,
            FOREIGN KEY (compilazione_id) REFERENCES form_compilato (id)
          )
          ''');
    //? DB per le risposte delle checkBox nei form
    /* await db.execute('''
          CREATE TABLE IF NOT EXISTS check_box_response(
            id INTEGER PRIMARY KEY,
            domanda_id INTEGER NOT NULL,
            sezione_id INTEGER NOT NULL,
            form_id INTEGER NOT NULL,
            compilazione_id INTEGER NOT NULL,
            position INTEGER NOT NULL,
            FOREIGN KEY (domanda_id) REFERENCES domanda (id)
          )
          ''');*/
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }

  //* metodi per creare tabella ap_form con relative colonne !

  String createColumns(Map<dynamic, dynamic> map) {
    String columns = 'id INTEGER PRIMARY KEY,';
    map.forEach((key, value) {
      var type;
      if (value is int) {
        type = 'INTEGER';
      } else if (value is String) {
        type = 'TEXT';
      } else if (value is double) {
        type = 'REAL';
      }else{
        type = 'TEXT';
      }
      columns += '$key $type, ';
    });
    columns +=
        "FOREIGN KEY (id_assistito) REFERENCES cliente (client_id), FOREIGN KEY (id_operatore) REFERENCES user (user_id)";
    return columns.endsWith(', ')
        ? columns.substring(0, columns.length - 2)
        : columns;
  }

  String createTable(
    String tableName,
    Map<dynamic, dynamic> map,
  ) {
    String columns = createColumns(map);
    String table = 'CREATE TABLE IF NOT EXISTS $tableName ($columns)';
    return table;
  }
}
