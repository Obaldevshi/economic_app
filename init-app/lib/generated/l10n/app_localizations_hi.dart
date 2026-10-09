// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get financialSettings => 'वित्तीय सेटिंग';

  @override
  String get financialRegion => 'वित्तीय क्षेत्र';

  @override
  String get recordCurrency => 'रिकॉर्ड की मुद्रा';

  @override
  String get displayCurrency => 'दिखाने की मुद्रा';

  @override
  String get currencyLedgerHint =>
      'रिकॉर्ड की मुद्रा बदलने पर अलग बही खुलती है। पुराने रिकॉर्ड और लक्ष्य अपनी मुद्रा में रहते हैं। समान मूल्य देखने के लिए दिखाने की मुद्रा बदलें।';

  @override
  String get regionalDefaultsHint =>
      'क्षेत्र मुद्रा, शुरुआती कीमतें और संदर्भ दर सुझाता है। कीमतें केवल खाली बही में जुड़ती हैं; आपके बदलाव सुरक्षित रहते हैं।';

  @override
  String get applyRegionDefaults => 'क्षेत्रीय सेटिंग लागू करें';

  @override
  String get conversionHint =>
      'रूस के केंद्रीय बैंक की नवीनतम आधिकारिक दर से रूपांतरण। रिकॉर्ड नहीं बदलते। यह बैंक की खरीद दर या भविष्यवाणी नहीं है; जमा ब्याज, कर और शुल्क नहीं बदलते।';

  @override
  String get rateReferenceHint =>
      'ब्याज दर बदलने योग्य अनुमान है, लाभ का वादा नहीं। स्रोत और अवधि नीचे दिए हैं।';

  @override
  String get rateNeedsInput =>
      'इस क्षेत्र के लिए सत्यापित संदर्भ नहीं: शुरुआती दर 0%। अपनी जमा की शर्तें दर्ज करें।';

  @override
  String exchangeRateDate(String date) {
    return 'रूसी केंद्रीय बैंक दर · $date';
  }

  @override
  String get currencyChanged =>
      'रिकॉर्ड की मुद्रा बदल गई। रीफ़्रेश करके फिर प्रयास करें।';

  @override
  String get starterPricesHint =>
      'मूल कीमतें बदलने योग्य शुरुआती अनुमान हैं, सांख्यिकीय औसत नहीं। इन्हें अपनी खरीद के अनुसार बदलें।';

  @override
  String get widgetEmptyHint =>
      'आवेगपूर्ण खरीद में अधिकतम तीन पसंदीदा चुनें। बचत की पुष्टि के लिए टैप करें।';

  @override
  String get chooseLanguage => 'भाषा चुनें';

  @override
  String get coinLanguageHint =>
      'लोगो का मुद्रा चिह्न एक क्षेत्रीय संकेत है। भाषा बदलने से रकम का रूपांतरण या रिकॉर्ड की मुद्रा नहीं बदलती।';

  @override
  String get appName => 'खर्च नहीं किया';

  @override
  String get appTagline => 'छोटे फैसले। बड़ी बचत।';

  @override
  String get welcomeBack => 'फिर से स्वागत है';

  @override
  String get loginSubtitle => 'जारी रखने के लिए लॉग इन करें';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get registerSubtitle => 'शुरू करने के लिए जानकारी भरें';

  @override
  String get login => 'लॉग इन';

  @override
  String get register => 'पंजीकरण';

  @override
  String get email => 'ईमेल';

  @override
  String get emailHint => 'अपना ईमेल दर्ज करें';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordHint => 'अपना पासवर्ड दर्ज करें';

  @override
  String get createPasswordHint => 'पासवर्ड बनाएं';

  @override
  String get firstName => 'नाम';

  @override
  String get firstNameHint => 'अपना नाम दर्ज करें';

  @override
  String get lastName => 'उपनाम';

  @override
  String get lastNameHint => 'अपना उपनाम दर्ज करें';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get dontHaveAccount => 'खाता नहीं है?';

  @override
  String get alreadyHaveAccount => 'पहले से खाता है?';

  @override
  String get signUp => 'साइन अप करें';

  @override
  String get signIn => 'लॉग इन करें';

  @override
  String get or => 'या';

  @override
  String get createAccountButton => 'खाता बनाएं';

  @override
  String get accountCreatedSuccessfully => 'खाता बन गया';

  @override
  String get home => 'बचत';

  @override
  String get homeWelcome => 'डिज़ाइन सिस्टम';

  @override
  String get homeDescription =>
      'रंग, टाइपोग्राफी और घटक देखें। थीम और भाषा तुरंत बदलें।';

  @override
  String get homeFeatureCategories => 'श्रेणियां और पृष्ठ प्रबंधित करें';

  @override
  String get homeFeatureProfile => 'प्रोफ़ाइल, थीम और भाषा';

  @override
  String get homeUiKitTitle => 'यूआई किट';

  @override
  String get homeUiKitSubtitle => 'डिज़ाइन सिस्टम';

  @override
  String get homeUiKitDescription =>
      'सुगम उपयोग के लिए हल्की सतहें, शैलियां और घटक।';

  @override
  String get homeSectionAppearance => 'दिखावट';

  @override
  String get homeSectionColors => 'रंग';

  @override
  String get homeSectionTypography => 'टाइपोग्राफी';

  @override
  String get homeSectionComponents => 'घटक';

  @override
  String get homeSectionTokens => 'डिज़ाइन मान';

  @override
  String get colorPrimary => 'मुख्य';

  @override
  String get colorPrimaryLight => 'हल्का मुख्य रंग';

  @override
  String get colorPrimaryDark => 'गहरा मुख्य रंग';

  @override
  String get colorSecondary => 'द्वितीयक';

  @override
  String get colorSuccess => 'सफलता';

  @override
  String get colorWarning => 'चेतावनी';

  @override
  String get colorError => 'त्रुटि';

  @override
  String get colorSurface => 'सतह';

  @override
  String get colorBackground => 'पृष्ठभूमि';

  @override
  String get homeShowDialog => 'संवाद दिखाएं';

  @override
  String get homeDialogDemoTitle => 'संवाद उदाहरण';

  @override
  String get homeDialogDemoContent => 'यूआई किट का पुष्टि संवाद।';

  @override
  String get homeFontFamily => 'फ़ॉन्ट परिवार';

  @override
  String get homeFontRegular => 'सामान्य';

  @override
  String get homeFontMedium => 'मध्यम';

  @override
  String get homeFontBold => 'मोटा';

  @override
  String get homeSpacing => 'अंतर';

  @override
  String get homeRadius => 'किनारे की त्रिज्या';

  @override
  String get homeGlassTokens => 'सतहें';

  @override
  String get homeDemoInputLabel => 'उदाहरण फ़ील्ड';

  @override
  String get homeDemoInputHint => 'कुछ लिखें…';

  @override
  String get homeToggleLoading => 'लोडिंग बदलें';

  @override
  String get homeGlassOnLight => 'डिफ़ॉल्ट';

  @override
  String get homeGlassPanel => 'पैनल';

  @override
  String get homeGlassOnGradient => 'विशेष रंग';

  @override
  String get homeTypographySample => 'छोटे फैसले, बड़े बदलाव';

  @override
  String get categories => 'श्रेणियां';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get profileSectionAccount => 'खाता';

  @override
  String get addCategory => 'श्रेणी जोड़ें';

  @override
  String get editCategory => 'श्रेणी संपादित करें';

  @override
  String get deleteCategory => 'श्रेणी हटाएं';

  @override
  String get categoryName => 'श्रेणी का नाम';

  @override
  String get categoryNameRequired => 'श्रेणी का नाम आवश्यक है';

  @override
  String get categoryNameTooShort => 'नाम बहुत छोटा है';

  @override
  String get updateCategory => 'श्रेणी अपडेट करें';

  @override
  String get deleteCategoryConfirmation => 'यह श्रेणी हटाएं?';

  @override
  String get categoryDeletedSuccessfully => 'श्रेणी हटा दी गई';

  @override
  String get categoryUpdatedSuccessfully => 'श्रेणी अपडेट हो गई';

  @override
  String get noCategoriesYet => 'अभी कोई श्रेणी नहीं';

  @override
  String get noCategoriesFound => 'कोई श्रेणी नहीं मिली';

  @override
  String get addFirstCategory => 'पहली श्रेणी जोड़ें';

  @override
  String get tryDifferentSearch => 'दूसरी खोज आज़माएं';

  @override
  String get searchCategories => 'श्रेणियां खोजें';

  @override
  String get addNewCategoryTooltip => 'श्रेणी जोड़ें';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get updatePersonalInfo => 'व्यक्तिगत जानकारी अपडेट करें';

  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get saveChanges => 'बदलाव सहेजें';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get changePasswordTitle => 'पासवर्ड बदलें';

  @override
  String get changePasswordButton => 'पासवर्ड अपडेट करें';

  @override
  String get security => 'सुरक्षा';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get logoutConfirmation => 'लॉग आउट करें?';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सहेजें';

  @override
  String get error => 'त्रुटि';

  @override
  String get loading => 'लोड हो रहा है';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get version => 'संस्करण';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmNewPassword => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get enterCurrentPassword => 'वर्तमान पासवर्ड दर्ज करें';

  @override
  String get enterNewPassword => 'नया पासवर्ड दर्ज करें';

  @override
  String get confirmYourNewPassword => 'नए पासवर्ड की पुष्टि करें';

  @override
  String get currentPasswordRequired => 'वर्तमान पासवर्ड आवश्यक है';

  @override
  String get newPasswordRequired => 'नया पासवर्ड आवश्यक है';

  @override
  String get passwordChangedSuccessfully => 'पासवर्ड बदल गया';

  @override
  String get profileUpdatedSuccessfully => 'प्रोफ़ाइल अपडेट हो गई';

  @override
  String get accountDeletedSuccessfully => 'खाता हटा दिया गया';

  @override
  String get deleteAccount => 'खाता हटाएं';

  @override
  String get deleteAccountConfirmation => 'अपना खाता हटाएं?';

  @override
  String get deleteAccountDescription => 'खाता और सभी डेटा स्थायी रूप से हटाएं';

  @override
  String get deleteAccountWarning =>
      'यह कार्रवाई वापस नहीं की जा सकती। आपका सभी डेटा स्थायी रूप से हटा दिया जाएगा।';

  @override
  String get dangerZone => 'सावधानी क्षेत्र';

  @override
  String get manageAccount => 'खाता प्रबंधित करें';

  @override
  String get emailRequired => 'ईमेल आवश्यक है';

  @override
  String get emailInvalid => 'मान्य ईमेल दर्ज करें';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक है';

  @override
  String passwordTooShort(int minLength) {
    return 'पासवर्ड में कम से कम $minLength अक्षर होने चाहिए';
  }

  @override
  String newPasswordTooShort(int minLength) {
    return 'नए पासवर्ड में कम से कम $minLength अक्षर होने चाहिए';
  }

  @override
  String fieldRequired(String fieldName) {
    return '$fieldName आवश्यक है';
  }

  @override
  String fieldTooShort(String fieldName, int minLength) {
    return '$fieldName में कम से कम $minLength अक्षर होने चाहिए';
  }

  @override
  String nameLettersOnly(String fieldName) {
    return '$fieldName में केवल अक्षर होने चाहिए';
  }

  @override
  String numberRequired(Object fieldName) {
    return '$fieldName आवश्यक है';
  }

  @override
  String numberInvalid(Object fieldName) {
    return '$fieldName में मान्य संख्या दर्ज करें';
  }

  @override
  String numberMustBePositive(Object fieldName) {
    return '$fieldName शून्य से बड़ा होना चाहिए';
  }

  @override
  String get passwordsDontMatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get last7Days => 'पिछले 7 दिन';

  @override
  String get last30Days => 'पिछले 30 दिन';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get past => 'पहले';

  @override
  String get ok => 'ठीक है';

  @override
  String get offlineBanner => 'इंटरनेट कनेक्शन नहीं है';

  @override
  String get loadMore => 'और लोड करें';

  @override
  String get appearance => 'दिखावट';

  @override
  String get appearanceDescription => 'हल्की, गहरी या सिस्टम थीम';

  @override
  String get language => 'भाषा';

  @override
  String get languageDescription => 'इंटरफ़ेस की भाषा';

  @override
  String get languageSystem => 'सिस्टम (बिना चिह्न)';

  @override
  String get themeSystem => 'सिस्टम';

  @override
  String get themeLight => 'हल्की';

  @override
  String get themeDark => 'गहरी';

  @override
  String get errorBadRequest => 'अमान्य अनुरोध';

  @override
  String get errorUnauthorized => 'लॉग इन आवश्यक है';

  @override
  String get errorAccessDenied => 'प्रवेश अस्वीकृत';

  @override
  String get errorNotFound => 'नहीं मिला';

  @override
  String get errorTimeout => 'अनुरोध का समय समाप्त';

  @override
  String get errorValidation => 'सत्यापन त्रुटि';

  @override
  String get errorTooManyRequests => 'बहुत अधिक अनुरोध';

  @override
  String get errorServer => 'सर्वर त्रुटि';

  @override
  String get errorBadGateway => 'गेटवे त्रुटि';

  @override
  String get errorServiceUnavailable => 'सेवा उपलब्ध नहीं है';

  @override
  String get errorGatewayTimeout => 'गेटवे का समय समाप्त';

  @override
  String get errorClient => 'क्लाइंट त्रुटि';

  @override
  String get errorRequestCancelled => 'अनुरोध रद्द';

  @override
  String get errorInvalidCredentials => 'लॉग इन जानकारी गलत है';

  @override
  String get errorResourceExists => 'यह संसाधन पहले से मौजूद है';

  @override
  String get savingsTagline => 'हर टाली गई आवेगपूर्ण खरीद से अपना भविष्य बनाएं';

  @override
  String get recordSaving => 'मैंने खर्च नहीं किया';

  @override
  String get savedToday => 'आज की बचत';

  @override
  String get savedThisMonth => 'इस महीने';

  @override
  String get savedTotal => 'कुल दर्ज बचत';

  @override
  String get investedTotal => 'वास्तव में अलग रखी रकम';

  @override
  String get monthlyPace => 'मासिक गति';

  @override
  String get futureProjection => 'भविष्य की बचत';

  @override
  String get yearsAtCurrentPace => 'वर्ष, वर्तमान गति पर';

  @override
  String get interestIncome => 'ब्याज आय';

  @override
  String get contributions => 'आपके योगदान';

  @override
  String get savingsDynamics => 'महीने के अनुसार बचत';

  @override
  String get recentSavings => 'हाल के फैसले';

  @override
  String get noSavingsYet => 'अभी कोई बचत दर्ज नहीं';

  @override
  String get habits => 'आवेगपूर्ण खरीद';

  @override
  String get habitsDescription =>
      'उन खरीदों की कीमतें और शॉर्टकट बदलें जिन्हें टालना चाहते हैं';

  @override
  String get history => 'इतिहास';

  @override
  String get historyDescription => 'आपके भविष्य के लिए लिया हर छोटा फैसला';

  @override
  String get goals => 'लक्ष्य';

  @override
  String get addGoal => 'लक्ष्य जोड़ें';

  @override
  String get goalName => 'लक्ष्य का नाम';

  @override
  String get targetAmount => 'लक्ष्य राशि';

  @override
  String get noGoalsYet => 'प्रगति देखने के लिए लक्ष्य जोड़ें';

  @override
  String get impulseItem => 'कौन सी खरीद टाली?';

  @override
  String get amount => 'राशि';

  @override
  String get actuallySetAside => 'मैंने यह पैसा वास्तव में अलग रखा';

  @override
  String get actuallySetAsideDescription =>
      'संभावित बचत को वास्तविक पूंजी से अलग करता है';

  @override
  String get noteOptional => 'नोट (वैकल्पिक)';

  @override
  String get record => 'दर्ज करें';

  @override
  String get editHabit => 'आवेगपूर्ण खरीद संपादित करें';

  @override
  String get addHabit => 'आवेगपूर्ण खरीद जोड़ें';

  @override
  String get habitName => 'खरीद का नाम';

  @override
  String get defaultPrice => 'सामान्य कीमत';

  @override
  String get timesPerWeek => 'प्रति सप्ताह बार';

  @override
  String get frequencyZeroHint => '0 का अर्थ महीने में एक बार है';

  @override
  String get oncePerMonth => 'महीने में एक बार';

  @override
  String get chooseIcon => 'आइकन';

  @override
  String get deleteHabitConfirmation =>
      'यह शॉर्टकट हटाएं? पुराना इतिहास बना रहेगा।';

  @override
  String get deleteSavingConfirmation => 'यह बचत रिकॉर्ड हटाएं?';

  @override
  String get noHabits => 'अभी कोई खरीद शॉर्टकट नहीं';

  @override
  String get noHistory => 'आपकी बचत का इतिहास यहां दिखेगा';

  @override
  String get weekShort => 'सप्ताह';

  @override
  String get rateAndHorizon => 'दर और अवधि';

  @override
  String get annualRate => 'जमा की वार्षिक ब्याज दर';

  @override
  String get projectionYears => 'अनुमान के वर्ष';

  @override
  String get apply => 'लागू करें';

  @override
  String get noData => 'अभी पर्याप्त डेटा नहीं है';

  @override
  String get quickChoices => 'त्वरित चुनाव';

  @override
  String get quickChoicesDescription => 'अभी टाली गई खरीद चुनें';

  @override
  String get recordThisSaving => 'खर्च नहीं किया';

  @override
  String get annualPotential => 'वार्षिक संभावना';

  @override
  String get weeklyPotential => 'सामान्य सप्ताह';

  @override
  String get savingsBreakdown => 'आपकी पूंजी कैसे बनती है';

  @override
  String get topSavingsSources => 'बचत के प्रमुख स्रोत';

  @override
  String get currentPace => 'वर्तमान गति';

  @override
  String get decisionCount => 'भविष्य के लिए फैसले';

  @override
  String get allSavings => 'सभी फैसले';

  @override
  String get realSavings => 'वास्तव में अलग रखी रकम';

  @override
  String get potentialSavings => 'अभी अलग नहीं रखी';

  @override
  String get compoundEffect => 'चक्रवृद्धि ब्याज का प्रभाव';

  @override
  String get projectionExplanation =>
      'यह एक अनुमान है, खाते का शेष नहीं: हर दर्ज बचत अलग रखी जाती है, पिछले 90 दिनों की गति जारी रहती है और ब्याज मासिक चक्रवृद्धि होता है। दर काल्पनिक है; रिटर्न की गारंटी नहीं है।';

  @override
  String get impulseAnnualHint => 'चुनी गई टालने की आवृत्ति पर';

  @override
  String projectionScenario(int years, String rate) {
    return 'मासिक जमा के साथ $rate% वार्षिक दर पर $years वर्ष बाद। माना गया है कि सारी बचत अलग रखी जाती है; रिटर्न की गारंटी नहीं है।';
  }

  @override
  String projectionAfterYears(int years) {
    return 'ब्याज सहित $years वर्ष बाद';
  }

  @override
  String get oneSkippedPurchase => 'एक टाली गई खरीद';

  @override
  String get regularlySkippedPurchases => 'नियमित रूप से टाली गई खरीद';

  @override
  String get editImpulse => 'बदलें';

  @override
  String get historyOverview => 'आपके फैसलों का सार';

  @override
  String get noFilteredHistory =>
      'लोड किए गए रिकॉर्ड में इस समूह का कोई फैसला नहीं';

  @override
  String get loadMoreHistory => 'और दिखाएं';

  @override
  String historyLoadedCount(int count, int total) {
    return '$total में से $count फैसले लोड हुए';
  }

  @override
  String get projectionTableTitle => 'वर्ष के अनुसार राशि';

  @override
  String get projectionTableYear => 'वर्ष';

  @override
  String get projectionTableTotal => 'कुल';

  @override
  String get habitPaused => 'रुकी हुई · कुल संभावना में शामिल नहीं';

  @override
  String get showPassword => 'पासवर्ड दिखाएं';

  @override
  String get hidePassword => 'पासवर्ड छिपाएं';

  @override
  String get editSaving => 'रिकॉर्ड संपादित करें';

  @override
  String get moneyFormatError =>
      'अधिकतम 10 अंकों और 2 दशमलव स्थानों वाली राशि दर्ज करें';

  @override
  String get frequencyRangeError => '0 से 50 तक पूर्णांक दर्ज करें';

  @override
  String get habitActive => 'यह आदत शामिल करें';

  @override
  String get habitActiveDescription =>
      'रोकने पर त्वरित चुनाव और कुल संभावना से हटता है; इतिहास रहता है';

  @override
  String get editGoal => 'लक्ष्य संपादित करें';

  @override
  String get goalReached => 'लक्ष्य राशि अलग रखी गई है';

  @override
  String goalRemaining(String amount) {
    return 'अभी अलग रखनी है: $amount';
  }

  @override
  String get goalProgressExplanation =>
      'प्रगति केवल इस लक्ष्य को आवंटित पैसे से गिनी जाती है। एक ही राशि कई लक्ष्यों में नहीं गिनी जाती।';

  @override
  String get rateFormatError =>
      'अधिकतम दो दशमलव स्थानों के साथ 0 से 100% तक दर दर्ज करें';

  @override
  String get savingRecordedMessage => 'फैसला दर्ज हुआ';

  @override
  String get savingUpdatedMessage => 'रिकॉर्ड अपडेट हुआ';

  @override
  String get habitSavedMessage => 'आदत सहेजी गई';

  @override
  String get goalSavedMessage => 'लक्ष्य सहेजा गया';

  @override
  String get settingsSavedMessage => 'अनुमान अपडेट हुआ';

  @override
  String get entryDeletedMessage => 'रिकॉर्ड हटाया गया';

  @override
  String get changesSavedMessage => 'बदलाव सहेजे गए';

  @override
  String get savingsSummaryUnavailable =>
      'कुल रकम उपलब्ध नहीं; आपका इतिहास मौजूद है';

  @override
  String get savingsDataLoadFailed =>
      'डेटा लोड नहीं हुआ। कनेक्शन जांचकर फिर कोशिश करें।';

  @override
  String get refresh => 'ताज़ा करें';

  @override
  String get monthlyAmounts => 'मासिक रकम';

  @override
  String get customSaving => 'दूसरा फैसला';

  @override
  String get customSavingHint => 'एक बार का रिकॉर्ड: नई आदत नहीं बनेगी।';

  @override
  String oneDecisionProjection(int years, String amount) {
    return 'एक टाली गई खरीद: $years वर्ष में $amount।';
  }

  @override
  String oneDecisionProjectionHint(String rate) {
    return 'यदि यह राशि अभी $rate% वार्षिक दर पर मासिक चक्रवृद्धि के साथ अलग रखी जाए, बिना आगे योगदान के। यह काल्पनिक अनुमान है, रिटर्न का वादा नहीं।';
  }

  @override
  String get impulseIconCoffee => 'कॉफ़ी';

  @override
  String get impulseIconRestaurant => 'कैफ़े और रेस्टोरेंट';

  @override
  String get impulseIconDelivery => 'खाने की डिलीवरी';

  @override
  String get impulseIconSmoking => 'सिगरेट';

  @override
  String get impulseIconTaxi => 'टैक्सी';

  @override
  String get impulseIconShopping => 'खरीदारी';

  @override
  String get impulseIconSubscription => 'सदस्यताएं';

  @override
  String get impulseIconOther => 'अन्य';

  @override
  String get scenarioComparison => 'अगर मैं कम बार खरीदूं तो?';

  @override
  String scenarioPrice(String amount, String rate) {
    return 'कीमत: $amount · काल्पनिक दर: $rate%';
  }

  @override
  String get scenarioBaseline => 'अभी';

  @override
  String get scenarioModerate => 'मध्यम विकल्प';

  @override
  String get scenarioMinimal => 'न्यूनतम विकल्प';

  @override
  String scenarioFrequency(String name, int count) {
    return '$name: प्रति सप्ताह $count खरीद';
  }

  @override
  String get scenarioOwnMoney => 'योगदान';

  @override
  String get scenarioAssumptions =>
      'वर्तमान आवृत्ति से अंतर। साल में 52 सप्ताह; सारी बचत हर महीने के अंत में जमा होती है और ब्याज मासिक चक्रवृद्धि है। शुरुआती पूंजी, कर या महंगाई शामिल नहीं; रिटर्न की गारंटी नहीं। यह गणना इतिहास में रिकॉर्ड नहीं बनाती।';

  @override
  String get allocateGoal => 'पैसा आवंटित करें';

  @override
  String get allocatedAmount => 'इस लक्ष्य को कुल आवंटित राशि';

  @override
  String unallocatedMoney(String amount) {
    return 'लक्ष्यों के लिए उपलब्ध: $amount';
  }

  @override
  String allocationCapacity(String amount) {
    return 'इस लक्ष्य को अधिकतम $amount आवंटित कर सकते हैं';
  }

  @override
  String get allocationInvalid =>
      'अधिकतम दो दशमलव स्थानों वाली 0 या अधिक राशि दर्ज करें';

  @override
  String get allocationTooLarge => 'उपलब्ध रकम कम है या लक्ष्य राशि पार हो गई';

  @override
  String get goalBelowAllocation => 'पहले अतिरिक्त आवंटन वापस करें';

  @override
  String get releaseAllocationsFirst =>
      'यह पैसा लक्ष्यों को आवंटित है। पहले आवंटन घटाएं।';

  @override
  String get releaseGoalMoney => 'इस लक्ष्य का पैसा वापस करें';

  @override
  String get allocationHint =>
      'कुल आवंटन तय करें, अतिरिक्त जमा नहीं। 0 से पैसा उपलब्ध शेष में लौटता है। कोई बैंक ट्रांसफ़र नहीं होता।';

  @override
  String get allocationSaved => 'पैसा आवंटित हुआ';

  @override
  String get savingReceipt => 'टाली गई खरीद की रसीद';

  @override
  String get weeklyReceipt => '7 दिनों के मेरे फैसले';

  @override
  String get receiptPurchaseNotMade => 'खरीद नहीं की गई';

  @override
  String get receiptPrivateDecision => 'खुद के लिए एक फैसला';

  @override
  String get receiptFooter =>
      'टाली गई खरीद का निजी रिकॉर्ड। यह बैंक विवरण या कर रसीद नहीं है।';

  @override
  String get receiptHideName => 'खरीद का नाम छिपाएं';

  @override
  String get receiptExport => 'PNG सहेजें / साझा करें';

  @override
  String get receiptExportFailed => 'रसीद एक्सपोर्ट नहीं हुई। फिर कोशिश करें।';

  @override
  String get favoriteActions => 'मेरे तीन त्वरित फैसले';

  @override
  String get favoriteActionsHint =>
      'आदत के मेन्यू में पसंदीदा में जोड़ें चुनें। अधिकतम तीन क्रियाएं यहां और फ़ोन विजेट में दिखेंगी। जोड़ने के लिए होम स्क्रीन दबाकर रखें → विजेट → खर्च नहीं किया।';

  @override
  String get addFavorite => 'पसंदीदा / विजेट में जोड़ें';

  @override
  String get removeFavorite => 'पसंदीदा से हटाएं';

  @override
  String get favoriteLimit => 'तीन पसंदीदा पहले से हैं। पहले एक हटाएं।';

  @override
  String get widgetItemUnavailable =>
      'यह आइटम हटाया गया, रोका गया या इस खाते के लिए उपलब्ध नहीं है';
}
