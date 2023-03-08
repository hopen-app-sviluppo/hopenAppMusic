import 'package:music/helpers.dart';
import 'package:music/models/machform_models/form_element_type.dart';
import 'package:path/path.dart';

import 'form_elements.dart';

class MachForm {
  final int formId;
  final String? formName;
  final String? formDescription;
  //nel DB è 0 o 1
  final bool formNameHide;
  final String? formTags;
  final String? formEmail;
  final String? formRedirect;
  final bool formRedirectEnable;
  final String? formSuccessMessage;
  final String? formDisabledMessage;
  final String? formPassword;
  final bool formUniqueIp;
  final int formUniqueIpMaxcount;
  final String formUniqueIpPeriod;
  final int? formFrameHeight;
  final int formHasCss;
  final int formCaptcha;
  final String formCaptchaType;
  final int formActive;
  final int formThemeId;
  final int formReview;
  final bool formResumeEnable;
  final String? formResumeSubject;
  final String? formResumeContent;
  final String? formResumeFromName;
  final String? formResumeFromEmailAddress;
  final bool formCustomScriptEnable;
  final String? formCustomScriptUrl;
  final bool formLimitEnable;
  final int formLimit;
  final String formLabelAlignment;
  final String? formLanguage;
  final int formPageTotal;
  final String? formLastpageTitle;
  final String formSubmitPrimaryText;
  final String formSubmitSecondaryText;
  final String? formSubmitPrimaryImg;
  final String? formSubmitSecondaryImg;
  final bool formSubmitUseImage;
  final String formReviewPrimaryText;
  final String formReviewSecondaryText;
  final String? formReviewPrimaryImg;
  final String? formReviewSecondaryImg;
  final int formReviewUseImage;
  final String? formReviewTitle;
  final String? formReviewDescription;
  final String formPaginationType;
  final bool formScheduleEnable;
  final DateTime? formScheduleStartDate;
  final DateTime? formScheduleEndDate;
  final DateTime? formScheduleStartHour;
  final DateTime? formScheduleEndHour;
  final bool formApprovalEnable;
  final DateTime? formCreatedDate;
  final int? formCreatedBy;
  final bool eslEnable;
  final String? eslFromName;
  final String? eslFromEmailAddress;
  final String? eslBccEmailAddress;
  final String? eslReplytoEmailAddress;
  final String? eslSubject;
  final String? eslContent;
  final int eslPlainText;
  final bool eslPdfEnable;
  final String? eslPdfContent;
  final bool esrEnable;
  final String? esrEmailAddress;
  final String? esrFromName;
  final String? esrFromEmailAddress;
  final String? esrBccEmailAddress;
  final String? esrReplytoEmailAddress;
  final String? esrSubject;
  final String? esrContent;
  final int esrPlainText;
  final bool esrPdfEnable;
  final String? esrPdfContent;
  final bool paymentEnableMerchant;
  final String paymentMerchantType;
  final String? paymentPaypalEmail;
  final String paymentPaypalLanguage;
  final String paymentCurrency;
  final bool paymentShowTotal;
  final String paymentTotalLocation;
  final bool paymentEnableRecurring;
  final int paymentRecurringCycle;
  final String paymentRecurringUnit;
  final bool paymentEnableTrial;
  final int paymentTrialPeriod;
  final String paymentTrialUnit;
  final double paymentTrialAmount;
  final bool paymentEnableSetupfee;
  final double paymentSetupfeeAmount;
  final String paymentPriceType;
  final double paymentPriceAmount;
  final String? paymentPriceName;
  final String? paymentStripeLiveSecretKey;
  final String? paymentStripeLivePublicKey;
  final String? paymentStripeTestSecretKey;
  final String? paymentStripeTestPublicKey;
  final bool paymentStripeEnableTestMode;
  final bool paymentStripeEnableReceipt;
  final int? paymentStripeReceiptElementId;
  final bool paymentStripeEnablePaymentRequestButton;
  final String? paymentStripeAccountCountry;
  final String? paymentPaypalRestLiveClientid;
  final String? paymentPaypalRestLiveSecretKey;
  final String? paymentPaypalRestTestClientid;
  final String? paymentPaypalRestTestSecretKey;
  final bool paymentPaypalRestEnableTestMode;
  final String? paymentAuthorizenetLiveApiloginid;
  final String? paymentAuthorizenetLiveTranskey;
  final String? paymentAuthorizenetTestApiloginid;
  final String? paymentAuthorizenetTestTranskey;
  final bool paymentAuthorizenetEnableTestMode;
  final bool paymentAuthorizenetSaveCcData;
  final bool paymentAuthorizenetEnableEmail;
  final int? paymentAuthorizenetEmailElementId;
  final String? paymentBraintreeLiveMerchantId;
  final String? paymentBraintreeLivePublicKey;
  final String? paymentBraintreeLivePrivateKey;
  final String? paymentBraintreeLiveEncryptionKey;
  final String? paymentBraintreeTestMerchantId;
  final String? paymentBraintreeTestPublicKey;
  final String? paymentBraintreeTestPrivateKey;
  final String? paymentBraintreeTestEncryptionKey;
  final bool paymentBraintreeEnableTestMode;
  final bool paymentPaypalEnableTestMode;
  final bool paymentEnableInvoice;
  final String? paymentInvoiceEmail;
  final bool paymentDelayNotifications;
  final bool paymentAskBilling;
  final bool paymentAskShipping;
  final bool paymentEnableTax;
  final double paymentTaxRate;
  final bool paymentEnableDiscount;
  final String paymentDiscountType;
  final double paymentDiscountAmount;
  final String? paymentDiscountCode;
  final int? paymentDiscountElementId;
  final int paymentDiscountMaxUsage;
  final DateTime? paymentDiscountExpiryDate;
  final bool logicFieldEnable;
  final bool logicPageEnable;
  final bool logicEmailEnable;
  final bool logicWebhookEnable;
  final bool logicSuccessEnable;
  final bool webhookEnable;
  final String? webhookUrl;
  final String webhookMethod;
  final bool formEncryptionEnable;
  final String? formEncryptionPublicKey;
  final int creatorId;
  final List<FormElements> formElements;
  //elementi di tipo page break => me li salvo qua perchè se ci sono mi cambia tutta la grafica del form
  List<FormElements> pageBreakformElements = [];
  //elementi di tipo matrix
  Map<String, List<FormElements>> matrixElements = {};
  MachForm({
    required this.formId,
    required this.formName,
    this.formDescription,
    required this.formNameHide,
    this.formTags,
    this.formEmail,
    this.formRedirect,
    required this.formRedirectEnable,
    this.formSuccessMessage,
    this.formDisabledMessage,
    this.formPassword,
    required this.formUniqueIp,
    required this.formUniqueIpMaxcount,
    required this.formUniqueIpPeriod,
    this.formFrameHeight,
    required this.formHasCss,
    required this.formCaptcha,
    required this.formCaptchaType,
    required this.formActive,
    required this.formThemeId,
    required this.formReview,
    required this.formResumeEnable,
    this.formResumeSubject,
    this.formResumeContent,
    this.formResumeFromName,
    this.formResumeFromEmailAddress,
    required this.formCustomScriptEnable,
    this.formCustomScriptUrl,
    required this.formLimitEnable,
    required this.formLimit,
    required this.formLabelAlignment,
    this.formLanguage,
    required this.formPageTotal,
    this.formLastpageTitle,
    required this.formSubmitPrimaryText,
    required this.formSubmitSecondaryText,
    this.formSubmitPrimaryImg,
    this.formSubmitSecondaryImg,
    required this.formSubmitUseImage,
    required this.formReviewPrimaryText,
    required this.formReviewSecondaryText,
    this.formReviewPrimaryImg,
    this.formReviewSecondaryImg,
    required this.formReviewUseImage,
    this.formReviewTitle,
    this.formReviewDescription,
    required this.formPaginationType,
    required this.formScheduleEnable,
    this.formScheduleStartDate,
    this.formScheduleEndDate,
    this.formScheduleStartHour,
    this.formScheduleEndHour,
    required this.formApprovalEnable,
    this.formCreatedDate,
    this.formCreatedBy,
    required this.eslEnable,
    this.eslFromName,
    this.eslFromEmailAddress,
    this.eslBccEmailAddress,
    this.eslReplytoEmailAddress,
    this.eslSubject,
    this.eslContent,
    required this.eslPlainText,
    required this.eslPdfEnable,
    this.eslPdfContent,
    required this.esrEnable,
    this.esrEmailAddress,
    this.esrFromName,
    this.esrFromEmailAddress,
    this.esrBccEmailAddress,
    this.esrReplytoEmailAddress,
    this.esrSubject,
    this.esrContent,
    required this.esrPlainText,
    required this.esrPdfEnable,
    this.esrPdfContent,
    required this.paymentEnableMerchant,
    required this.paymentMerchantType,
    this.paymentPaypalEmail,
    required this.paymentPaypalLanguage,
    required this.paymentCurrency,
    required this.paymentShowTotal,
    required this.paymentTotalLocation,
    required this.paymentEnableRecurring,
    required this.paymentRecurringCycle,
    required this.paymentRecurringUnit,
    required this.paymentEnableTrial,
    required this.paymentTrialPeriod,
    required this.paymentTrialUnit,
    required this.paymentTrialAmount,
    required this.paymentEnableSetupfee,
    required this.paymentSetupfeeAmount,
    required this.paymentPriceType,
    required this.paymentPriceAmount,
    this.paymentPriceName,
    this.paymentStripeLiveSecretKey,
    this.paymentStripeLivePublicKey,
    this.paymentStripeTestSecretKey,
    this.paymentStripeTestPublicKey,
    required this.paymentStripeEnableTestMode,
    required this.paymentStripeEnableReceipt,
    this.paymentStripeReceiptElementId,
    required this.paymentStripeEnablePaymentRequestButton,
    this.paymentStripeAccountCountry,
    this.paymentPaypalRestLiveClientid,
    this.paymentPaypalRestLiveSecretKey,
    this.paymentPaypalRestTestClientid,
    this.paymentPaypalRestTestSecretKey,
    required this.paymentPaypalRestEnableTestMode,
    this.paymentAuthorizenetLiveApiloginid,
    this.paymentAuthorizenetLiveTranskey,
    this.paymentAuthorizenetTestApiloginid,
    this.paymentAuthorizenetTestTranskey,
    required this.paymentAuthorizenetEnableTestMode,
    required this.paymentAuthorizenetSaveCcData,
    required this.paymentAuthorizenetEnableEmail,
    this.paymentAuthorizenetEmailElementId,
    this.paymentBraintreeLiveMerchantId,
    this.paymentBraintreeLivePublicKey,
    this.paymentBraintreeLivePrivateKey,
    this.paymentBraintreeLiveEncryptionKey,
    this.paymentBraintreeTestMerchantId,
    this.paymentBraintreeTestPublicKey,
    this.paymentBraintreeTestPrivateKey,
    this.paymentBraintreeTestEncryptionKey,
    required this.paymentBraintreeEnableTestMode,
    required this.paymentPaypalEnableTestMode,
    required this.paymentEnableInvoice,
    this.paymentInvoiceEmail,
    required this.paymentDelayNotifications,
    required this.paymentAskBilling,
    required this.paymentAskShipping,
    required this.paymentEnableTax,
    required this.paymentTaxRate,
    required this.paymentEnableDiscount,
    required this.paymentDiscountType,
    required this.paymentDiscountAmount,
    this.paymentDiscountCode,
    this.paymentDiscountElementId,
    required this.paymentDiscountMaxUsage,
    this.paymentDiscountExpiryDate,
    required this.logicFieldEnable,
    required this.logicPageEnable,
    required this.logicEmailEnable,
    required this.logicWebhookEnable,
    required this.logicSuccessEnable,
    required this.webhookEnable,
    this.webhookUrl,
    required this.webhookMethod,
    required this.formEncryptionEnable,
    this.formEncryptionPublicKey,
    required this.creatorId,
    required this.formElements,
  });

