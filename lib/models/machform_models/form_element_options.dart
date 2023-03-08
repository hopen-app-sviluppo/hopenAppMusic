import '../../helpers.dart';

class FormElementsOptions {
  final int aeoId;
  final int formId;
  final int elementId;
  final int optionId;
  final int position;
  final String? option;
  final bool optionIsDefault;
  final bool optionIsHidden;
  final bool live;

  FormElementsOptions({
    required this.aeoId,
    required this.formId,
    required this.elementId,
    required this.optionId,
    required this.position,
    this.option,
    required this.optionIsDefault,
    required this.optionIsHidden,
    required this.live,
  });

//converto stringhe in intero e stringhe in booleani
  FormElementsOptions.fromSocialNetwork(Map<String, dynamic> json)
      : aeoId = int.parse(json['aeo_id']),
        formId = int.parse(json['form_id']),
        elementId = int.parse(json['element_id']),
        optionId = int.parse(json['option_id']),
        position = int.parse(json['position']),
        option = json['option'],
        optionIsDefault = formatStringToBool(json['option_is_default']),
        optionIsHidden = formatStringToBool(json['option_is_hidden']),
        live = formatStringToBool(json['live']);

  FormElementsOptions.fromInternalDB(Map<String, dynamic> json)
      : aeoId = json['aeo_id'],
        formId = json['form_id'],
        elementId = json['element_id'],
        optionId = json['option_id'],
        position = json['position'],
        option = json['option'],
        optionIsDefault = formatIntToBool(json['option_is_default']),
        optionIsHidden = formatIntToBool(json['option_is_hidden']),
        live = formatIntToBool(json['live']);

  /*

  FormElementsOptions.formSocialNetwork(Map<String, dynamic> json) {
    print("SONO ARRIVATOOOO ALL OPZIONEEEEE");
    aeoId = json['aeo_id'];
    formId = json['form_id'];
    elementId = json['element_id'];
    optionId = json['option_id'];
    position = json['position'];
    option = json['option'];
    optionIsDefault = formatIntToBool(json['option_is_default']);
    optionIsHidden = formatIntToBool(json['option_is_hidden']);
    live = formatIntToBool(json['live']);
  }


  */

//converto date in stringhe e booleani in interi
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['aeo_id'] = aeoId;
    _data['form_id'] = formId;
    _data['element_id'] = elementId;
    _data['option_id'] = optionId;
    _data['position'] = position;
    _data['option'] = option;
    _data['option_is_default'] = formatBoolToInt(optionIsDefault);
    _data['option_is_hidden'] = formatBoolToInt(optionIsHidden);
    _data['live'] = formatBoolToInt(live);
    return _data;
  }
}

/*

  aeo_id,
  form_id,
  element_id,
  option_id,
  position,
  option,
  option_is_default,
  option_is_hidden,
  live,


*/