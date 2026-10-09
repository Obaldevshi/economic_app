// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get financialSettings => 'الإعدادات المالية';

  @override
  String get financialRegion => 'المنطقة المالية';

  @override
  String get recordCurrency => 'عملة السجلات';

  @override
  String get displayCurrency => 'عملة العرض';

  @override
  String get currencyLedgerHint =>
      'تغيير عملة السجلات يفتح دفترًا منفصلًا. تبقى السجلات والأهداف السابقة بعملتها. استخدم عملة العرض لمشاهدة القيمة المكافئة.';

  @override
  String get regionalDefaultsHint =>
      'تقترح المنطقة العملة والأسعار الأولية ومعدلًا مرجعيًا. تُضاف الأسعار إلى الدفتر الفارغ فقط؛ وتُحفظ تعديلاتك.';

  @override
  String get applyRegionDefaults => 'تطبيق إعدادات المنطقة';

  @override
  String get conversionHint =>
      'تحويل بآخر سعر رسمي للبنك المركزي الروسي. لا تتغير السجلات. ليس سعر تداول مصرفي أو توقعًا؛ ولا تُحوّل فوائد الودائع أو الضرائب أو الرسوم.';

  @override
  String get rateReferenceHint =>
      'المعدل سيناريو قابل للتعديل وليس وعدًا بعائد. المصدر والفترة مذكوران أدناه.';

  @override
  String get rateNeedsInput =>
      'لا يوجد مرجع موثّق للمنطقة: المعدل الأولي 0%. أدخل شروط وديعتك.';

  @override
  String exchangeRateDate(String date) {
    return 'سعر البنك المركزي الروسي · $date';
  }

  @override
  String get currencyChanged =>
      'تغيّرت عملة السجلات. حدّث البيانات وحاول مجددًا.';

  @override
  String get starterPricesHint =>
      'الأسعار الافتراضية تقديرات أولية قابلة للتعديل وليست متوسطات إحصائية. عدّلها حسب مشترياتك.';

  @override
  String get widgetEmptyHint =>
      'اختر حتى ثلاثة عناصر مفضلة في الشراء الاندفاعي. اضغط لتأكيد التوفير.';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get coinLanguageHint =>
      'رمز العملة في الشعار ارتباط إقليمي فقط. تغيير اللغة لا يحوّل المبالغ ولا يغيّر عملة سجلاتك.';

  @override
  String get appName => 'لم أنفق';

  @override
  String get appTagline => 'قرارات صغيرة. مدخرات أكبر.';

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول للمتابعة';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'أدخل بياناتك للبدء';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'التسجيل';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get createPasswordHint => 'أنشئ كلمة مرور';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get firstNameHint => 'أدخل اسمك الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get lastNameHint => 'أدخل اسم العائلة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get or => 'أو';

  @override
  String get createAccountButton => 'إنشاء حساب';

  @override
  String get accountCreatedSuccessfully => 'تم إنشاء الحساب';

  @override
  String get home => 'التوفير';

  @override
  String get homeWelcome => 'نظام التصميم';

  @override
  String get homeDescription =>
      'استكشف الألوان والخطوط والمكونات. غيّر المظهر واللغة مباشرة.';

  @override
  String get homeFeatureCategories => 'إدارة الفئات والصفحات';

  @override
  String get homeFeatureProfile => 'الملف الشخصي والمظهر واللغة';

  @override
  String get homeUiKitTitle => 'مجموعة الواجهة';

  @override
  String get homeUiKitSubtitle => 'نظام التصميم';

  @override
  String get homeUiKitDescription => 'أسطح وأنماط ومكونات خفيفة لأداء سلس.';

  @override
  String get homeSectionAppearance => 'المظهر';

  @override
  String get homeSectionColors => 'الألوان';

  @override
  String get homeSectionTypography => 'الخطوط';

  @override
  String get homeSectionComponents => 'المكونات';

  @override
  String get homeSectionTokens => 'متغيرات التصميم';

  @override
  String get colorPrimary => 'أساسي';

  @override
  String get colorPrimaryLight => 'أساسي فاتح';

  @override
  String get colorPrimaryDark => 'أساسي داكن';

  @override
  String get colorSecondary => 'ثانوي';

  @override
  String get colorSuccess => 'نجاح';

  @override
  String get colorWarning => 'تحذير';

  @override
  String get colorError => 'خطأ';

  @override
  String get colorSurface => 'سطح';

  @override
  String get colorBackground => 'خلفية';

  @override
  String get homeShowDialog => 'إظهار مربع الحوار';

  @override
  String get homeDialogDemoTitle => 'مثال لمربع الحوار';

  @override
  String get homeDialogDemoContent => 'مربع حوار للتأكيد من مجموعة الواجهة.';

  @override
  String get homeFontFamily => 'عائلة الخط';

  @override
  String get homeFontRegular => 'عادي';

  @override
  String get homeFontMedium => 'متوسط';

  @override
  String get homeFontBold => 'عريض';

  @override
  String get homeSpacing => 'التباعد';

  @override
  String get homeRadius => 'استدارة الحواف';

  @override
  String get homeGlassTokens => 'الأسطح';

  @override
  String get homeDemoInputLabel => 'حقل تجريبي';

  @override
  String get homeDemoInputHint => 'اكتب شيئًا…';

  @override
  String get homeToggleLoading => 'تبديل التحميل';

  @override
  String get homeGlassOnLight => 'افتراضي';

  @override
  String get homeGlassPanel => 'لوحة';

  @override
  String get homeGlassOnGradient => 'تمييز';

  @override
  String get homeTypographySample => 'قرارات صغيرة وتغييرات كبيرة';

  @override
  String get categories => 'الفئات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get profileSectionAccount => 'الحساب';

  @override
  String get addCategory => 'إضافة فئة';

  @override
  String get editCategory => 'تعديل الفئة';

  @override
  String get deleteCategory => 'حذف الفئة';

  @override
  String get categoryName => 'اسم الفئة';

  @override
  String get categoryNameRequired => 'اسم الفئة مطلوب';

  @override
  String get categoryNameTooShort => 'الاسم قصير جدًا';

  @override
  String get updateCategory => 'تحديث الفئة';

  @override
  String get deleteCategoryConfirmation => 'هل تريد حذف هذه الفئة؟';

  @override
  String get categoryDeletedSuccessfully => 'تم حذف الفئة';

  @override
  String get categoryUpdatedSuccessfully => 'تم تحديث الفئة';

  @override
  String get noCategoriesYet => 'لا توجد فئات بعد';

  @override
  String get noCategoriesFound => 'لم يتم العثور على فئات';

  @override
  String get addFirstCategory => 'أضف فئتك الأولى';

  @override
  String get tryDifferentSearch => 'جرّب بحثًا آخر';

  @override
  String get searchCategories => 'البحث عن فئات';

  @override
  String get addNewCategoryTooltip => 'إضافة فئة';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get updatePersonalInfo => 'حدّث بياناتك الشخصية';

  @override
  String get personalInformation => 'البيانات الشخصية';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get changePasswordButton => 'تحديث كلمة المرور';

  @override
  String get security => 'الأمان';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmation => 'هل تريد تسجيل الخروج؟';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get error => 'خطأ';

  @override
  String get loading => 'جارٍ التحميل';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get version => 'الإصدار';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get enterCurrentPassword => 'أدخل كلمة المرور الحالية';

  @override
  String get enterNewPassword => 'أدخل كلمة المرور الجديدة';

  @override
  String get confirmYourNewPassword => 'أكّد كلمة المرور الجديدة';

  @override
  String get currentPasswordRequired => 'كلمة المرور الحالية مطلوبة';

  @override
  String get newPasswordRequired => 'كلمة المرور الجديدة مطلوبة';

  @override
  String get passwordChangedSuccessfully => 'تم تغيير كلمة المرور';

  @override
  String get profileUpdatedSuccessfully => 'تم تحديث الملف الشخصي';

  @override
  String get accountDeletedSuccessfully => 'تم حذف الحساب';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountConfirmation => 'هل تريد حذف حسابك؟';

  @override
  String get deleteAccountDescription => 'حذف حسابك وجميع بياناتك نهائيًا';

  @override
  String get deleteAccountWarning =>
      'لا يمكن التراجع عن هذا الإجراء. ستُحذف جميع بياناتك نهائيًا.';

  @override
  String get dangerZone => 'منطقة الخطر';

  @override
  String get manageAccount => 'إدارة حسابك';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String passwordTooShort(int minLength) {
    return 'يجب ألا تقل كلمة المرور عن $minLength أحرف';
  }

  @override
  String newPasswordTooShort(int minLength) {
    return 'يجب ألا تقل كلمة المرور الجديدة عن $minLength أحرف';
  }

  @override
  String fieldRequired(String fieldName) {
    return '$fieldName مطلوب';
  }

  @override
  String fieldTooShort(String fieldName, int minLength) {
    return 'يجب ألا يقل $fieldName عن $minLength أحرف';
  }

  @override
  String nameLettersOnly(String fieldName) {
    return 'يجب أن يحتوي $fieldName على حروف فقط';
  }

  @override
  String numberRequired(Object fieldName) {
    return '$fieldName مطلوب';
  }

  @override
  String numberInvalid(Object fieldName) {
    return 'يجب أن يكون $fieldName رقمًا صحيحًا';
  }

  @override
  String numberMustBePositive(Object fieldName) {
    return 'يجب أن يكون $fieldName أكبر من صفر';
  }

  @override
  String get passwordsDontMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get last7Days => 'آخر 7 أيام';

  @override
  String get last30Days => 'آخر 30 يومًا';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get past => 'السابق';

  @override
  String get ok => 'حسنًا';

  @override
  String get offlineBanner => 'لا يوجد اتصال بالإنترنت';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get appearance => 'المظهر';

  @override
  String get appearanceDescription => 'مظهر فاتح أو داكن أو مظهر النظام';

  @override
  String get language => 'اللغة';

  @override
  String get languageDescription => 'لغة الواجهة';

  @override
  String get languageSystem => 'النظام (بلا رمز)';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get errorBadRequest => 'طلب غير صحيح';

  @override
  String get errorUnauthorized => 'تسجيل الدخول مطلوب';

  @override
  String get errorAccessDenied => 'تم رفض الوصول';

  @override
  String get errorNotFound => 'غير موجود';

  @override
  String get errorTimeout => 'انتهت مهلة الطلب';

  @override
  String get errorValidation => 'خطأ في التحقق';

  @override
  String get errorTooManyRequests => 'طلبات كثيرة جدًا';

  @override
  String get errorServer => 'خطأ في الخادم';

  @override
  String get errorBadGateway => 'خطأ في البوابة';

  @override
  String get errorServiceUnavailable => 'الخدمة غير متاحة';

  @override
  String get errorGatewayTimeout => 'انتهت مهلة البوابة';

  @override
  String get errorClient => 'خطأ في التطبيق';

  @override
  String get errorRequestCancelled => 'تم إلغاء الطلب';

  @override
  String get errorInvalidCredentials => 'بيانات الدخول غير صحيحة';

  @override
  String get errorResourceExists => 'المورد موجود بالفعل';

  @override
  String get savingsTagline => 'كل شراء اندفاعي تتجنبه يبني مستقبلك';

  @override
  String get recordSaving => 'لم أنفق';

  @override
  String get savedToday => 'وفّرت اليوم';

  @override
  String get savedThisMonth => 'هذا الشهر';

  @override
  String get savedTotal => 'إجمالي التوفير المسجل';

  @override
  String get investedTotal => 'المال المدّخر فعليًا';

  @override
  String get monthlyPace => 'الوتيرة الشهرية';

  @override
  String get futureProjection => 'المدخرات المستقبلية';

  @override
  String get yearsAtCurrentPace => 'سنوات بالوتيرة الحالية';

  @override
  String get interestIncome => 'عائد الفائدة';

  @override
  String get contributions => 'مساهماتك';

  @override
  String get savingsDynamics => 'التوفير حسب الشهر';

  @override
  String get recentSavings => 'القرارات الأخيرة';

  @override
  String get noSavingsYet => 'لم تسجّل أي توفير بعد';

  @override
  String get habits => 'الشراء الاندفاعي';

  @override
  String get habitsDescription =>
      'عدّل أسعار واختصارات المشتريات التي تريد تجنبها';

  @override
  String get history => 'السجل';

  @override
  String get historyDescription => 'كل قرار صغير ساهم في مستقبلك';

  @override
  String get goals => 'الأهداف';

  @override
  String get addGoal => 'إضافة هدف';

  @override
  String get goalName => 'اسم الهدف';

  @override
  String get targetAmount => 'المبلغ المستهدف';

  @override
  String get noGoalsYet => 'أضف هدفًا لمتابعة تقدمك';

  @override
  String get impulseItem => 'ما الشراء الذي تجنبته؟';

  @override
  String get amount => 'المبلغ';

  @override
  String get actuallySetAside => 'ادّخرت هذا المال فعليًا';

  @override
  String get actuallySetAsideDescription =>
      'يميّز التوفير المحتمل عن المال الفعلي';

  @override
  String get noteOptional => 'ملاحظة (اختيارية)';

  @override
  String get record => 'تسجيل';

  @override
  String get editHabit => 'تعديل الشراء الاندفاعي';

  @override
  String get addHabit => 'إضافة شراء اندفاعي';

  @override
  String get habitName => 'اسم الشراء الاندفاعي';

  @override
  String get defaultPrice => 'السعر المعتاد';

  @override
  String get timesPerWeek => 'مرات في الأسبوع';

  @override
  String get frequencyZeroHint => '0 يعني مرة في الشهر';

  @override
  String get oncePerMonth => 'مرة في الشهر';

  @override
  String get chooseIcon => 'الأيقونة';

  @override
  String get deleteHabitConfirmation =>
      'حذف هذا الاختصار؟ سيبقى السجل محفوظًا.';

  @override
  String get deleteSavingConfirmation => 'حذف سجل التوفير هذا؟';

  @override
  String get noHabits => 'لا توجد اختصارات للشراء بعد';

  @override
  String get noHistory => 'سيظهر سجل توفيرك هنا';

  @override
  String get weekShort => 'أسبوع';

  @override
  String get rateAndHorizon => 'المعدل والمدة';

  @override
  String get annualRate => 'معدل فائدة الوديعة السنوي';

  @override
  String get projectionYears => 'سنوات التوقع';

  @override
  String get apply => 'تطبيق';

  @override
  String get noData => 'لا توجد بيانات كافية بعد';

  @override
  String get quickChoices => 'اختيار سريع';

  @override
  String get quickChoicesDescription => 'اختر الشراء الذي تجنبته للتو';

  @override
  String get recordThisSaving => 'لم أنفق';

  @override
  String get annualPotential => 'الإمكانات السنوية';

  @override
  String get weeklyPotential => 'أسبوع معتاد';

  @override
  String get savingsBreakdown => 'كيف تتكوّن مدخراتك';

  @override
  String get topSavingsSources => 'أهم مصادر توفيرك';

  @override
  String get currentPace => 'الوتيرة الحالية';

  @override
  String get decisionCount => 'قرارات لمستقبلك';

  @override
  String get allSavings => 'جميع القرارات';

  @override
  String get realSavings => 'مدّخر فعليًا';

  @override
  String get potentialSavings => 'لم يُدّخر بعد';

  @override
  String get compoundEffect => 'أثر الفائدة المركّبة';

  @override
  String get projectionExplanation =>
      'هذا سيناريو وليس رصيد حساب: يُدّخر كل توفير مسجل، وتستمر وتيرة آخر 90 يومًا، وتتراكم الفائدة شهريًا. المعدل افتراضي والعوائد غير مضمونة.';

  @override
  String get impulseAnnualHint => 'وفق وتيرة التجنب التي اخترتها';

  @override
  String projectionScenario(int years, String rate) {
    return 'بعد $years سنة بمعدل $rate% سنويًا مع إيداعات شهرية. يُفترض ادّخار كل مبلغ تم توفيره؛ العوائد غير مضمونة.';
  }

  @override
  String projectionAfterYears(int years) {
    return 'بعد $years سنة مع الفائدة';
  }

  @override
  String get oneSkippedPurchase => 'شراء واحد تم تجنبه';

  @override
  String get regularlySkippedPurchases => 'تجنب الشراء بانتظام';

  @override
  String get editImpulse => 'تخصيص';

  @override
  String get historyOverview => 'نظرة على قراراتك';

  @override
  String get noFilteredHistory =>
      'لا توجد قرارات من هذه المجموعة ضمن السجلات المحمّلة';

  @override
  String get loadMoreHistory => 'عرض المزيد';

  @override
  String historyLoadedCount(int count, int total) {
    return 'تم تحميل $count من $total قرارًا';
  }

  @override
  String get projectionTableTitle => 'المبالغ سنة بسنة';

  @override
  String get projectionTableYear => 'السنة';

  @override
  String get projectionTableTotal => 'الإجمالي';

  @override
  String get habitPaused => 'متوقف · غير محسوب ضمن الإجمالي المحتمل';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get editSaving => 'تعديل السجل';

  @override
  String get moneyFormatError =>
      'أدخل مبلغًا لا يتجاوز 10 أرقام ومنزلتين عشريتين';

  @override
  String get frequencyRangeError => 'أدخل عددًا صحيحًا بين 0 و50';

  @override
  String get habitActive => 'تضمين هذه العادة';

  @override
  String get habitActiveDescription =>
      'الإيقاف يستبعدها من الاختيارات السريعة والإجمالي المحتمل؛ ويُحفظ السجل';

  @override
  String get editGoal => 'تعديل الهدف';

  @override
  String get goalReached => 'تم ادّخار المبلغ المستهدف';

  @override
  String goalRemaining(String amount) {
    return 'المتبقي للادّخار: $amount';
  }

  @override
  String get goalProgressExplanation =>
      'يُحسب التقدم من المال المخصص لهذا الهدف فقط. لا يُحسب المبلغ نفسه لأكثر من هدف.';

  @override
  String get rateFormatError =>
      'أدخل معدلًا بين 0 و100% بمنزلتين عشريتين كحد أقصى';

  @override
  String get savingRecordedMessage => 'تم تسجيل القرار';

  @override
  String get savingUpdatedMessage => 'تم تحديث السجل';

  @override
  String get habitSavedMessage => 'تم حفظ العادة';

  @override
  String get goalSavedMessage => 'تم حفظ الهدف';

  @override
  String get settingsSavedMessage => 'تم تحديث التوقع';

  @override
  String get entryDeletedMessage => 'تم حذف السجل';

  @override
  String get changesSavedMessage => 'تم حفظ التغييرات';

  @override
  String get savingsSummaryUnavailable =>
      'الإجماليات غير متاحة؛ سجلك ما زال محفوظًا';

  @override
  String get savingsDataLoadFailed =>
      'تعذر تحميل بياناتك. تحقق من الاتصال وحاول مجددًا.';

  @override
  String get refresh => 'تحديث';

  @override
  String get monthlyAmounts => 'المبالغ الشهرية';

  @override
  String get customSaving => 'قرار آخر';

  @override
  String get customSavingHint => 'سجل لمرة واحدة: لن تُنشأ عادة جديدة.';

  @override
  String oneDecisionProjection(int years, String amount) {
    return 'شراء واحد تم تجنبه: $amount بعد $years سنة.';
  }

  @override
  String oneDecisionProjectionHint(String rate) {
    return 'إذا ادّخرت هذا المبلغ الآن بمعدل $rate% سنويًا مع تراكم شهري ودون مساهمات أخرى. هذا سيناريو افتراضي وليس وعدًا بعائد.';
  }

  @override
  String get impulseIconCoffee => 'القهوة';

  @override
  String get impulseIconRestaurant => 'المقاهي والمطاعم';

  @override
  String get impulseIconDelivery => 'توصيل الطعام';

  @override
  String get impulseIconSmoking => 'السجائر';

  @override
  String get impulseIconTaxi => 'سيارة الأجرة';

  @override
  String get impulseIconShopping => 'التسوق';

  @override
  String get impulseIconSubscription => 'الاشتراكات';

  @override
  String get impulseIconOther => 'أخرى';

  @override
  String get scenarioComparison => 'ماذا لو اشتريت بوتيرة أقل؟';

  @override
  String scenarioPrice(String amount, String rate) {
    return 'السعر: $amount · المعدل الافتراضي: $rate%';
  }

  @override
  String get scenarioBaseline => 'حاليًا';

  @override
  String get scenarioModerate => 'خيار معتدل';

  @override
  String get scenarioMinimal => 'خيار أدنى';

  @override
  String scenarioFrequency(String name, int count) {
    return '$name: $count مشتريات في الأسبوع';
  }

  @override
  String get scenarioOwnMoney => 'المساهمات';

  @override
  String get scenarioAssumptions =>
      'الفرق عن الوتيرة الحالية. 52 أسبوعًا في السنة؛ يُودع كل التوفير في نهاية كل شهر بفائدة مركّبة شهرية. لا يشمل رأس مال أوليًا أو ضرائب أو تضخمًا؛ العوائد غير مضمونة. لا ينشئ هذا الحساب سجلات جديدة.';

  @override
  String get allocateGoal => 'تخصيص المال';

  @override
  String get allocatedAmount => 'إجمالي المبلغ المخصص لهذا الهدف';

  @override
  String unallocatedMoney(String amount) {
    return 'المتاح للأهداف: $amount';
  }

  @override
  String allocationCapacity(String amount) {
    return 'يمكنك تخصيص حتى $amount لهذا الهدف';
  }

  @override
  String get allocationInvalid =>
      'أدخل مبلغًا يساوي 0 أو أكثر بمنزلتين عشريتين كحد أقصى';

  @override
  String get allocationTooLarge =>
      'المال المتاح غير كافٍ أو تم تجاوز مبلغ الهدف';

  @override
  String get goalBelowAllocation => 'حرّر التخصيص الزائد أولًا';

  @override
  String get releaseAllocationsFirst =>
      'هذه الأموال مخصصة للأهداف. قلّل التخصيصات أولًا.';

  @override
  String get releaseGoalMoney => 'تحرير مال هذا الهدف';

  @override
  String get allocationHint =>
      'حدّد إجمالي التخصيص، وليس إيداعًا إضافيًا. 0 يعيد المال إلى الرصيد المتاح. لا يُنفّذ أي تحويل مصرفي.';

  @override
  String get allocationSaved => 'تم تخصيص المال';

  @override
  String get savingReceipt => 'إيصال شراء تم تجنبه';

  @override
  String get weeklyReceipt => 'قراراتي خلال 7 أيام';

  @override
  String get receiptPurchaseNotMade => 'لم يتم الشراء';

  @override
  String get receiptPrivateDecision => 'قرار لنفسي';

  @override
  String get receiptFooter =>
      'سجل شخصي لشراء تم تجنبه. ليس كشف حساب مصرفيًا أو إيصالًا ضريبيًا.';

  @override
  String get receiptHideName => 'إخفاء اسم الشراء';

  @override
  String get receiptExport => 'حفظ / مشاركة PNG';

  @override
  String get receiptExportFailed => 'تعذر تصدير الإيصال. حاول مجددًا.';

  @override
  String get favoriteActions => 'قراراتي الثلاثة السريعة';

  @override
  String get favoriteActionsHint =>
      'اختر إضافة إلى المفضلة من قائمة العادة. ستظهر حتى ثلاثة إجراءات هنا وفي أداة الهاتف. لإضافتها، اضغط مطولًا على الشاشة الرئيسية ← الأدوات ← لم أنفق.';

  @override
  String get addFavorite => 'إضافة إلى المفضلة / الأداة';

  @override
  String get removeFavorite => 'إزالة من المفضلة';

  @override
  String get favoriteLimit =>
      'لديك ثلاثة عناصر مفضلة بالفعل. أزل واحدًا أولًا.';

  @override
  String get widgetItemUnavailable =>
      'هذا العنصر محذوف أو متوقف أو غير متاح لهذا الحساب';
}