  //arrivano tutte stringhe (da codificare)
  MachForm.fromSocialNetwork(Map<String, dynamic> json)
      : formId = int.parse(json['form_id']),
        formName = json['form_name'],
        formDescription = json['form_description'],
        formNameHide = formatStringToBool(json['form_name_hide']),
        formTags = json['form_tags'],
        formEmail = json['form_email'],
        formRedirect = json['form_redirect'],
        formRedirectEnable = formatStringToBool(json['form_redirect_enable']),
        formSuccessMessage = json['form_success_message'],
        formDisabledMessage = json['form_disabled_message'],
        formPassword = json['form_password'],
        formUniqueIp = formatStringToBool(json['form_unique_ip']),
        formUniqueIpMaxcount = int.parse(json['form_unique_ip_maxcount']),
        formUniqueIpPeriod = json['form_unique_ip_period'],
        formFrameHeight = int.tryParse(json['form_frame_height'] ?? ''),
        formHasCss = int.parse(json['form_has_css']),
        formCaptcha = int.parse(json['form_captcha']),
        formCaptchaType = json['form_captcha_type'],
        formActive = int.parse(json['form_active']),
        formThemeId = int.parse(json['form_theme_id']),
        formReview = int.parse(json['form_review']),
        formResumeEnable = formatStringToBool(json['form_resume_enable']),
        formResumeSubject = json['form_resume_subject'],
        formResumeContent = json['form_resume_content'],
        formResumeFromName = json['form_resume_from_name'],
        formResumeFromEmailAddress = json['form_resume_from_email_address'],
        formCustomScriptEnable =
            formatStringToBool(json['form_custom_script_enable']),
        formCustomScriptUrl = json['form_custom_script_url'],
        formLimitEnable = formatStringToBool(json['form_limit_enable']),
        formLimit = int.parse(json['form_limit']),
        formLabelAlignment = json['form_label_alignment'],
        formLanguage = json['form_language'],
        formPageTotal = int.parse(json['form_page_total']),
        formLastpageTitle = json['form_lastpage_title'],
        formSubmitPrimaryText = json['form_submit_primary_text'],
        formSubmitSecondaryText = json['form_submit_secondary_text'],
        formSubmitPrimaryImg = json['form_submit_primary_img'],
        formSubmitSecondaryImg = json['form_submit_secondary_img'],
        formSubmitUseImage = formatStringToBool(json['form_submit_use_image']),
        formReviewPrimaryText = json['form_review_primary_text'],
        formReviewSecondaryText = json['form_review_secondary_text'],
        formReviewPrimaryImg = json['form_review_primary_img'],
        formReviewSecondaryImg = json['form_review_secondary_img'],
        formReviewUseImage = int.parse(json['form_review_use_image']),
        formReviewTitle = json['form_review_title'],
        formReviewDescription = json['form_review_description'],
        formPaginationType = json['form_pagination_type'],
        formScheduleEnable = formatStringToBool(json['form_schedule_enable']),
        formScheduleStartDate =
            DateTime.tryParse(json['form_schedule_start_date'] ?? ''),
        formScheduleEndDate =
            DateTime.tryParse(json['form_schedule_end_date'] ?? ''),
        formScheduleStartHour =
            DateTime.tryParse(json['form_schedule_start_hour'] ?? ''),
        formScheduleEndHour =
            DateTime.tryParse(json['form_schedule_end_hour'] ?? ''),
        formApprovalEnable = formatStringToBool(json['form_approval_enable']),
        formCreatedDate = DateTime.tryParse(json['form_created_date'] ?? ''),
        formCreatedBy = int.tryParse(json['form_created_by'] ?? ''),
        eslEnable = formatStringToBool(json['esl_enable']),
        eslFromName = json['esl_from_name'],
        eslFromEmailAddress = json['esl_from_email_address'],
        eslBccEmailAddress = json['esl_bcc_email_address'],
        eslReplytoEmailAddress = json['esl_replyto_email_address'],
        eslSubject = json['esl_subject'],
        eslContent = json['esl_content'],
        eslPlainText = int.parse(json['esl_plain_text']),
        eslPdfEnable = formatStringToBool(json['esl_pdf_enable']),
        eslPdfContent = json['esl_pdf_content'],
        esrEnable = formatStringToBool(json['esr_enable']),
        esrEmailAddress = json['esr_email_address'],
        esrFromName = json['esr_from_name'],
        esrFromEmailAddress = json['esr_from_email_address'],
        esrBccEmailAddress = json['esr_bcc_email_address'],
        esrReplytoEmailAddress = json['esr_replyto_email_address'],
        esrSubject = json['esr_subject'],
        esrContent = json['esr_content'],
        esrPlainText = int.parse(json['esr_plain_text']),
        esrPdfEnable = formatStringToBool(json['esr_pdf_enable']),
        esrPdfContent = json['esr_pdf_ontent'],
        paymentEnableMerchant =
            formatStringToBool(json['payment_enable_merchant']),
        paymentMerchantType = json['payment_merchant_type'],
        paymentPaypalEmail = json['payment_paypal_email'],
        paymentPaypalLanguage = json['payment_paypal_language'],
        paymentCurrency = json['payment_currency'],
        paymentShowTotal = formatStringToBool(json['payment_show_total']),
        paymentTotalLocation = json['payment_total_location'],
        paymentEnableRecurring =
            formatStringToBool(json['payment_enable_recurring']),
        paymentRecurringCycle = int.parse(json['payment_recurring_cycle']),
        paymentRecurringUnit = json['payment_recurring_unit'],
        paymentEnableTrial = formatStringToBool(json['payment_enable_trial']),
        paymentTrialPeriod = int.parse(json['payment_trial_period']),
        paymentTrialUnit = json['payment_trial_unit'],
        paymentTrialAmount = double.parse(json['payment_trial_amount']),
        paymentEnableSetupfee =
            formatStringToBool(json['payment_enable_setupfee']),
        paymentSetupfeeAmount = double.parse(json['payment_setupfee_amount']),
        paymentPriceType = json['payment_price_type'],
        paymentPriceAmount = double.parse(json['payment_price_amount']),
        paymentPriceName = json['payment_price_name'],
        paymentStripeLiveSecretKey = json['payment_stripe_live_secret_key'],
        paymentStripeLivePublicKey = json['payment_stripe_live_public_key'],
        paymentStripeTestSecretKey = json['payment_stripe_test_secret_key'],
        paymentStripeTestPublicKey = json['payment_stripe_test_public_key'],
        paymentStripeEnableTestMode =
            formatStringToBool(json['payment_price_amount']),
        paymentStripeEnableReceipt =
            formatStringToBool(json['payment_stripe_enable_receipt']),
        paymentStripeReceiptElementId =
            int.tryParse(json['payment_stripe_receipt_element_id'] ?? ''),
        paymentStripeEnablePaymentRequestButton = formatStringToBool(
            json['payment_stripe_enable_payment_request_button'] ?? ''),
        paymentStripeAccountCountry = json['payment_stripe_account_country'],
        paymentPaypalRestLiveClientid =
            json['payment_paypal_rest_live_clientid'],
        paymentPaypalRestLiveSecretKey =
            json['payment_paypal_rest_live_secret_key'],
        paymentPaypalRestTestClientid =
            json['payment_paypal_rest_test_clientid'],
        paymentPaypalRestTestSecretKey =
            json['payment_paypal_rest_test_secret_key'],
        paymentPaypalRestEnableTestMode =
            formatStringToBool(json['payment_paypal_rest_enable_test_mode']),
        paymentAuthorizenetLiveApiloginid =
            json['payment_authorizenet_live_apiloginid'],
        paymentAuthorizenetLiveTranskey =
            json['payment_authorizenet_live_transkey'],
        paymentAuthorizenetTestApiloginid =
            json['payment_authorizenet_test_apiloginid'],
        paymentAuthorizenetTestTranskey =
            json['payment_authorizenet_test_transkey'],
        paymentAuthorizenetEnableTestMode =
            formatStringToBool(json['payment_authorizenet_enable_test_mode']),
        paymentAuthorizenetSaveCcData =
            formatStringToBool(json['payment_authorizenet_save_cc_data']),
        paymentAuthorizenetEnableEmail =
            formatStringToBool(json['payment_authorizenet_enable_email']),
        paymentAuthorizenetEmailElementId =
            int.tryParse(json['payment_authorizenet_email_element_id'] ?? ''),
        paymentBraintreeLiveMerchantId =
            json['payment_braintree_live_merchant_id'],
        paymentBraintreeLivePublicKey =
            json['payment_braintree_live_public_key'],
        paymentBraintreeLivePrivateKey =
            json['payment_braintree_live_private_key'],
        paymentBraintreeLiveEncryptionKey =
            json['payment_braintree_live_encryption_key'],
        paymentBraintreeTestMerchantId =
            json['payment_braintree_test_merchant_id'],
        paymentBraintreeTestPublicKey =
            json['payment_braintree_test_public_key'],
        paymentBraintreeTestPrivateKey =
            json['payment_braintree_test_private_key'],
        paymentBraintreeTestEncryptionKey =
            json['payment_braintree_test_encryption_key'],
        paymentBraintreeEnableTestMode =
            formatStringToBool(json['payment_braintree_enable_test_mode']),
        paymentPaypalEnableTestMode =
            formatStringToBool(json['payment_paypal_enable_test_mode']),
        paymentEnableInvoice =
            formatStringToBool(json['payment_enable_invoice']),
        paymentInvoiceEmail = json['payment_invoice_email'],
        paymentDelayNotifications =
            formatStringToBool(json['payment_delay_notifications']),
        paymentAskBilling = formatStringToBool(json['payment_ask_billing']),
        paymentAskShipping = formatStringToBool(json['payment_ask_shipping']),
        paymentEnableTax = formatStringToBool(json['payment_enable_tax']),
        paymentTaxRate = double.parse(json['payment_tax_rate']),
        paymentEnableDiscount =
            formatStringToBool(json['payment_enable_discount']),
        paymentDiscountType = json['payment_discount_type'],
        paymentDiscountAmount = double.parse(json['payment_discount_amount']),
        paymentDiscountCode = json['payment_discount_code'],
        paymentDiscountElementId =
            int.tryParse(json['payment_discount_element_id'] ?? ''),
        paymentDiscountMaxUsage = int.parse(json['payment_discount_max_usage']),
        paymentDiscountExpiryDate =
            DateTime.tryParse(json['payment_discount_expiry_date'] ?? ''),
        logicFieldEnable = formatStringToBool(json['logic_field_enable']),
        logicPageEnable = formatStringToBool(json['logic_page_enable']),
        logicEmailEnable = formatStringToBool(json['logic_email_enable']),
        logicWebhookEnable = formatStringToBool(json['logic_webhook_enable']),
        logicSuccessEnable = formatStringToBool(json['logic_success_enable']),
        webhookEnable = formatStringToBool(json['webhook_enable']),
        webhookUrl = json['webhook_url'],
        webhookMethod = json['webhook_method'],
        formEncryptionEnable =
            formatStringToBool(json['form_encryption_enable']),
        formEncryptionPublicKey = json['form_encryption_public_key'],
        creatorId = int.parse(json['creator_id']),
        formElements = List.from(json['form_elements'])
            .map((e) => FormElements.fromSocialNetwork(e))
            .toList();

//arrivano valori già codificati
  MachForm.fromInternalDB(Map<String, dynamic> json)
      : formId = json['form_id'],
        formName = json['form_name'],
        formDescription = json['form_description'],
        formNameHide = formatIntToBool(json['form_name_hide']),
        formTags = json['form_tags'],
        formEmail = json['form_email'],
        formRedirect = json['form_redirect'],
        formRedirectEnable = formatIntToBool(json['form_redirect_enable']),
        formSuccessMessage = json['form_success_message'],
        formDisabledMessage = json['form_disabled_message'],
        formPassword = json['form_password'],
        formUniqueIp = formatIntToBool(json['form_unique_ip']),
        formUniqueIpMaxcount = json['form_unique_ip_maxcount'],
        formUniqueIpPeriod = json['form_unique_ip_period'],
        formFrameHeight = json['form_frame_height'],
        formHasCss = json['form_has_css'],
        formCaptcha = json['form_captcha'],
        formCaptchaType = json['form_captcha_type'],
        formActive = json['form_active'],
        formThemeId = json['form_theme_id'],
        formReview = json['form_review'],
        formResumeEnable = formatIntToBool(json['form_resume_enable']),
        formResumeSubject = json['form_resume_subject'],
        formResumeContent = json['form_resume_content'],
        formResumeFromName = json['form_resume_from_name'],
        formResumeFromEmailAddress = json['form_resume_from_email_address'],
        formCustomScriptEnable =
            formatIntToBool(json['form_custom_script_enable']),
        formCustomScriptUrl = json['form_custom_script_url'],
        formLimitEnable = formatIntToBool(json['form_limit_enable']),
        formLimit = json['form_limit'],
        formLabelAlignment = json['form_label_alignment'],
        formLanguage = json['form_language'],
        formPageTotal = json['form_page_total'],
        formLastpageTitle = json['form_lastpage_title'],
        formSubmitPrimaryText = json['form_submit_primary_text'],
        formSubmitSecondaryText = json['form_submit_secondary_text'],
        formSubmitPrimaryImg = json['form_submit_primary_img'],
        formSubmitSecondaryImg = json['form_submit_secondary_img'],
        formSubmitUseImage = formatIntToBool(json['form_submit_use_image']),
        formReviewPrimaryText = json['form_review_primary_text'],
        formReviewSecondaryText = json['form_review_secondary_text'],
        formReviewPrimaryImg = json['form_review_primary_img'],
        formReviewSecondaryImg = json['form_review_secondary_img'],
        formReviewUseImage = json['form_review_use_image'],
        formReviewTitle = json['form_review_title'],
        formReviewDescription = json['form_review_description'],
        formPaginationType = json['form_pagination_type'],
        formScheduleEnable = formatIntToBool(json['form_schedule_enable']),
        formScheduleStartDate =
            DateTime.tryParse(json['form_schedule_start_date'] ?? ''),
        formScheduleEndDate =
            DateTime.tryParse(json['form_schedule_end_date'] ?? ''),
        formScheduleStartHour =
            DateTime.tryParse(json['form_schedule_start_hour'] ?? ''),
        formScheduleEndHour =
            DateTime.tryParse(json['form_schedule_end_hour'] ?? ''),
        formApprovalEnable = formatIntToBool(json['form_approval_enable']),
        formCreatedDate = DateTime.tryParse(json['form_created_date'] ?? ''),
        formCreatedBy = json['form_created_by'],
        eslEnable = formatIntToBool(json['esl_enable']),
        eslFromName = json['esl_from_name'],
        eslFromEmailAddress = json['esl_from_email_address'],
        eslBccEmailAddress = json['esl_bcc_email_address'],
        eslReplytoEmailAddress = json['esl_replyto_email_address'],
        eslSubject = json['esl_subject'],
        eslContent = json['esl_content'],
        eslPlainText = json['esl_plain_text'],
        eslPdfEnable = formatIntToBool(json['esl_pdf_enable']),
        eslPdfContent = json['esl_pdf_content'],
        esrEnable = formatIntToBool(json['esr_enable']),
        esrEmailAddress = json['esr_email_address'],
        esrFromName = json['esr_from_name'],
        esrFromEmailAddress = json['esr_from_email_address'],
        esrBccEmailAddress = json['esr_bcc_email_address'],
        esrReplytoEmailAddress = json['esr_replyto_email_address'],
        esrSubject = json['esr_subject'],
        esrContent = json['esr_content'],
        esrPlainText = json['esr_plain_text'],
        esrPdfEnable = formatIntToBool(json['esr_pdf_enable']),
        esrPdfContent = json['esr_pdf_ontent'],
        paymentEnableMerchant =
            formatIntToBool(json['payment_enable_merchant']),
        paymentMerchantType = json['payment_merchant_type'],
        paymentPaypalEmail = json['payment_paypal_email'],
        paymentPaypalLanguage = json['payment_paypal_language'],
        paymentCurrency = json['payment_currency'],
        paymentShowTotal = formatIntToBool(json['payment_show_total']),
        paymentTotalLocation = json['payment_total_location'],
        paymentEnableRecurring =
            formatIntToBool(json['payment_enable_recurring']),
        paymentRecurringCycle = json['payment_recurring_cycle'],
        paymentRecurringUnit = json['payment_recurring_unit'],
        paymentEnableTrial = formatIntToBool(json['payment_enable_trial']),
        paymentTrialPeriod = json['payment_trial_period'],
        paymentTrialUnit = json['payment_trial_unit'],
        paymentTrialAmount = json['payment_trial_amount'],
        paymentEnableSetupfee =
            formatIntToBool(json['payment_enable_setupfee']),
        paymentSetupfeeAmount = json['payment_setupfee_amount'],
        paymentPriceType = json['payment_price_type'],
        paymentPriceAmount = json['payment_price_amount'],
        paymentPriceName = json['payment_price_name'],
        paymentStripeLiveSecretKey = json['payment_stripe_live_secret_key'],
        paymentStripeLivePublicKey = json['payment_stripe_live_public_key'],
        paymentStripeTestSecretKey = json['payment_stripe_test_secret_key'],
        paymentStripeTestPublicKey = json['payment_stripe_test_public_key'],
        paymentStripeEnableTestMode =
            formatIntToBool(json['payment_stripe_enable_test_mode']),
        paymentStripeEnableReceipt =
            formatIntToBool(json['payment_stripe_enable_receipt']),
        paymentStripeReceiptElementId =
            int.tryParse(json['payment_stripe_receipt_element_id'] ?? ''),
        paymentStripeEnablePaymentRequestButton = formatIntToBool(
            json['payment_stripe_enable_payment_request_button']),
        paymentStripeAccountCountry = json['payment_stripe_account_country'],
        paymentPaypalRestLiveClientid =
            json['payment_paypal_rest_live_clientid'],
        paymentPaypalRestLiveSecretKey =
            json['payment_paypal_rest_live_secret_key'],
        paymentPaypalRestTestClientid =
            json['payment_paypal_rest_test_clientid'],
        paymentPaypalRestTestSecretKey =
            json['payment_paypal_rest_test_secret_key'],
        paymentPaypalRestEnableTestMode =
            formatIntToBool(json['payment_paypal_rest_enable_test_mode']),
        paymentAuthorizenetLiveApiloginid =
            json['payment_authorizenet_live_apiloginid'],
        paymentAuthorizenetLiveTranskey =
            json['payment_authorizenet_live_transkey'],
        paymentAuthorizenetTestApiloginid =
            json['payment_authorizenet_test_apiloginid'],
        paymentAuthorizenetTestTranskey =
            json['payment_authorizenet_test_transkey'],
        paymentAuthorizenetEnableTestMode =
            formatIntToBool(json['payment_authorizenet_enable_test_mode']),
        paymentAuthorizenetSaveCcData =
            formatIntToBool(json['payment_authorizenet_save_cc_data']),
        paymentAuthorizenetEnableEmail =
            formatIntToBool(json['payment_authorizenet_enable_email']),
        paymentAuthorizenetEmailElementId =
            int.tryParse(json['payment_authorizenet_email_element_id'] ?? ''),
        paymentBraintreeLiveMerchantId =
            json['payment_braintree_live_merchant_id'],
        paymentBraintreeLivePublicKey =
            json['payment_braintree_live_public_key'],
        paymentBraintreeLivePrivateKey =
            json['payment_braintree_live_private_key'],
        paymentBraintreeLiveEncryptionKey =
            json['payment_braintree_live_encryption_key'],
        paymentBraintreeTestMerchantId =
            json['payment_braintree_test_merchant_id'],
        paymentBraintreeTestPublicKey =
            json['payment_braintree_test_public_key'],
        paymentBraintreeTestPrivateKey =
            json['payment_braintree_test_private_key'],
        paymentBraintreeTestEncryptionKey =
            json['payment_braintree_test_encryption_key'],
        paymentBraintreeEnableTestMode =
            formatIntToBool(json['payment_braintree_enable_test_mode']),
        paymentPaypalEnableTestMode =
            formatIntToBool(json['payment_paypal_enable_test_mode']),
        paymentEnableInvoice = formatIntToBool(json['payment_enable_invoice']),
        paymentInvoiceEmail = json['payment_invoice_email'],
        paymentDelayNotifications =
            formatIntToBool(json['payment_delay_notifications']),
        paymentAskBilling = formatIntToBool(json['payment_ask_billing']),
        paymentAskShipping = formatIntToBool(json['payment_ask_shipping']),
        paymentEnableTax = formatIntToBool(json['payment_enable_tax']),
        paymentTaxRate = json['payment_tax_rate'],
        paymentEnableDiscount =
            formatIntToBool(json['payment_enable_discount']),
        paymentDiscountType = json['payment_discount_type'],
        paymentDiscountAmount = json['payment_discount_amount'],
        paymentDiscountCode = json['payment_discount_code'],
        paymentDiscountElementId =
            int.tryParse(json['payment_discount_element_id'] ?? ''),
        paymentDiscountMaxUsage = json['payment_discount_max_usage'],
        paymentDiscountExpiryDate =
            DateTime.tryParse(json['payment_discount_expiry_date'] ?? ''),
        logicFieldEnable = formatIntToBool(json['logic_field_enable']),
        logicPageEnable = formatIntToBool(json['logic_page_enable']),
        logicEmailEnable = formatIntToBool(json['logic_email_enable']),
        logicWebhookEnable = formatIntToBool(json['logic_webhook_enable']),
        logicSuccessEnable = formatIntToBool(json['logic_success_enable']),
        webhookEnable = formatIntToBool(json['webhook_enable']),
        webhookUrl = json['webhook_url'],
        webhookMethod = json['webhook_method'],
        formEncryptionEnable = formatIntToBool(json['form_encryption_enable']),
        formEncryptionPublicKey = json['form_encryption_public_key'],
        creatorId = json['creator_id'],
        formElements = List.from(json['form_elements'])
            .map((e) => FormElements.fromInternalDB(e))
            .toList() {
    //* body del costruttore
    for (var elem in formElements) {
      if (elem.elementType == FormElementType.page_break) {
        pageBreakformElements.add(elem);
      } else if (elem.elementType == FormElementType.matrix &&
          elem.elementConstraint != "") {
        //ho una lista di stringhe nei constraint, che sono gli id degli elementi da aggiungere alla matrice, e alla fine aggiungo questo elemento all'inizio :D
        Set<int> constraints =
            elem.elementConstraint.split(',').map((e) => int.parse(e)).toSet();
        matrixElements['matrix_${elem.elementId}'] = formElements
            .where((element) => constraints.contains(element.elementId))
            .toList()
          ..insert(0, elem);
      }
    }
  }

// [ {38:[tutti elementi che sono riferiti a sta matrice], 39: [tutti elementi che so riferiti a sta matrice]}   ]

