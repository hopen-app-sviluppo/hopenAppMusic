import 'package:music/helpers.dart';

import 'form_element_options.dart';
import 'form_element_type.dart';

class FormElements {
  final int formId;
  final int elementId;
  final String? elementTitle;
  final String? elementGuidelines;
  final String elementSize;
  final bool elementIsRequired;
  final bool elementIsUnique;
  final bool elementIsReadonly;
  final bool elementIsPrivate;
  final bool elementIsEncrypted;
  final FormElementType elementType;
  final int elementPosition;
  final String elementDefaultValue;
  final bool elementEnablePlaceholder;
  final String elementConstraint;
  final int elementTotalChild;
  final String elementCssClass;
  final int elementRangeMin;
  final int elementRangeMax;
  final String elementRangeLimitBy;
  final int elementStatus;
  final int elementChoiceColumns;
  final bool elementChoiceHasOther;
  final String? elementChoiceOtherLabel;
  final String elementChoiceLimitRule;
  final bool elementChoiceLimitQty;
  final bool elementChoiceLimitRangeMin;
  final bool elementChoiceLimitRangeMax;
  final bool elementChoiceMaxEntry;
  final bool elementTimeShowsecond;
  final bool elementTime_24hour;
  final bool elementAddressHideline2;
  final bool elementAddressUsOnly;
  final bool elementDateEnableRange;
  final DateTime? elementDateRangeMin;
  final DateTime? elementDateRangeMax;
  final bool elementDateEnableSelectionLimit;
  final bool elementDateSelectionMax;
  final String elementDatePastFuture;
  final bool elementDateDisablePastFuture;
  final bool elementDateDisableDayofweek;
  final String elementDateDisabledDayofweekList;
  final bool elementDateDisableSpecific;
  final String elementDateDisabledList;
  final bool elementFileEnableTypeLimit;
  final String elementFileBlockOrAllow;
  final String? elementFileTypeList;
  final bool elementFileAsAttachment;
  final bool elementFileEnableAdvance;
  final bool elementFileAutoUpload;
  final bool elementFileEnableMultiUpload;
  final int elementFileMaxSelection;
  final bool elementFileEnableSizeLimit;
  final int? elementFileSizeMax;
  final bool elementMatrixAllowMultiselect;
  final int elementMatrixParentId;
  final bool elementNumberEnableQuantity;
  final String? elementNumberQuantityLink;
  final bool elementSectionDisplayInEmail;
  final bool elementSectionEnableScroll;
  final bool elementSubmitUseImage;
  final String elementSubmitPrimaryText;
  final String elementSubmitSecondaryText;
  final String? elementSubmitPrimaryImg;
  final String? elementSubmitSecondaryImg;
  final String? elementPageTitle;
  final int elementPageNumber;
  final String elementTextDefaultType;
  final int elementTextDefaultLength;
  final String elementTextDefaultRandomType;
  final String? elementTextDefaultPrefix;
  final String elementTextDefaultCase;
  final bool elementEmailEnableConfirmation;
  final String? elementEmailConfirmFieldLabel;
  final String elementMediaType;
  final String? elementMediaImageSrc;
  final int? elementMediaImageWidth;
  final int? elementMediaImageHeight;
  final String elementMediaImageAlignment;
  final String? elementMediaImageAlt;
  final String? elementMediaImageHref;
  final bool elementMediaDisplayInEmail;
  final String? elementMediaVideoSrc;
  final String elementMediaVideoSize;
  final bool elementMediaVideoMuted;
  final String? elementMediaVideoCaptionFile;
  final String elementExcelCell;
  //non sempre un elemento ha delle opzioni, casomai sarà empty
  final List<FormElementsOptions> formElementsOptions;

