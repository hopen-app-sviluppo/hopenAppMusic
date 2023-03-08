//ogni elemento del form ha un tipo => in base al tipo ho una grafica diversa
enum FormElementType {
  //single Line Text
  text,
  //area di testo ma inserendo i numeri
  number,
  //area di testo più grande
  textarea,
  //scelta di molteplici valori
  checkbox,
  //tra una serie di valori posso selezionarne al max 1
  radio,
  //è un dropdown => scelgo un valori tra multipli
  select,
  //2 aree di testo => first - last
  simple_name,
  //scelgo giorno - mese - anno
  //* è del tipo 2022-09-14 (capire differenza tra questa ed europe_date) :O
  date,
  //scelgo ora minuti (AM - PM)
  //* è del tipo 11:30:00 => ora:minuti:secondi
  time,
  //area di testo in cui inserisco il numero di telefono
  phone,
  //6 aree di testo => da vedere su machform
  address,
  //area di testo in cui inserisco un url => https:
  url,
  //2 aree di testo, 1 per gli euro, 1 per i centesimi
  money,
  //area di testo in cui inserire email
  email,
  //sulle righe ho le domande, sulle colonne ho i radio button => per ogni riga ho 1 possibile risposta (controllare il db perchè per ogni riga mi prende un type)
  matrix,
  //permette di inserire dei file
  file,
  //testo con sopra una linea separatoria visibile (è un testo per dividere sezioni)
  section,
  //Quando trovo questo in teoria gli elementi dopo vanno su un'altra pagina :O
  page_break,
  //area in cui firmare con penna
  signature,
  //simile a file
  media,
  //*è del tipo 2022-09-14
  europe_date,
}

extension FormElementTypeFunctions on FormElementType {
  //converto stringa a Enum
  static FormElementType convertStringToType(String type) {
    switch (type) {
      case 'text':
        return FormElementType.text;
      case 'number':
        return FormElementType.number;
      case 'textarea':
        return FormElementType.textarea;
      case 'checkbox':
        return FormElementType.checkbox;
      case 'radio':
        return FormElementType.radio;
      case 'select':
        return FormElementType.select;
      case 'simple_name':
        return FormElementType.simple_name;
      case 'date':
        return FormElementType.date;
      case 'time':
        return FormElementType.time;
      case 'phone':
        return FormElementType.phone;
      case 'address':
        return FormElementType.address;
      case 'url':
        return FormElementType.url;
      case 'money':
        return FormElementType.money;
      case 'email':
        return FormElementType.email;
      case 'matrix':
        return FormElementType.matrix;
      case 'file':
        return FormElementType.file;
      case 'section':
        return FormElementType.section;
      case 'page_break':
        return FormElementType.page_break;
      case 'signature':
        return FormElementType.signature;
      case 'media':
        return FormElementType.media;
      case 'europe_date':
        return FormElementType.europe_date;
      //!In teoria non dovrebbe venire su default, ho messo tutte le possibili varianti
      default:
        return FormElementType.text;
    }
  }

  //converto enum a Stringa (per salvare valore nel DB)
  static String convertTypeToString(FormElementType type) {
    switch (type) {
      case FormElementType.text:
        return 'text';
      case FormElementType.number:
        return 'number';
      case FormElementType.textarea:
        return 'textarea';
      case FormElementType.checkbox:
        return 'checkbox';
      case FormElementType.radio:
        return 'radio';
      case FormElementType.select:
        return 'select';
      case FormElementType.simple_name:
        return 'simple_name';
      case FormElementType.date:
        return 'date';
      case FormElementType.time:
        return 'time';
      case FormElementType.phone:
        return 'phone';
      case FormElementType.address:
        return 'address';
      case FormElementType.url:
        return 'url';
      case FormElementType.money:
        return 'money';
      case FormElementType.email:
        return 'email';
      case FormElementType.matrix:
        return 'matrix';
      case FormElementType.file:
        return 'file';
      case FormElementType.section:
        return 'section';
      case FormElementType.page_break:
        return 'page_break';
      case FormElementType.signature:
        return 'signature';
      case FormElementType.media:
        return 'media';
      case FormElementType.europe_date:
        return 'europe_date';
    }
  }
}


/*

        case 'text':
      return FormElementType.text;
        case 'number':
      return FormElementType.number;
        case 'textarea':
      return FormElementType.textarea;
        case 'checkbox':
      return FormElementType.checkbox;


        case 'radio':
      return FormElementType.radio;
        case 'select':
      return FormElementType.select;
        case 'simple_name':
      return FormElementType.simple_name;


        case 'date':
      return FormElementType.date;

        case 'time':
      return FormElementType.time;


        case 'phone':
      return FormElementType.phone;

        case 'address':
      return FormElementType.address;

        case 'url':
      return FormElementType.url;

        case 'money':
      return FormElementType.money;

        case 'email':
      return FormElementType.email;

        case 'matrix':
      return FormElementType.matrix;

        case 'file':
      return FormElementType.file;


        case 'section':
      return FormElementType.section;

        case 'page_break':
      return FormElementType.page_break;

        case 'signature':
      return FormElementType.signature;


        case 'media':
      return FormElementType.media;

        case 'europe_date':
      return FormElementType.europeDate;
    }

*/