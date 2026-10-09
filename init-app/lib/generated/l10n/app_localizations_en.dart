// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String projectionPeriod(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '# years',
      one: '# year',
    );
    return '$_temp0';
  }

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get financialSettings => 'Financial settings';

  @override
  String get financialRegion => 'Financial region';

  @override
  String get recordCurrency => 'Record currency';

  @override
  String get displayCurrency => 'Display currency';

  @override
  String get currencyLedgerHint =>
      'Record currency switches to a separate ledger. Existing records and goals keep their currency. Use display currency to view equivalents.';

  @override
  String get regionalDefaultsHint =>
      'Region suggests currency, starter prices and a rate reference. Prices are added only to an empty ledger; your edits are preserved.';

  @override
  String get applyRegionDefaults => 'Apply regional settings';

  @override
  String get conversionHint =>
      'Converted using the latest official CBR reference rate. Records remain unchanged. Not a bank\'s trading rate or a forecast; deposit interest, taxes and fees are not converted.';

  @override
  String get rateReferenceHint =>
      'Interest is an editable scenario, not a promised return. Reference source and period appear below.';

  @override
  String get rateNeedsInput =>
      'No verified reference for this region: the starting rate is 0%. Enter your deposit\'s terms.';

  @override
  String exchangeRateDate(String date) {
    return 'CBR rate · $date';
  }

  @override
  String get currencyChanged =>
      'Record currency changed. Refresh and try again.';

  @override
  String get starterPricesHint =>
      'Default prices are editable starter estimates, not statistical averages. Adjust them to your purchases.';

  @override
  String get widgetEmptyHint =>
      'Choose up to three favorites in the Impulses menu. Tap to confirm a saving.';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get coinLanguageHint =>
      'The logo\'s currency sign is a regional association. Language does not convert amounts or change the currency of your records.';

  @override
  String get appName => 'Not Spent';

  @override
  String get appTagline => 'Small choices. Bigger savings.';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get createAccount => 'Create account';

  @override
  String get registerSubtitle => 'Fill in the details to get started';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get createPasswordHint => 'Create a password';

  @override
  String get firstName => 'First name';

  @override
  String get firstNameHint => 'Enter your first name';

  @override
  String get lastName => 'Last name';

  @override
  String get lastNameHint => 'Enter your last name';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get signUp => 'Sign up';

  @override
  String get signIn => 'Sign in';

  @override
  String get or => 'or';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully';

  @override
  String get home => 'Savings';

  @override
  String get homeWelcome => 'Design System';

  @override
  String get homeDescription =>
      'Explore colors, typography, and components. Switch theme and language live.';

  @override
  String get homeFeatureCategories =>
      'Manage categories with CRUD and pagination';

  @override
  String get homeFeatureProfile => 'View profile, theme and locale settings';

  @override
  String get homeUiKitTitle => 'UI Kit';

  @override
  String get homeUiKitSubtitle => 'Design System';

  @override
  String get homeUiKitDescription =>
      'Lightweight solid surfaces, tokens, and components for smooth performance.';

  @override
  String get homeSectionAppearance => 'Appearance';

  @override
  String get homeSectionColors => 'Colors';

  @override
  String get homeSectionTypography => 'Typography';

  @override
  String get homeSectionComponents => 'Components';

  @override
  String get homeSectionTokens => 'Design Tokens';

  @override
  String get colorPrimary => 'Primary';

  @override
  String get colorPrimaryLight => 'Primary Light';

  @override
  String get colorPrimaryDark => 'Primary Dark';

  @override
  String get colorSecondary => 'Secondary';

  @override
  String get colorSuccess => 'Success';

  @override
  String get colorWarning => 'Warning';

  @override
  String get colorError => 'Error';

  @override
  String get colorSurface => 'Surface';

  @override
  String get colorBackground => 'Background';

  @override
  String get homeShowDialog => 'Show dialog';

  @override
  String get homeDialogDemoTitle => 'Dialog demo';

  @override
  String get homeDialogDemoContent =>
      'This is a confirmation dialog from the UI kit.';

  @override
  String get homeFontFamily => 'Font family';

  @override
  String get homeFontRegular => 'Regular';

  @override
  String get homeFontMedium => 'Medium';

  @override
  String get homeFontBold => 'Bold';

  @override
  String get homeSpacing => 'Spacing';

  @override
  String get homeRadius => 'Border radius';

  @override
  String get homeGlassTokens => 'Surfaces';

  @override
  String get homeDemoInputLabel => 'Sample input';

  @override
  String get homeDemoInputHint => 'Type something…';

  @override
  String get homeToggleLoading => 'Toggle loading';

  @override
  String get homeGlassOnLight => 'Default';

  @override
  String get homeGlassPanel => 'Panel';

  @override
  String get homeGlassOnGradient => 'Accent';

  @override
  String get homeTypographySample => 'The quick brown fox';

  @override
  String get categories => 'Categories';

  @override
  String get profile => 'Profile';

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get addCategory => 'Add category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get deleteCategory => 'Delete category';

  @override
  String get categoryName => 'Category name';

  @override
  String get categoryNameRequired => 'Category name is required';

  @override
  String get categoryNameTooShort => 'Category name is too short';

  @override
  String get updateCategory => 'Update category';

  @override
  String get deleteCategoryConfirmation =>
      'Are you sure you want to delete this category?';

  @override
  String get categoryDeletedSuccessfully => 'Category deleted successfully';

  @override
  String get categoryUpdatedSuccessfully => 'Category updated successfully';

  @override
  String get noCategoriesYet => 'No categories yet';

  @override
  String get noCategoriesFound => 'No categories found';

  @override
  String get addFirstCategory => 'Add your first category';

  @override
  String get tryDifferentSearch => 'Try a different search';

  @override
  String get searchCategories => 'Search categories';

  @override
  String get addNewCategoryTooltip => 'Add category';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get updatePersonalInfo => 'Update your personal information';

  @override
  String get personalInformation => 'Personal information';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get changePassword => 'Change password';

  @override
  String get changePasswordTitle => 'Change password';

  @override
  String get changePasswordButton => 'Update password';

  @override
  String get security => 'Security';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get error => 'Error';

  @override
  String get loading => 'Loading';

  @override
  String get retry => 'Retry';

  @override
  String get version => 'Version';

  @override
  String get currentPassword => 'Current password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get enterCurrentPassword => 'Enter current password';

  @override
  String get enterNewPassword => 'Enter new password';

  @override
  String get confirmYourNewPassword => 'Confirm your new password';

  @override
  String get currentPasswordRequired => 'Current password is required';

  @override
  String get newPasswordRequired => 'New password is required';

  @override
  String get passwordChangedSuccessfully => 'Password changed successfully';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get accountDeletedSuccessfully => 'Account deleted successfully';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountConfirmation =>
      'Are you sure you want to delete your account?';

  @override
  String get deleteAccountDescription =>
      'Permanently delete your account and all data';

  @override
  String get deleteAccountWarning =>
      'This action cannot be undone. All your data will be permanently deleted.';

  @override
  String get dangerZone => 'Danger zone';

  @override
  String get manageAccount => 'Manage your account';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String passwordTooShort(int minLength) {
    return 'Password must be at least $minLength characters';
  }

  @override
  String newPasswordTooShort(int minLength) {
    return 'New password must be at least $minLength characters';
  }

  @override
  String fieldRequired(String fieldName) {
    return '$fieldName is required';
  }

  @override
  String fieldTooShort(String fieldName, int minLength) {
    return '$fieldName must be at least $minLength characters';
  }

  @override
  String nameLettersOnly(String fieldName) {
    return '$fieldName must contain only letters';
  }

  @override
  String numberRequired(Object fieldName) {
    return '$fieldName is required';
  }

  @override
  String numberInvalid(Object fieldName) {
    return '$fieldName must be a valid number';
  }

  @override
  String numberMustBePositive(Object fieldName) {
    return '$fieldName must be greater than zero';
  }

  @override
  String get passwordsDontMatch => 'Passwords do not match';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get past => 'Past';

  @override
  String get ok => 'OK';

  @override
  String get offlineBanner => 'No internet connection';

  @override
  String get loadMore => 'Load more';

  @override
  String get appearance => 'Appearance';

  @override
  String get appearanceDescription => 'Light, dark, or system theme';

  @override
  String get language => 'Language';

  @override
  String get languageDescription => 'App display language';

  @override
  String get languageSystem => 'System';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get errorBadRequest => 'Bad request';

  @override
  String get errorUnauthorized => 'Unauthorized';

  @override
  String get errorAccessDenied => 'Access denied';

  @override
  String get errorNotFound => 'Not found';

  @override
  String get errorTimeout => 'Request timeout';

  @override
  String get errorValidation => 'Validation error';

  @override
  String get errorTooManyRequests => 'Too many requests';

  @override
  String get errorServer => 'Server error';

  @override
  String get errorBadGateway => 'Bad gateway';

  @override
  String get errorServiceUnavailable => 'Service unavailable';

  @override
  String get errorGatewayTimeout => 'Gateway timeout';

  @override
  String get errorClient => 'Client error';

  @override
  String get errorRequestCancelled => 'Request cancelled';

  @override
  String get errorInvalidCredentials => 'Invalid credentials';

  @override
  String get errorResourceExists => 'Resource already exists';

  @override
  String get savingsTagline =>
      'Turn every skipped impulse into your future capital';

  @override
  String get recordSaving => 'I didn\'t spend';

  @override
  String get savedToday => 'Saved today';

  @override
  String get savedThisMonth => 'This month';

  @override
  String get savedTotal => 'Total saved';

  @override
  String get investedTotal => 'Actually set aside';

  @override
  String get monthlyPace => 'Monthly pace';

  @override
  String get futureProjection => 'Future savings';

  @override
  String get yearsAtCurrentPace => 'years at your current pace';

  @override
  String get interestIncome => 'Interest income';

  @override
  String get contributions => 'Your contributions';

  @override
  String get savingsDynamics => 'Savings by month';

  @override
  String get recentSavings => 'Recent choices';

  @override
  String get noSavingsYet => 'No savings recorded yet';

  @override
  String get habits => 'Impulses';

  @override
  String get habitsDescription =>
      'Edit prices and shortcuts for purchases you want to skip';

  @override
  String get history => 'History';

  @override
  String get historyDescription =>
      'Every small choice that worked for your future';

  @override
  String get goals => 'Goals';

  @override
  String get addGoal => 'Add goal';

  @override
  String get goalName => 'Goal name';

  @override
  String get targetAmount => 'Target amount';

  @override
  String get noGoalsYet => 'Add a goal to see your progress';

  @override
  String get impulseItem => 'What did you skip?';

  @override
  String get amount => 'Amount';

  @override
  String get actuallySetAside => 'I actually set this money aside';

  @override
  String get actuallySetAsideDescription =>
      'Separates potential savings from real capital';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get record => 'Record';

  @override
  String get editHabit => 'Edit impulse';

  @override
  String get addHabit => 'Add impulse';

  @override
  String get habitName => 'Impulse name';

  @override
  String get defaultPrice => 'Typical price';

  @override
  String get timesPerWeek => 'Times per week';

  @override
  String get frequencyZeroHint => '0 means once a month';

  @override
  String get oncePerMonth => 'once a month';

  @override
  String get chooseIcon => 'Icon';

  @override
  String get deleteHabitConfirmation =>
      'Delete this impulse shortcut? Existing history will stay.';

  @override
  String get deleteSavingConfirmation => 'Delete this savings record?';

  @override
  String get noHabits => 'No impulse shortcuts yet';

  @override
  String get noHistory => 'Your savings history will appear here';

  @override
  String get weekShort => 'week';

  @override
  String get rateAndHorizon => 'Rate and horizon';

  @override
  String get annualRate => 'Annual deposit rate';

  @override
  String get projectionYears => 'Projection years';

  @override
  String get apply => 'Apply';

  @override
  String get noData => 'Not enough data yet';

  @override
  String get quickChoices => 'Quick choice';

  @override
  String get quickChoicesDescription =>
      'Pick the purchase you skipped just now';

  @override
  String get recordThisSaving => 'Didn\'t spend';

  @override
  String get annualPotential => 'Yearly potential';

  @override
  String get weeklyPotential => 'Typical week';

  @override
  String get savingsBreakdown => 'How your capital is built';

  @override
  String get topSavingsSources => 'Your strongest saving sources';

  @override
  String get currentPace => 'Current pace';

  @override
  String get decisionCount => 'Choices for your future';

  @override
  String get allSavings => 'All choices';

  @override
  String get realSavings => 'Actually set aside';

  @override
  String get potentialSavings => 'Not set aside yet';

  @override
  String get compoundEffect => 'Compound interest effect';

  @override
  String get projectionExplanation =>
      'A scenario, not an account balance: every recorded saving is set aside, the last 90 days\' pace continues, and interest compounds monthly. The rate is hypothetical; returns are not guaranteed.';

  @override
  String get impulseAnnualHint => 'At your selected skip frequency';

  @override
  String projectionScenario(int years, String rate) {
    return 'After $years years at $rate% per year with monthly deposits. Assumes you set aside every saved amount; returns are not guaranteed.';
  }

  @override
  String projectionAfterYears(int years) {
    return 'After $years years with interest';
  }

  @override
  String get oneSkippedPurchase => 'One skipped purchase';

  @override
  String get regularlySkippedPurchases => 'Regular skips';

  @override
  String get editImpulse => 'Customize';

  @override
  String get historyOverview => 'Your choices at a glance';

  @override
  String get noFilteredHistory =>
      'No choices in this group among loaded entries';

  @override
  String get loadMoreHistory => 'Show more';

  @override
  String historyLoadedCount(int count, int total) {
    return 'Loaded $count of $total choices';
  }

  @override
  String get projectionTableTitle => 'Year-by-year amounts';

  @override
  String get projectionTableYear => 'Year';

  @override
  String get projectionTableTotal => 'Total';

  @override
  String get habitPaused => 'Paused · excluded from total potential';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get editSaving => 'Edit entry';

  @override
  String get moneyFormatError =>
      'Enter an amount with up to 10 digits and 2 decimal places';

  @override
  String get frequencyRangeError => 'Enter a whole number between 0 and 50';

  @override
  String get habitActive => 'Include this habit';

  @override
  String get habitActiveDescription =>
      'Pausing excludes it from quick choices and total potential; history is kept';

  @override
  String get editGoal => 'Edit goal';

  @override
  String get goalReached => 'The target amount is set aside';

  @override
  String goalRemaining(String amount) {
    return 'Still to set aside: $amount';
  }

  @override
  String get goalProgressExplanation =>
      'Progress counts only money allocated to this goal. The same amount isn\'t counted toward multiple goals.';

  @override
  String get rateFormatError =>
      'Enter a rate from 0 to 100% with up to two decimal places';

  @override
  String get savingRecordedMessage => 'Choice recorded';

  @override
  String get savingUpdatedMessage => 'Entry updated';

  @override
  String get habitSavedMessage => 'Habit saved';

  @override
  String get goalSavedMessage => 'Goal saved';

  @override
  String get settingsSavedMessage => 'Projection updated';

  @override
  String get entryDeletedMessage => 'Entry deleted';

  @override
  String get changesSavedMessage => 'Changes saved';

  @override
  String get savingsSummaryUnavailable =>
      'Overall totals are unavailable — your history is still here';

  @override
  String get savingsDataLoadFailed =>
      'Couldn\'t load your data. Check your connection and try again.';

  @override
  String get refresh => 'Refresh';

  @override
  String get monthlyAmounts => 'Monthly amounts';

  @override
  String get customSaving => 'Another decision';

  @override
  String get customSavingHint =>
      'A one-off entry: no new habit will be created.';

  @override
  String oneDecisionProjection(int years, String amount) {
    return 'One skipped purchase: $amount in $years yr.';
  }

  @override
  String oneDecisionProjectionHint(String rate) {
    return 'If you set this amount aside now at $rate% annually with monthly compounding, without further contributions. This is a hypothetical scenario, not a promised return.';
  }

  @override
  String get impulseIconCoffee => 'Coffee';

  @override
  String get impulseIconRestaurant => 'Cafés and restaurants';

  @override
  String get impulseIconDelivery => 'Food delivery';

  @override
  String get impulseIconSmoking => 'Cigarettes';

  @override
  String get impulseIconTaxi => 'Taxi';

  @override
  String get impulseIconShopping => 'Shopping';

  @override
  String get impulseIconSubscription => 'Subscriptions';

  @override
  String get impulseIconOther => 'Other';

  @override
  String get scenarioComparison => 'What if I bought less often?';

  @override
  String scenarioPrice(String amount, String rate) {
    return 'Price: $amount · hypothetical rate: $rate%';
  }

  @override
  String get scenarioBaseline => 'Now';

  @override
  String get scenarioModerate => 'Moderate option';

  @override
  String get scenarioMinimal => 'Minimal option';

  @override
  String scenarioFrequency(String name, int count) {
    return '$name: $count purchases per week';
  }

  @override
  String get scenarioOwnMoney => 'Contributions';

  @override
  String get scenarioAssumptions =>
      'Difference from the current frequency. 52 weeks per year; all savings are deposited at each month\'s end with monthly compounding. No starting capital, taxes or inflation; returns aren\'t guaranteed. This calculation doesn\'t create history entries.';

  @override
  String get allocateGoal => 'Allocate money';

  @override
  String get allocatedAmount => 'Total allocated to this goal';

  @override
  String unallocatedMoney(String amount) {
    return 'Available for goals: $amount';
  }

  @override
  String allocationCapacity(String amount) {
    return 'You can allocate up to $amount to this goal';
  }

  @override
  String get allocationInvalid =>
      'Enter an amount of 0 or more with up to two decimal places';

  @override
  String get allocationTooLarge =>
      'Not enough available money, or the goal amount is exceeded';

  @override
  String get goalBelowAllocation => 'Release the excess allocation first';

  @override
  String get releaseAllocationsFirst =>
      'These funds are allocated to goals. Reduce the allocations first.';

  @override
  String get releaseGoalMoney => 'Release this goal\'s money';

  @override
  String get allocationHint =>
      'Set the total allocation, not an additional deposit. 0 returns the money to the available balance. No bank transfer is performed.';

  @override
  String get allocationSaved => 'Money allocated';

  @override
  String get savingReceipt => 'Skipped purchase receipt';

  @override
  String get weeklyReceipt => 'My decisions over 7 days';

  @override
  String get receiptPurchaseNotMade => 'Purchase not made';

  @override
  String get receiptPrivateDecision => 'A decision for myself';

  @override
  String get receiptFooter =>
      'A personal record of a skipped purchase. Not a bank statement or fiscal receipt.';

  @override
  String get receiptHideName => 'Hide purchase name';

  @override
  String get receiptExport => 'Save / share PNG';

  @override
  String get receiptExportFailed =>
      'Couldn\'t export the receipt. Please try again.';

  @override
  String get favoriteActions => 'My three quick decisions';

  @override
  String get favoriteActionsHint =>
      'Choose Add to favorites in a habit\'s menu. Up to three actions will appear here and in your phone\'s widget. To add the widget, hold the home screen → Widgets → Not spent.';

  @override
  String get addFavorite => 'Add to favorites / widget';

  @override
  String get removeFavorite => 'Remove from favorites';

  @override
  String get favoriteLimit =>
      'You already have three favorites. Remove one first.';

  @override
  String get widgetItemUnavailable =>
      'This item is deleted, paused, or unavailable to this account';
}