  /* METODO FROM JSON
 MachForm.fromJson(Map<String, dynamic> json)
      : formId = json['form_id'].toString(),
        formName = json['form_name'],
        formDescription = json['form_description'],
        formNameHide = json['form_name_hide'],
        formTags = json['form_tags'],
        formEmail = json['form_email'],
        formRedirect = json['form_redirect'],
        formRedirectEnable = json['form_redirect_enable'],
        formSuccessMessage = json['form_success_message'],
        formDisabledMessage = json['form_disabled_message'],
        formPassword = json['form_password'],
        formUniqueIp = json['form_unique_ip'],
        formUniqueIpMaxcount = json['form_unique_ip_maxcount'],
        formUniqueIpPeriod = json['form_unique_ip_period'],
        formFrameHeight = json['form_frame_height'],
        formHasCss = json['form_has_css'],
        formCaptcha = json['form_captcha'],
        formCaptchaType = json['form_captcha_type'],
        formActive = json['form_active'],
        formThemeId = json['form_theme_id'],
        formReview = json['form_review'],
        formResumeEnable = json['form_resume_enable'],
        formResumeSubject = json['form_resume_subject'],
        formResumeContent = json['form_resume_content'],
        formResumeFromName = json['form_resume_from_name'],
        formResumeFromEmailAddress = json['form_resume_from_email_address'],
        formCustomScriptEnable = json['form_custom_script_enable'],
        formCustomScriptUrl = json['form_custom_script_url'],
        formLimitEnable = json['form_limit_enable'],
        formLimit = json['form_limit'],
        formLabelAlignment = json['form_label_alignment'],
        formLanguage = json['form_language'],
        formPageTotal = json['form_page_total'],
        formLastpageTitle = json['form_lastpage_title'],
        formSubmitPrimaryText = json['form_submit_primary_text'],
        formSubmitSecondaryText = json['form_submit_secondary_text'],
        formSubmitPrimaryImg = json['form_submit_primary_img'],
        formSubmitSecondaryImg = json['form_submit_secondary_img'],
        formSubmitUseImage = json['form_submit_use_image'],
        formReviewPrimaryText = json['form_review_primary_text'],
        formReviewSecondaryText = json['form_review_secondary_text'],
        formReviewPrimaryImg = json['form_review_primary_img'],
        formReviewSecondaryImg = json['form_review_secondary_img'],
        formReviewUseImage = json['form_review_use_image'],
        formReviewTitle = json['form_review_title'],
        formReviewDescription = json['form_review_description'],
        formPaginationType = json['form_pagination_type'],
        formScheduleEnable = json['form_schedule_enable'],
        formScheduleStartDate = json['form_schedule_start_date'],
        formScheduleEndDate = json['form_schedule_end_date'],
        formScheduleStartHour = json['form_schedule_start_hour'],
        formScheduleEndHour = json['form_schedule_end_hour'],
        formApprovalEnable = json['form_approval_enable'],
        formCreatedDate = json['form_created_date'],
        formCreatedBy = json['form_created_by'],
        eslEnable = json['esl_enable'],
        eslFromName = json['esl_from_name'],
        eslFromEmailAddress = json['esl_from_email_address'],
        eslBccEmailAddress = json['esl_bcc_email_address'],
        eslReplytoEmailAddress = json['esl_replyto_email_address'],
        eslSubject = json['esl_subject'],
        eslContent = json['esl_content'],
        eslPlainText = json['esl_plain_text'],
        eslPdfEnable = json['esl_pdf_enable'],
        eslPdfContent = json['esl_pdf_content'],
        esrEnable = json['esr_enable'],
        esrEmailAddress = json['esr_email_address'],
        esrFromName = json['esr_from_name'],
        esrFromEmailAddress = json['esr_from_email_address'],
        esrBccEmailAddress = json['esr_bcc_email_address'],
        esrReplytoEmailAddress = json['esr_replyto_email_address'],
        esrSubject = json['esr_subject'],
        esrContent = json['esr_content'],
        esrPlainText = json['esr_plain_text'],
        esrPdfEnable = json['esr_pdf_enable'],
        esrPdfContent = json['esr_pdf_ontent'],
        paymentEnableMerchant = json['payment_enable_merchant'],
        paymentMerchantType = json['payment_merchant_type'],
        paymentPaypalEmail = json['payment_paypal_email'],
        paymentPaypalLanguage = json['payment_paypal_language'],
        paymentCurrency = json['payment_currency'],
        paymentShowTotal = json['payment_show_total'],
        paymentTotalLocation = json['payment_total_location'],
        paymentEnableRecurring = json['payment_enable_recurring'],
        paymentRecurringCycle = json['payment_recurring_cycle'],
        paymentRecurringUnit = json['payment_recurring_unit'],
        paymentEnableTrial = json['payment_enable_trial'],
        paymentTrialPeriod = json['payment_trial_period'],
        paymentTrialUnit = json['payment_trial_unit'],
        paymentTrialAmount = json['payment_trial_amount'],
        paymentEnableSetupfee = json['payment_enable_setupfee'],
        paymentSetupfeeAmount = json['payment_setupfee_amount'],
        paymentPriceType = json['payment_price_type'],
        paymentPriceAmount = json['payment_price_amount'],
        paymentPriceName = json['payment_price_name'],
        paymentStripeLiveSecretKey = json['payment_stripe_live_secret_key'],
        paymentStripeLivePublicKey = json['payment_stripe_live_public_key'],
        paymentStripeTestSecretKey = json['payment_stripe_test_secret_key'],
        paymentStripeTestPublicKey = json['payment_stripe_test_public_key'],
        paymentStripeEnableTestMode = json['payment_stripe_enable_test_mode'],
        paymentStripeEnableReceipt = json['payment_stripe_enable_receipt'],
        paymentStripeReceiptElementId =
            json['payment_stripe_receipt_element_id'],
        paymentStripeEnablePaymentRequestButton =
            json['payment_stripe_enable_payment_request_button'],
        paymentStripeAccountCountry = json['payment_stripe_account_country'],
        paymentPaypalRestLiveClientid =
            json['payment_paypal_rest_live_clientid'],
        paymentPaypalRestLiveSecretKey =
            json['payment_paypal_rest_live_secret_key'],
        paymentPaypalRestTestClientid =
            json['payment_paypal_rest_test_clientid'],
        paymentPaypalRestTestSecretKey =
            json['payment_paypal_rest_test_secret_key'],
        paymentPaypalRestEnableTestMode =
            json['payment_paypal_rest_enable_test_mode'],
        paymentAuthorizenetLiveApiloginid =
            json['payment_authorizenet_live_apiloginid'],
        paymentAuthorizenetLiveTranskey =
            json['payment_authorizenet_live_transkey'],
        paymentAuthorizenetTestApiloginid =
            json['payment_authorizenet_test_apiloginid'],
        paymentAuthorizenetTestTranskey =
            json['payment_authorizenet_test_transkey'],
        paymentAuthorizenetEnableTestMode =
            json['payment_authorizenet_enable_test_mode'],
        paymentAuthorizenetSaveCcData =
            json['payment_authorizenet_save_cc_data'],
        paymentAuthorizenetEnableEmail =
            json['payment_authorizenet_enable_email'],
        paymentAuthorizenetEmailElementId =
            json['payment_authorizenet_email_element_id'],
        paymentBraintreeLiveMerchantId =
            json['payment_braintree_live_merchant_id'],
        paymentBraintreeLivePublicKey =
            json['payment_braintree_live_public_key'],
        paymentBraintreeLivePrivateKey =
            json['payment_braintree_live_private_key'],
        paymentBraintreeLiveEncryptionKey =
            json['payment_braintree_live_encryption_key'],
        paymentBraintreeTestMerchantId =
            json['payment_braintree_test_merchant_id'],
        paymentBraintreeTestPublicKey =
            json['payment_braintree_test_public_key'],
        paymentBraintreeTestPrivateKey =
            json['payment_braintree_test_private_key'],
        paymentBraintreeTestEncryptionKey =
            json['payment_braintree_test_encryption_key'],
        paymentBraintreeEnableTestMode =
            json['payment_braintree_enable_test_mode'],
        paymentPaypalEnableTestMode = json['payment_paypal_enable_test_mode'],
        paymentEnableInvoice = json['payment_enable_invoice'],
        paymentInvoiceEmail = json['payment_invoice_email'],
        paymentDelayNotifications = json['payment_delay_notifications'],
        paymentAskBilling = json['payment_ask_billing'],
        paymentAskShipping = json['payment_ask_shipping'],
        paymentEnableTax = json['payment_enable_tax'],
        paymentTaxRate = json['payment_tax_rate'],
        paymentEnableDiscount = json['payment_enable_discount'],
        paymentDiscountType = json['payment_discount_type'],
        paymentDiscountAmount = json['payment_discount_amount'],
        paymentDiscountCode = json['payment_discount_code'],
        paymentDiscountElementId = json['payment_discount_element_id'],
        paymentDiscountMaxUsage = json['payment_discount_max_usage'],
        paymentDiscountExpiryDate = json['payment_discount_expiry_date'],
        logicFieldEnable = json['logic_field_enable'],
        logicPageEnable = json['logic_page_enable'],
        logicEmailEnable = json['logic_email_enable'],
        logicWebhookEnable = json['logic_webhook_enable'],
        logicSuccessEnable = json['logic_success_enable'],
        webhookEnable = json['webhook_enable'],
        webhookUrl = json['webhook_url'],
        webhookMethod = json['webhook_method'],
        formEncryptionEnable = json['form_encryption_enable'],
        formEncryptionPublicKey = json['form_encryption_public_key'],
        creatorId = json['creator_id'].toString(),
        formElements = List.from(json['form_elements'])
            .map((e) => FormElements.fromJson(e))
            .toList();



            */

//* Uso questa funzione per salvare il Form nel DB interno !
  //devo codificare i booleani in interi (0 = false, 1 = true), e le Date in stringhe
  Map<String, dynamic> toJson({bool saveToDb = false}) {
    final _data = <String, dynamic>{};
    _data['form_id'] = formId;
    _data['form_name'] = formName;
    _data['form_description'] = formDescription;
    _data['form_name_hide'] = formatBoolToInt(formNameHide);
    _data['form_tags'] = formTags;
    _data['form_email'] = formEmail;
    _data['form_redirect'] = formRedirect;
    _data['form_redirect_enable'] = formatBoolToInt(formRedirectEnable);
    _data['form_success_message'] = formSuccessMessage;
    _data['form_disabled_message'] = formDisabledMessage;
    _data['form_password'] = formPassword;
    _data['form_unique_ip'] = formatBoolToInt(formUniqueIp);
    _data['form_unique_ip_maxcount'] = formUniqueIpMaxcount;
    _data['form_unique_ip_period'] = formUniqueIpPeriod;
    _data['form_frame_height'] = formFrameHeight;
    _data['form_has_css'] = formHasCss;
    _data['form_captcha'] = formCaptcha;
    _data['form_captcha_type'] = formCaptchaType;
    _data['form_active'] = formActive;
    _data['form_theme_id'] = formThemeId;
    _data['form_review'] = formReview;
    _data['form_resume_enable'] = formatBoolToInt(formResumeEnable);
    _data['form_resume_subject'] = formResumeSubject;
    _data['form_resume_content'] = formResumeContent;
    _data['form_resume_from_name'] = formResumeFromName;
    _data['form_resume_from_email_address'] = formResumeFromEmailAddress;
    _data['form_custom_script_enable'] =
        formatBoolToInt(formCustomScriptEnable);
    _data['form_custom_script_url'] = formCustomScriptUrl;
    _data['form_limit_enable'] = formatBoolToInt(formLimitEnable);
    _data['form_limit'] = formLimit;
    _data['form_label_alignment'] = formLabelAlignment;
    _data['form_language'] = formLanguage;
    _data['form_page_total'] = formPageTotal;
    _data['form_lastpage_title'] = formLastpageTitle;
    _data['form_submit_primary_text'] = formSubmitPrimaryText;
    _data['form_submit_secondary_text'] = formSubmitSecondaryText;
    _data['form_submit_primary_img'] = formSubmitPrimaryImg;
    _data['form_submit_secondary_img'] = formSubmitSecondaryImg;
    _data['form_submit_use_image'] = formatBoolToInt(formSubmitUseImage);
    _data['form_review_primary_text'] = formReviewPrimaryText;
    _data['form_review_secondary_text'] = formReviewSecondaryText;
    _data['form_review_primary_img'] = formReviewPrimaryImg;
    _data['form_review_secondary_img'] = formReviewSecondaryImg;
    _data['form_review_use_image'] = formReviewUseImage;
    _data['form_review_title'] = formReviewTitle;
    _data['form_review_description'] = formReviewDescription;
    _data['form_pagination_type'] = formPaginationType;
    _data['form_schedule_enable'] = formatBoolToInt(formScheduleEnable);
    _data['form_schedule_start_date'] = formScheduleStartDate.toString();
    _data['form_schedule_end_date'] = formScheduleEndDate.toString();
    _data['form_schedule_start_hour'] = formScheduleStartHour.toString();
    _data['form_schedule_end_hour'] = formScheduleEndHour.toString();
    _data['form_approval_enable'] = formatBoolToInt(formApprovalEnable);
    _data['form_created_date'] = formCreatedDate.toString();
    _data['form_created_by'] = formCreatedBy;
    _data['esl_enable'] = formatBoolToInt(eslEnable);
    _data['esl_from_name'] = eslFromName;
    _data['esl_from_email_address'] = eslFromEmailAddress;
    _data['esl_bcc_email_address'] = eslBccEmailAddress;
    _data['esl_replyto_email_address'] = eslReplytoEmailAddress;
    _data['esl_subject'] = eslSubject;
    _data['esl_content'] = eslContent;
    _data['esl_plain_text'] = eslPlainText;
    _data['esl_pdf_enable'] = formatBoolToInt(eslPdfEnable);
    _data['esl_pdf_content'] = eslPdfContent;
    _data['esr_enable'] = formatBoolToInt(esrEnable);
    _data['esr_email_address'] = esrEmailAddress;
    _data['esr_from_name'] = esrFromName;
    _data['esr_from_email_address'] = esrFromEmailAddress;
    _data['esr_bcc_email_address'] = esrBccEmailAddress;
    _data['esr_replyto_email_address'] = esrReplytoEmailAddress;
    _data['esr_subject'] = esrSubject;
    _data['esr_content'] = esrContent;
    _data['esr_plain_text'] = esrPlainText;
    _data['esr_pdf_enable'] = formatBoolToInt(esrPdfEnable);
    _data['esr_pdf_content'] = esrPdfContent;
    _data['payment_enable_merchant'] = formatBoolToInt(paymentEnableMerchant);
    _data['payment_merchant_type'] = paymentMerchantType;
    _data['payment_paypal_email'] = paymentPaypalEmail;
    _data['payment_paypal_language'] = paymentPaypalLanguage;
    _data['payment_currency'] = paymentCurrency;
    _data['payment_show_total'] = formatBoolToInt(paymentShowTotal);
    _data['payment_total_location'] = paymentTotalLocation;
    _data['payment_enable_recurring'] = formatBoolToInt(paymentEnableRecurring);
    _data['payment_recurring_cycle'] = paymentRecurringCycle;
    _data['payment_recurring_unit'] = paymentRecurringUnit;
    _data['payment_enable_trial'] = formatBoolToInt(paymentEnableTrial);
    _data['payment_trial_period'] = paymentTrialPeriod;
    _data['payment_trial_unit'] = paymentTrialUnit;
    _data['payment_trial_amount'] = paymentTrialAmount;
    _data['payment_enable_setupfee'] = formatBoolToInt(paymentEnableSetupfee);
    _data['payment_setupfee_amount'] = paymentSetupfeeAmount;
    _data['payment_price_type'] = paymentPriceType;
    _data['payment_price_amount'] = paymentPriceAmount;
    _data['payment_price_name'] = paymentPriceName;
    _data['payment_stripe_live_secret_key'] = paymentStripeLiveSecretKey;
    _data['payment_stripe_live_public_key'] = paymentStripeLivePublicKey;
    _data['payment_stripe_test_secret_key'] = paymentStripeTestSecretKey;
    _data['payment_stripe_test_public_key'] = paymentStripeTestPublicKey;
    _data['payment_stripe_enable_test_mode'] =
        formatBoolToInt(paymentStripeEnableTestMode);
    _data['payment_stripe_enable_receipt'] =
        formatBoolToInt(paymentStripeEnableReceipt);
    _data['payment_stripe_receipt_element_id'] = paymentStripeReceiptElementId;
    _data['payment_stripe_enable_payment_request_button'] =
        formatBoolToInt(paymentStripeEnablePaymentRequestButton);
    _data['payment_stripe_account_country'] = paymentStripeAccountCountry;
    _data['payment_paypal_rest_live_clientid'] = paymentPaypalRestLiveClientid;
    _data['payment_paypal_rest_live_secret_key'] =
        paymentPaypalRestLiveSecretKey;
    _data['payment_paypal_rest_test_clientid'] = paymentPaypalRestTestClientid;
    _data['payment_paypal_rest_test_secret_key'] =
        paymentPaypalRestTestSecretKey;
    _data['payment_paypal_rest_enable_test_mode'] =
        formatBoolToInt(paymentPaypalRestEnableTestMode);
    _data['payment_authorizenet_live_apiloginid'] =
        paymentAuthorizenetLiveApiloginid;
    _data['payment_authorizenet_live_transkey'] =
        paymentAuthorizenetLiveTranskey;
    _data['payment_authorizenet_test_apiloginid'] =
        paymentAuthorizenetTestApiloginid;
    _data['payment_authorizenet_test_transkey'] =
        paymentAuthorizenetTestTranskey;
    _data['payment_authorizenet_enable_test_mode'] =
        formatBoolToInt(paymentAuthorizenetEnableTestMode);
    _data['payment_authorizenet_save_cc_data'] =
        formatBoolToInt(paymentAuthorizenetSaveCcData);
    _data['payment_authorizenet_enable_email'] =
        formatBoolToInt(paymentAuthorizenetEnableEmail);
    _data['payment_authorizenet_email_element_id'] =
        paymentAuthorizenetEmailElementId;
    _data['payment_braintree_live_merchant_id'] =
        paymentBraintreeLiveMerchantId;
    _data['payment_braintree_live_public_key'] = paymentBraintreeLivePublicKey;
    _data['payment_braintree_live_private_key'] =
        paymentBraintreeLivePrivateKey;
    _data['payment_braintree_live_encryption_key'] =
        paymentBraintreeLiveEncryptionKey;
    _data['payment_braintree_test_merchant_id'] =
        paymentBraintreeTestMerchantId;
    _data['payment_braintree_test_public_key'] = paymentBraintreeTestPublicKey;
    _data['payment_braintree_test_private_key'] =
        paymentBraintreeTestPrivateKey;
    _data['payment_braintree_test_encryption_key'] =
        paymentBraintreeTestEncryptionKey;
    _data['payment_braintree_enable_test_mode'] =
        formatBoolToInt(paymentBraintreeEnableTestMode);
    _data['payment_paypal_enable_test_mode'] =
        formatBoolToInt(paymentPaypalEnableTestMode);
    _data['payment_enable_invoice'] = formatBoolToInt(paymentEnableInvoice);
    _data['payment_invoice_email'] = paymentInvoiceEmail;
    _data['payment_delay_notifications'] =
        formatBoolToInt(paymentDelayNotifications);
    _data['payment_ask_billing'] = formatBoolToInt(paymentAskBilling);
    _data['payment_ask_shipping'] = formatBoolToInt(paymentAskShipping);
    _data['payment_enable_tax'] = formatBoolToInt(paymentEnableTax);
    _data['payment_tax_rate'] = paymentTaxRate;
    _data['payment_enable_discount'] = formatBoolToInt(paymentEnableDiscount);
    _data['payment_discount_type'] = paymentDiscountType;
    _data['payment_discount_amount'] = paymentDiscountAmount;
    _data['payment_discount_code'] = paymentDiscountCode;
    _data['payment_discount_element_id'] = paymentDiscountElementId;
    _data['payment_discount_max_usage'] = paymentDiscountMaxUsage;
    _data['payment_discount_expiry_date'] =
        paymentDiscountExpiryDate.toString();
    _data['logic_field_enable'] = formatBoolToInt(logicFieldEnable);
    _data['logic_page_enable'] = formatBoolToInt(logicPageEnable);
    _data['logic_email_enable'] = formatBoolToInt(logicEmailEnable);
    _data['logic_webhook_enable'] = formatBoolToInt(logicWebhookEnable);
    _data['logic_success_enable'] = formatBoolToInt(logicSuccessEnable);
    _data['webhook_enable'] = formatBoolToInt(webhookEnable);
    _data['webhook_url'] = webhookUrl;
    _data['webhook_method'] = webhookMethod;
    _data['form_encryption_enable'] = formatBoolToInt(formEncryptionEnable);
    _data['form_encryption_public_key'] = formEncryptionPublicKey;
    _data['creator_id'] = creatorId;
    //se salvo nel DB non mi serve prendere form_elements
    if (!saveToDb) {
      _data['form_elements'] = formElements.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}
/*

'form_id', 
'form_name', 
'form_description', 
'form_name_hide', 
'form_tags', 
'form_email', 
'form_redirect',
'form_redirect_enable', 
'form_success_message', 
'form_disabled_message', 
'form_password', 
'form_unique_ip', 
'form_unique_ip_maxcount',
'form_unique_ip_period', 
'form_frame_height', 
'form_has_css', 
'form_captcha', 
'form_captcha_type',
'form_active', 
'form_theme_id',
'form_review',
'form_resume_enable', 
'form_resume_subject',
'form_resume_content',
'form_resume_from_name', 
'form_resume_from_email_address', 
'form_custom_script_enable', 
'form_custom_script_url', 
'form_limit_enable', 
'form_limit', 
'form_label_alignment', 
'form_language', 
'form_page_total', 
'form_lastpage_title', 
'form_submit_primary_text', 
'form_submit_secondary_text', 
'form_submit_primary_img', 
'form_submit_secondary_img', 
'form_submit_use_image', 
'form_review_primary_text', 
'form_review_secondary_text', 
'form_review_primary_img', 
'form_review_secondary_img', 
'form_review_use_image', 
'form_review_title', 
'form_review_description', 
'form_pagination_type', 
'form_schedule_enable', 
'form_schedule_start_date', 
'form_schedule_end_date', 
'form_schedule_start_hour', 
'form_schedule_end_hour', 
'form_approval_enable', 
'form_created_date', 
'form_created_by', 
'esl_enable', 
'esl_from_name', 
'esl_from_email_address', 
'esl_bcc_email_address', 
'esl_replyto_email_address', 
'esl_subject', 'esl_content', 
'esl_plain_text', 
'esl_pdf_enable', 
'esl_pdf_content', 
'esr_enable', 
'esr_email_address', 
'esr_from_name', 
'esr_from_email_address', 
'esr_bcc_email_address', 
'esr_replyto_email_address', 
'esr_subject', 
'esr_content', 
'esr_plain_text', 
'esr_pdf_enable', 
'esr_pdf_content', 
'payment_enable_merchant', 
'payment_merchant_type', 
'payment_paypal_email', 
'payment_paypal_language', 
'payment_currency', 
'payment_show_total', 
'payment_total_location', 
'payment_enable_recurring', 
'payment_recurring_cycle', 
'payment_recurring_unit', 
'payment_enable_trial', 
'payment_trial_period', 
'payment_trial_unit', 
'payment_trial_amount', 
'payment_enable_setupfee', 
'payment_setupfee_amount', 
'payment_price_type', 
'payment_price_amount', 
'payment_price_name', 
'payment_stripe_live_secret_key', 
'payment_stripe_live_public_key', 
'payment_stripe_test_secret_key', 
'payment_stripe_test_public_key', 
'payment_stripe_enable_test_mode', 
'payment_stripe_enable_receipt', 
'payment_stripe_receipt_element_id', 
'payment_stripe_enable_payment_request_button', 
'payment_stripe_account_country', 
'payment_paypal_rest_live_clientid', 
'payment_paypal_rest_live_secret_key',
'payment_paypal_rest_test_clientid', 
'payment_paypal_rest_test_secret_key', 
'payment_paypal_rest_enable_test_mode', 
'payment_authorizenet_live_apiloginid', 
'payment_authorizenet_live_transkey', 
'payment_authorizenet_test_apiloginid', 
'payment_authorizenet_test_transkey', 
'payment_authorizenet_enable_test_mode', 
'payment_authorizenet_save_cc_data', 
'payment_authorizenet_enable_email', 
'payment_authorizenet_email_element_id', 
'payment_braintree_live_merchant_id', 
'payment_braintree_live_public_key', 
'payment_braintree_live_private_key', 
'payment_braintree_live_encryption_key', 
'payment_braintree_test_merchant_id', 
'payment_braintree_test_public_key', 
'payment_braintree_test_private_key', 
'payment_braintree_test_encryption_key', 
'payment_braintree_enable_test_mode', 
'payment_paypal_enable_test_mode', 
'payment_enable_invoice', 
'payment_invoice_email', 
'payment_delay_notifications', 
'payment_ask_billing', 
'payment_ask_shipping', 
'payment_enable_tax', 
'payment_tax_rate', 
'payment_enable_discount', 
'payment_discount_type', 
'payment_discount_amount', 
'payment_discount_code', 
'payment_discount_element_id', 
'payment_discount_max_usage', 
'payment_discount_expiry_date', 
'logic_field_enable', 
'logic_page_enable', 
'logic_email_enable', 
'logic_webhook_enable',
'logic_success_enable',
'webhook_enable', 
'webhook_url', 
'webhook_method', 
'form_encryption_enable', 
'form_encryption_public_key', 
'creator_id'




*/