  FormElements({
    required this.formId,
    required this.elementId,
    this.elementTitle,
    this.elementGuidelines,
    required this.elementSize,
    required this.elementIsRequired,
    required this.elementIsUnique,
    required this.elementIsReadonly,
    required this.elementIsPrivate,
    required this.elementIsEncrypted,
    required this.elementType,
    required this.elementPosition,
    required this.elementDefaultValue,
    required this.elementEnablePlaceholder,
    required this.elementConstraint,
    required this.elementTotalChild,
    required this.elementCssClass,
    required this.elementRangeMin,
    required this.elementRangeMax,
    required this.elementRangeLimitBy,
    required this.elementStatus,
    required this.elementChoiceColumns,
    required this.elementChoiceHasOther,
    this.elementChoiceOtherLabel,
    required this.elementChoiceLimitRule,
    required this.elementChoiceLimitQty,
    required this.elementChoiceLimitRangeMin,
    required this.elementChoiceLimitRangeMax,
    required this.elementChoiceMaxEntry,
    required this.elementTimeShowsecond,
    required this.elementTime_24hour,
    required this.elementAddressHideline2,
    required this.elementAddressUsOnly,
    required this.elementDateEnableRange,
    this.elementDateRangeMin,
    this.elementDateRangeMax,
    required this.elementDateEnableSelectionLimit,
    required this.elementDateSelectionMax,
    required this.elementDatePastFuture,
    required this.elementDateDisablePastFuture,
    required this.elementDateDisableDayofweek,
    required this.elementDateDisabledDayofweekList,
    required this.elementDateDisableSpecific,
    required this.elementDateDisabledList,
    required this.elementFileEnableTypeLimit,
    required this.elementFileBlockOrAllow,
    this.elementFileTypeList,
    required this.elementFileAsAttachment,
    required this.elementFileEnableAdvance,
    required this.elementFileAutoUpload,
    required this.elementFileEnableMultiUpload,
    required this.elementFileMaxSelection,
    required this.elementFileEnableSizeLimit,
    this.elementFileSizeMax,
    required this.elementMatrixAllowMultiselect,
    required this.elementMatrixParentId,
    required this.elementNumberEnableQuantity,
    this.elementNumberQuantityLink,
    required this.elementSectionDisplayInEmail,
    required this.elementSectionEnableScroll,
    required this.elementSubmitUseImage,
    required this.elementSubmitPrimaryText,
    required this.elementSubmitSecondaryText,
    this.elementSubmitPrimaryImg,
    this.elementSubmitSecondaryImg,
    this.elementPageTitle,
    required this.elementPageNumber,
    required this.elementTextDefaultType,
    required this.elementTextDefaultLength,
    required this.elementTextDefaultRandomType,
    this.elementTextDefaultPrefix,
    required this.elementTextDefaultCase,
    required this.elementEmailEnableConfirmation,
    this.elementEmailConfirmFieldLabel,
    required this.elementMediaType,
    this.elementMediaImageSrc,
    this.elementMediaImageWidth,
    this.elementMediaImageHeight,
    required this.elementMediaImageAlignment,
    this.elementMediaImageAlt,
    this.elementMediaImageHref,
    required this.elementMediaDisplayInEmail,
    this.elementMediaVideoSrc,
    required this.elementMediaVideoSize,
    required this.elementMediaVideoMuted,
    this.elementMediaVideoCaptionFile,
    required this.elementExcelCell,
    required this.formElementsOptions,
  });

//arrivano tutte stringhe
  FormElements.fromSocialNetwork(Map<String, dynamic> json)
      : formId = int.parse(json['form_id']),
        elementId = int.parse(json['element_id']),
        elementTitle = json['element_title'],
        elementGuidelines = json['element_guidelines'],
        elementSize = json['element_size'],
        elementIsRequired = formatStringToBool(json['element_is_required']),
        elementIsUnique = formatStringToBool(json['element_is_unique']),
        elementIsReadonly = formatStringToBool(json['element_is_readonly']),
        elementIsPrivate = formatStringToBool(json['element_is_private']),
        elementIsEncrypted = formatStringToBool(json['element_is_encrypted']),
        elementType =
            FormElementTypeFunctions.convertStringToType(json['element_type']),
        elementPosition = int.parse(json['element_position']),
        elementDefaultValue = json['element_default_value'],
        elementEnablePlaceholder =
            formatStringToBool(json['element_enable_placeholder']),
        elementConstraint = json['element_constraint'],
        elementTotalChild = int.parse(json['element_total_child']),
        elementCssClass = json['element_css_class'],
        elementRangeMin = int.parse(json['element_range_min']),
        elementRangeMax = int.parse(json['element_range_max']),
        elementRangeLimitBy = json['element_range_limit_by'],
        elementStatus = int.parse(json['element_status']),
        elementChoiceColumns = int.parse(json['element_choice_columns']),
        elementChoiceHasOther =
            formatStringToBool(json['element_choice_has_other']),
        elementChoiceOtherLabel = json['element_choice_other_label'],
        elementChoiceLimitRule = json['element_choice_limit_rule'],
        elementChoiceLimitQty =
            formatStringToBool(json['element_choice_limit_qty']),
        elementChoiceLimitRangeMin =
            formatStringToBool(json['element_choice_limit_range_min']),
        elementChoiceLimitRangeMax =
            formatStringToBool(json['element_choice_limit_range_max']),
        elementChoiceMaxEntry =
            formatStringToBool(json['element_choice_max_entry']),
        elementTimeShowsecond =
            formatStringToBool(json['element_time_showsecond']),
        elementTime_24hour = formatStringToBool(json['element_time_24hour']),
        elementAddressHideline2 =
            formatStringToBool(json['element_address_hideline2']),
        elementAddressUsOnly =
            formatStringToBool(json['element_address_us_only']),
        elementDateEnableRange =
            formatStringToBool(json['element_date_enable_range']),
        elementDateRangeMin =
            DateTime.tryParse(json['element_date_range_min'] ?? ''),
        elementDateRangeMax =
            DateTime.tryParse(json['element_date_range_max'] ?? ''),
        elementDateEnableSelectionLimit =
            formatStringToBool(json['element_date_enable_selection_limit']),
        elementDateSelectionMax =
            formatStringToBool(json['element_date_selection_max']),
        elementDatePastFuture = json['element_date_past_future'],
        elementDateDisablePastFuture =
            formatStringToBool(json['element_date_disable_past_future']),
        elementDateDisableDayofweek =
            formatStringToBool(json['element_date_disable_dayofweek']),
        elementDateDisabledDayofweekList =
            json['element_date_disabled_dayofweek_list'],
        elementDateDisableSpecific =
            formatStringToBool(json['element_date_disable_specific']),
        elementDateDisabledList = json['element_date_disabled_list'],
        elementFileEnableTypeLimit =
            formatStringToBool(json['element_file_enable_type_limit']),
        elementFileBlockOrAllow = json['element_file_block_or_allow'],
        elementFileTypeList = json['element_file_type_list'],
        elementFileAsAttachment =
            formatStringToBool(json['element_file_as_attachment']),
        elementFileEnableAdvance =
            formatStringToBool(json['element_file_enable_advance']),
        elementFileAutoUpload =
            formatStringToBool(json['element_file_auto_upload']),
        elementFileEnableMultiUpload =
            formatStringToBool(json['element_file_enable_multi_upload']),
        elementFileMaxSelection = int.parse(json['element_file_max_selection']),
        elementFileEnableSizeLimit =
            formatStringToBool(json['element_file_enable_size_limit']),
        elementFileSizeMax = int.tryParse(json['element_file_size_max'] ?? ''),
        elementMatrixAllowMultiselect =
            formatStringToBool(json['element_matrix_allow_multiselect']),
        elementMatrixParentId = int.parse(json['element_matrix_parent_id']),
        elementNumberEnableQuantity =
            formatStringToBool(json['element_number_enable_quantity']),
        elementNumberQuantityLink = json['element_number_quantity_link'],
        elementSectionDisplayInEmail =
            formatStringToBool(json['element_section_display_in_email']),
        elementSectionEnableScroll =
            formatStringToBool(json['element_section_enable_scroll']),
        elementSubmitUseImage =
            formatStringToBool(json['element_submit_use_image']),
        elementSubmitPrimaryText = json['element_submit_primary_text'],
        elementSubmitSecondaryText = json['element_submit_secondary_text'],
        elementSubmitPrimaryImg = json['element_submit_primary_img'],
        elementSubmitSecondaryImg = json['element_submit_secondary_img'],
        elementPageTitle = json['element_page_title'],
        elementPageNumber = int.parse(json['element_page_number']),
        elementTextDefaultType = json['element_text_default_type'],
        elementTextDefaultLength =
            int.parse(json['element_text_default_length']),
        elementTextDefaultRandomType = json['element_text_default_random_type'],
        elementTextDefaultPrefix = json['element_text_default_prefix'],
        elementTextDefaultCase = json['element_text_default_case'],
        elementEmailEnableConfirmation =
            formatStringToBool(json['element_email_enable_confirmation']),
        elementEmailConfirmFieldLabel =
            json['element_email_confirm_field_label'],
        elementMediaType = json['element_media_type'],
        elementMediaImageSrc = json['element_media_image_src'],
        elementMediaImageWidth =
            int.tryParse(json['element_media_image_width'] ?? ''),
        elementMediaImageHeight =
            int.tryParse(json['element_media_image_height'] ?? ''),
        elementMediaImageAlignment = json['element_media_image_alignment'],
        elementMediaImageAlt = json['element_media_image_alt'],
        elementMediaImageHref = json['element_media_image_href'],
        elementMediaDisplayInEmail =
            formatStringToBool(json['element_media_display_in_email']),
        elementMediaVideoSrc = json['element_media_video_src'],
        elementMediaVideoSize = json['element_media_video_size'],
        elementMediaVideoMuted =
            formatStringToBool(json['element_media_video_muted']),
        elementMediaVideoCaptionFile = json['element_media_video_caption_file'],
        elementExcelCell = json['element_excel_cell'],
        formElementsOptions = List.from(json['form_elements_options'])
            .map((e) => FormElementsOptions.fromSocialNetwork(e))
            .toList();

//qua arrivano i valori già codificati, quindi converto SOLO interi in booleani e stringhe in date
  FormElements.fromInternalDB(Map<String, dynamic> json)
      : formId = json['form_id'],
        elementId = json['element_id'],
        elementTitle = json['element_title'],
        elementGuidelines = json['element_guidelines'],
        elementSize = json['element_size'],
        elementIsRequired = formatIntToBool(json['element_is_required']),
        elementIsUnique = formatIntToBool(json['element_is_unique']),
        elementIsReadonly = formatIntToBool(json['element_is_readonly']),
        elementIsPrivate = formatIntToBool(json['element_is_private']),
        elementIsEncrypted = formatIntToBool(json['element_is_encrypted']),
        elementType =
            FormElementTypeFunctions.convertStringToType(json['element_type']),
        elementPosition = json['element_position'],
        elementDefaultValue = json['element_default_value'],
        elementEnablePlaceholder =
            formatIntToBool(json['element_enable_placeholder']),
        elementConstraint = json['element_constraint'],
        elementTotalChild = json['element_total_child'],
        elementCssClass = json['element_css_class'],
        elementRangeMin = json['element_range_min'],
        elementRangeMax = json['element_range_max'],
        elementRangeLimitBy = json['element_range_limit_by'],
        elementStatus = json['element_status'],
        elementChoiceColumns = json['element_choice_columns'],
        elementChoiceHasOther =
            formatIntToBool(json['element_choice_has_other']),
        elementChoiceOtherLabel = json['element_choice_other_label'],
        elementChoiceLimitRule = json['element_choice_limit_rule'],
        elementChoiceLimitQty =
            formatIntToBool(json['element_choice_limit_qty']),
        elementChoiceLimitRangeMin =
            formatIntToBool(json['element_choice_limit_range_min']),
        elementChoiceLimitRangeMax =
            formatIntToBool(json['element_choice_limit_range_max']),
        elementChoiceMaxEntry =
            formatIntToBool(json['element_choice_max_entry']),
        elementTimeShowsecond =
            formatIntToBool(json['element_time_showsecond']),
        elementTime_24hour = formatIntToBool(json['element_time_24hour']),
        elementAddressHideline2 =
            formatIntToBool(json['element_address_hideline2']),
        elementAddressUsOnly = formatIntToBool(json['element_address_us_only']),
        elementDateEnableRange =
            formatIntToBool(json['element_date_enable_range']),
        elementDateRangeMin =
            DateTime.tryParse(json['element_date_range_min'] ?? ''),
        elementDateRangeMax =
            DateTime.tryParse(json['element_date_range_max'] ?? ''),
        elementDateEnableSelectionLimit =
            formatIntToBool(json['element_date_enable_selection_limit']),
        elementDateSelectionMax =
            formatIntToBool(json['element_date_selection_max']),
        elementDatePastFuture = json['element_date_past_future'],
        elementDateDisablePastFuture =
            formatIntToBool(json['element_date_disable_past_future']),
        elementDateDisableDayofweek =
            formatIntToBool(json['element_date_disable_dayofweek']),
        elementDateDisabledDayofweekList =
            json['element_date_disabled_dayofweek_list'],
        elementDateDisableSpecific =
            formatIntToBool(json['element_date_disable_specific']),
        elementDateDisabledList = json['element_date_disabled_list'],
        elementFileEnableTypeLimit =
            formatIntToBool(json['element_file_enable_type_limit']),
        elementFileBlockOrAllow = json['element_file_block_or_allow'],
        elementFileTypeList = json['element_file_type_list'],
        elementFileAsAttachment =
            formatIntToBool(json['element_file_as_attachment']),
        elementFileEnableAdvance =
            formatIntToBool(json['element_file_enable_advance']),
        elementFileAutoUpload =
            formatIntToBool(json['element_file_auto_upload']),
        elementFileEnableMultiUpload =
            formatIntToBool(json['element_file_enable_multi_upload']),
        elementFileMaxSelection = json['element_file_max_selection'],
        elementFileEnableSizeLimit =
            formatIntToBool(json['element_file_enable_size_limit']),
        elementFileSizeMax = json['element_file_size_max'],
        elementMatrixAllowMultiselect =
            formatIntToBool(json['element_matrix_allow_multiselect']),
        elementMatrixParentId = json['element_matrix_parent_id'],
        elementNumberEnableQuantity =
            formatIntToBool(json['element_number_enable_quantity']),
        elementNumberQuantityLink = json['element_number_quantity_link'],
        elementSectionDisplayInEmail =
            formatIntToBool(json['element_section_display_in_email']),
        elementSectionEnableScroll =
            formatIntToBool(json['element_section_enable_scroll']),
        elementSubmitUseImage =
            formatIntToBool(json['element_submit_use_image']),
        elementSubmitPrimaryText = json['element_submit_primary_text'],
        elementSubmitSecondaryText = json['element_submit_secondary_text'],
        elementSubmitPrimaryImg = json['element_submit_primary_img'],
        elementSubmitSecondaryImg = json['element_submit_secondary_img'],
        elementPageTitle = json['element_page_title'],
        elementPageNumber = json['element_page_number'],
        elementTextDefaultType = json['element_text_default_type'],
        elementTextDefaultLength = json['element_text_default_length'],
        elementTextDefaultRandomType = json['element_text_default_random_type'],
        elementTextDefaultPrefix = json['element_text_default_prefix'],
        elementTextDefaultCase = json['element_text_default_case'],
        elementEmailEnableConfirmation =
            formatIntToBool(json['element_email_enable_confirmation']),
        elementEmailConfirmFieldLabel =
            json['element_email_confirm_field_label'],
        elementMediaType = json['element_media_type'],
        elementMediaImageSrc = json['element_media_image_src'],
        elementMediaImageWidth = json['element_media_image_width'],
        elementMediaImageHeight = json['element_media_image_height'],
        elementMediaImageAlignment = json['element_media_image_alignment'],
        elementMediaImageAlt = json['element_media_image_alt'],
        elementMediaImageHref = json['element_media_image_href'],
        elementMediaDisplayInEmail =
            formatIntToBool(json['element_media_display_in_email']),
        elementMediaVideoSrc = json['element_media_video_src'],
        elementMediaVideoSize = json['element_media_video_size'],
        elementMediaVideoMuted =
            formatIntToBool(json['element_media_video_muted']),
        elementMediaVideoCaptionFile = json['element_media_video_caption_file'],
        elementExcelCell = json['element_excel_cell'],
        formElementsOptions = List.from(json['form_elements_options'])
            .map((e) => FormElementsOptions.fromInternalDB(e))
            .toList();

/*

 FormElements.fromInternalDB(Map<String, dynamic> json) {
    print("QUI CI SONO ARRIVATOOOO");
    formId = json['form_id'].toString();
    elementId = json['element_id'].toString();
    elementTitle = json['element_title'];
    elementGuidelines = json['element_guidelines'];
    elementSize = json['element_size'];
    elementIsRequired = json['element_is_required'];
    elementIsUnique = json['element_is_unique'];
    elementIsReadonly = json['element_is_readonly'];
    elementIsPrivate = json['element_is_private'];
    elementIsEncrypted = json['element_is_encrypted'];
    elementType = json['element_type'];
    elementPosition = json['element_position'];
    elementDefaultValue = json['element_default_value'];
    elementEnablePlaceholder = json['element_enable_placeholder'];
    elementConstraint = json['element_constraint'];
    elementTotalChild = json['element_total_child'];
    elementCssClass = json['element_css_class'];
    elementRangeMin = json['element_range_min'];
    elementRangeMax = json['element_range_max'];
    elementRangeLimitBy = json['element_range_limit_by'];
    elementStatus = json['element_status'];
    elementChoiceColumns = json['element_choice_columns'];
    elementChoiceHasOther = json['element_choice_has_other'];
    elementChoiceOtherLabel = null;
    elementChoiceLimitRule = json['element_choice_limit_rule'];
    elementChoiceLimitQty = json['element_choice_limit_qty'];
    elementChoiceLimitRangeMin = json['element_choice_limit_range_min'];
    elementChoiceLimitRangeMax = json['element_choice_limit_range_max'];
    elementChoiceMaxEntry = json['element_choice_max_entry'];
    elementTimeShowsecond = json['element_time_showsecond'];
    elementTime_24hour = json['element_time_24hour'];
    elementAddressHideline2 = json['element_address_hideline2'];
    elementAddressUsOnly = json['element_address_us_only'];
    elementDateEnableRange = json['element_date_enable_range'];
    elementDateRangeMin = json['element_date_range_min'];
    elementDateRangeMax = json['element_date_range_max'];
    elementDateEnableSelectionLimit =
        json['element_date_enable_selection_limit'];
    elementDateSelectionMax = json['element_date_selection_max'];
    elementDatePastFuture = json['element_date_past_future'];
    elementDateDisablePastFuture = json['element_date_disable_past_future'];
    elementDateDisableDayofweek = json['element_date_disable_dayofweek'];
    elementDateDisabledDayofweekList =
        json['element_date_disabled_dayofweek_list'];
    elementDateDisableSpecific = json['element_date_disable_specific'];
    elementDateDisabledList = json['element_date_disabled_list'];
    elementFileEnableTypeLimit = json['element_file_enable_type_limit'];
    elementFileBlockOrAllow = json['element_file_block_or_allow'];
    elementFileTypeList = json['element_file_type_list'];
    elementFileAsAttachment = json['element_file_as_attachment'];
    elementFileEnableAdvance = json['element_file_enable_advance'];
    elementFileAutoUpload = json['element_file_auto_upload'];
    elementFileEnableMultiUpload = json['element_file_enable_multi_upload'];
    elementFileMaxSelection = json['element_file_max_selection'];
    elementFileEnableSizeLimit = json['element_file_enable_size_limit'];
    elementFileSizeMax = json['element_file_size_max'];
    elementMatrixAllowMultiselect = json['element_matrix_allow_multiselect'];
    elementMatrixParentId = json['element_matrix_parent_id'];
    elementNumberEnableQuantity = json['element_number_enable_quantity'];
    elementNumberQuantityLink = null;
    elementSectionDisplayInEmail = json['element_section_display_in_email'];
    elementSectionEnableScroll = json['element_section_enable_scroll'];
    elementSubmitUseImage = json['element_submit_use_image'];
    elementSubmitPrimaryText = json['element_submit_primary_text'];
    elementSubmitSecondaryText = json['element_submit_secondary_text'];
    elementSubmitPrimaryImg = null;
    elementSubmitSecondaryImg = null;
    elementPageTitle = null;
    elementPageNumber = json['element_page_number'];
    elementTextDefaultType = json['element_text_default_type'];
    elementTextDefaultLength = json['element_text_default_length'];
    elementTextDefaultRandomType = json['element_text_default_random_type'];
    elementTextDefaultPrefix = json['element_text_default_prefix'];
    elementTextDefaultCase = json['element_text_default_case'];
    elementEmailEnableConfirmation = json['element_email_enable_confirmation'];
    elementEmailConfirmFieldLabel = null;
    elementMediaType = json['element_media_type'];
    elementMediaImageSrc = null;
    elementMediaImageWidth = null;
    elementMediaImageHeight = null;
    elementMediaImageAlignment = json['element_media_image_alignment'];
    elementMediaImageAlt = null;
    elementMediaImageHref = null;
    elementMediaDisplayInEmail = json['element_media_display_in_email'];
    elementMediaVideoSrc = null;
    elementMediaVideoSize = json['element_media_video_size'];
    elementMediaVideoMuted = json['element_media_video_muted'];
    elementMediaVideoCaptionFile = null;
    elementExcelCell = json['element_excel_cell'];
    formElementsOptions = List.from(json['form_elements_options'])
        .map((e) => FormElementsOptions.fromJson(e))
        .toList();
  }


*/

//converto date in stringhe, e booleani in interi
  Map<String, dynamic> toJson({bool saveToDb = false}) {
    final _data = <String, dynamic>{};
    _data['form_id'] = formId;
    _data['element_id'] = elementId;
    _data['element_title'] = elementTitle;
    _data['element_guidelines'] = elementGuidelines;
    _data['element_size'] = elementSize;
    _data['element_is_required'] = formatBoolToInt(elementIsRequired);
    _data['element_is_unique'] = formatBoolToInt(elementIsUnique);
    _data['element_is_readonly'] = formatBoolToInt(elementIsReadonly);
    _data['element_is_private'] = formatBoolToInt(elementIsPrivate);
    _data['element_is_encrypted'] = formatBoolToInt(elementIsEncrypted);
    _data['element_type'] =
        FormElementTypeFunctions.convertTypeToString(elementType);
    _data['element_position'] = elementPosition;
    _data['element_default_value'] = elementDefaultValue;
    _data['element_enable_placeholder'] =
        formatBoolToInt(elementEnablePlaceholder);
    _data['element_constraint'] = elementConstraint;
    _data['element_total_child'] = elementTotalChild;
    _data['element_css_class'] = elementCssClass;
    _data['element_range_min'] = elementRangeMin;
    _data['element_range_max'] = elementRangeMax;
    _data['element_range_limit_by'] = elementRangeLimitBy;
    _data['element_status'] = elementStatus;
    _data['element_choice_columns'] = elementChoiceColumns;
    _data['element_choice_has_other'] = formatBoolToInt(elementChoiceHasOther);
    _data['element_choice_other_label'] = elementChoiceOtherLabel;
    _data['element_choice_limit_rule'] = elementChoiceLimitRule;
    _data['element_choice_limit_qty'] = formatBoolToInt(elementChoiceLimitQty);
    _data['element_choice_limit_range_min'] =
        formatBoolToInt(elementChoiceLimitRangeMin);
    _data['element_choice_limit_range_max'] =
        formatBoolToInt(elementChoiceLimitRangeMax);
    _data['element_choice_max_entry'] = formatBoolToInt(elementChoiceMaxEntry);
    _data['element_time_showsecond'] = formatBoolToInt(elementTimeShowsecond);
    _data['element_time_24hour'] = formatBoolToInt(elementTime_24hour);
    _data['element_address_hideline2'] =
        formatBoolToInt(elementAddressHideline2);
    _data['element_address_us_only'] = formatBoolToInt(elementAddressUsOnly);
    _data['element_date_enable_range'] =
        formatBoolToInt(elementDateEnableRange);
    _data['element_date_range_min'] = elementDateRangeMin.toString();
    _data['element_date_range_max'] = elementDateRangeMax.toString();
    _data['element_date_enable_selection_limit'] =
        formatBoolToInt(elementDateEnableSelectionLimit);
    _data['element_date_selection_max'] =
        formatBoolToInt(elementDateSelectionMax);
    _data['element_date_past_future'] = elementDatePastFuture;
    _data['element_date_disable_past_future'] =
        formatBoolToInt(elementDateDisablePastFuture);
    _data['element_date_disable_dayofweek'] =
        formatBoolToInt(elementDateDisableDayofweek);
    _data['element_date_disabled_dayofweek_list'] =
        elementDateDisabledDayofweekList;
    _data['element_date_disable_specific'] =
        formatBoolToInt(elementDateDisableSpecific);
    _data['element_date_disabled_list'] = elementDateDisabledList;
    _data['element_file_enable_type_limit'] =
        formatBoolToInt(elementFileEnableTypeLimit);
    _data['element_file_block_or_allow'] = elementFileBlockOrAllow;
    _data['element_file_type_list'] = elementFileTypeList;
    _data['element_file_as_attachment'] =
        formatBoolToInt(elementFileAsAttachment);
    _data['element_file_enable_advance'] =
        formatBoolToInt(elementFileEnableAdvance);
    _data['element_file_auto_upload'] = formatBoolToInt(elementFileAutoUpload);
    _data['element_file_enable_multi_upload'] =
        formatBoolToInt(elementFileEnableMultiUpload);
    _data['element_file_max_selection'] = elementFileMaxSelection;
    _data['element_file_enable_size_limit'] =
        formatBoolToInt(elementFileEnableSizeLimit);
    _data['element_file_size_max'] = elementFileSizeMax;
    _data['element_matrix_allow_multiselect'] =
        formatBoolToInt(elementMatrixAllowMultiselect);
    _data['element_matrix_parent_id'] = elementMatrixParentId;
    _data['element_number_enable_quantity'] =
        formatBoolToInt(elementNumberEnableQuantity);
    _data['element_number_quantity_link'] = elementNumberQuantityLink;
    _data['element_section_display_in_email'] =
        formatBoolToInt(elementSectionDisplayInEmail);
    _data['element_section_enable_scroll'] =
        formatBoolToInt(elementSectionEnableScroll);
    _data['element_submit_use_image'] = formatBoolToInt(elementSubmitUseImage);
    _data['element_submit_primary_text'] = elementSubmitPrimaryText;
    _data['element_submit_secondary_text'] = elementSubmitSecondaryText;
    _data['element_submit_primary_img'] = elementSubmitPrimaryImg;
    _data['element_submit_secondary_img'] = elementSubmitSecondaryImg;
    _data['element_page_title'] = elementPageTitle;
    _data['element_page_number'] = elementPageNumber;
    _data['element_text_default_type'] = elementTextDefaultType;
    _data['element_text_default_length'] = elementTextDefaultLength;
    _data['element_text_default_random_type'] = elementTextDefaultRandomType;
    _data['element_text_default_prefix'] = elementTextDefaultPrefix;
    _data['element_text_default_case'] = elementTextDefaultCase;
    _data['element_email_enable_confirmation'] =
        formatBoolToInt(elementEmailEnableConfirmation);
    _data['element_email_confirm_field_label'] = elementEmailConfirmFieldLabel;
    _data['element_media_type'] = elementMediaType;
    _data['element_media_image_src'] = elementMediaImageSrc;
    _data['element_media_image_width'] = elementMediaImageWidth;
    _data['element_media_image_height'] = elementMediaImageHeight;
    _data['element_media_image_alignment'] = elementMediaImageAlignment;
    _data['element_media_image_alt'] = elementMediaImageAlt;
    _data['element_media_image_href'] = elementMediaImageHref;
    _data['element_media_display_in_email'] =
        formatBoolToInt(elementMediaDisplayInEmail);
    _data['element_media_video_src'] = elementMediaVideoSrc;
    _data['element_media_video_size'] = elementMediaVideoSize;
    _data['element_media_video_muted'] =
        formatBoolToInt(elementMediaVideoMuted);
    _data['element_media_video_caption_file'] = elementMediaVideoCaptionFile;
    _data['element_excel_cell'] = elementExcelCell;
    //* se devo salvare ste cose nel db, allora non mi serve sta voce
    if (!saveToDb) {
      _data['form_elements_options'] =
          formElementsOptions.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}


/*

form_id,
element_id,
element_title,
element_guidelines,
element_size,
element_is_required,
element_is_unique,
element_is_readonly,
element_is_private,
element_is_encrypted,
element_type,
element_position,
element_default_value,
element_enable_placeholder,
element_constraint,
element_total_child,
element_css_class,
element_range_min,
element_range_max,
element_range_limit_by,
element_status,
element_choice_columns,
element_choice_has_other,
element_choice_other_label,
element_choice_limit_rule,
element_choice_limit_qty,
element_choice_limit_range_min,
element_choice_limit_range_max,
element_choice_max_entry,
element_time_showsecond,
element_time_24hour,
element_address_hideline2,
element_address_us_only,
element_date_enable_range,
element_date_range_min,
element_date_range_max,
element_date_enable_selection_limit,
element_date_selection_max,
element_date_past_future,
element_date_disable_past_future,
element_date_disable_dayofweek,
element_date_disabled_dayofweek_list,
element_date_disable_specific,
element_date_disabled_list,
element_file_enable_type_limit,
element_file_block_or_allow,
element_file_type_list,
element_file_as_attachment,
element_file_enable_advance,
element_file_auto_upload,
element_file_enable_multi_upload,
element_file_max_selection,
element_file_enable_size_limit,
element_file_size_max,
element_matrix_allow_multiselect,
element_matrix_parent_id,
element_number_enable_quantity,
element_number_quantity_link,
element_section_display_in_email,
element_section_enable_scroll,
element_submit_use_image,
element_submit_primary_text,
element_submit_secondary_text,
element_submit_primary_img,
element_submit_secondary_img,
element_page_title,
element_page_number,
element_text_default_type,
element_text_default_length,
element_text_default_random_type,
element_text_default_prefix,
element_text_default_case,
element_email_enable_confirmation,
element_email_confirm_field_label,
element_media_type,
element_media_image_src,
element_media_image_width,
element_media_image_height,
element_media_image_alignment,
element_media_image_alt,
element_media_image_href,
element_media_display_in_email,
element_media_video_src,
element_media_video_size,
element_media_video_muted,
element_media_video_caption_file,
element_excel_cell,



*/