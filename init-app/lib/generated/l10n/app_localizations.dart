import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Not Spent'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Small choices. Bigger savings.'**
  String get appTagline;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get loginSubtitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details to get started'**
  String get registerSubtitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @createPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPasswordHint;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get firstNameHint;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get lastNameHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreatedSuccessfully;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get home;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Design System'**
  String get homeWelcome;

  /// No description provided for @homeDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore colors, typography, and components. Switch theme and language live.'**
  String get homeDescription;

  /// No description provided for @homeFeatureCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage categories with CRUD and pagination'**
  String get homeFeatureCategories;

  /// No description provided for @homeFeatureProfile.
  ///
  /// In en, this message translates to:
  /// **'View profile, theme and locale settings'**
  String get homeFeatureProfile;

  /// No description provided for @homeUiKitTitle.
  ///
  /// In en, this message translates to:
  /// **'UI Kit'**
  String get homeUiKitTitle;

  /// No description provided for @homeUiKitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Design System'**
  String get homeUiKitSubtitle;

  /// No description provided for @homeUiKitDescription.
  ///
  /// In en, this message translates to:
  /// **'Lightweight solid surfaces, tokens, and components for smooth performance.'**
  String get homeUiKitDescription;

  /// No description provided for @homeSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get homeSectionAppearance;

  /// No description provided for @homeSectionColors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get homeSectionColors;

  /// No description provided for @homeSectionTypography.
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get homeSectionTypography;

  /// No description provided for @homeSectionComponents.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get homeSectionComponents;

  /// No description provided for @homeSectionTokens.
  ///
  /// In en, this message translates to:
  /// **'Design Tokens'**
  String get homeSectionTokens;

  /// No description provided for @colorPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get colorPrimary;

  /// No description provided for @colorPrimaryLight.
  ///
  /// In en, this message translates to:
  /// **'Primary Light'**
  String get colorPrimaryLight;

  /// No description provided for @colorPrimaryDark.
  ///
  /// In en, this message translates to:
  /// **'Primary Dark'**
  String get colorPrimaryDark;

  /// No description provided for @colorSecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get colorSecondary;

  /// No description provided for @colorSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get colorSuccess;

  /// No description provided for @colorWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get colorWarning;

  /// No description provided for @colorError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get colorError;

  /// No description provided for @colorSurface.
  ///
  /// In en, this message translates to:
  /// **'Surface'**
  String get colorSurface;

  /// No description provided for @colorBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get colorBackground;

  /// No description provided for @homeShowDialog.
  ///
  /// In en, this message translates to:
  /// **'Show dialog'**
  String get homeShowDialog;

  /// No description provided for @homeDialogDemoTitle.
  ///
  /// In en, this message translates to:
  /// **'Dialog demo'**
  String get homeDialogDemoTitle;

  /// No description provided for @homeDialogDemoContent.
  ///
  /// In en, this message translates to:
  /// **'This is a confirmation dialog from the UI kit.'**
  String get homeDialogDemoContent;

  /// No description provided for @homeFontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font family'**
  String get homeFontFamily;

  /// No description provided for @homeFontRegular.
  ///
  /// In en, this message translates to:
  /// **'Regular'**
  String get homeFontRegular;

  /// No description provided for @homeFontMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get homeFontMedium;

  /// No description provided for @homeFontBold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get homeFontBold;

  /// No description provided for @homeSpacing.
  ///
  /// In en, this message translates to:
  /// **'Spacing'**
  String get homeSpacing;

  /// No description provided for @homeRadius.
  ///
  /// In en, this message translates to:
  /// **'Border radius'**
  String get homeRadius;

  /// No description provided for @homeGlassTokens.
  ///
  /// In en, this message translates to:
  /// **'Surfaces'**
  String get homeGlassTokens;

  /// No description provided for @homeDemoInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Sample input'**
  String get homeDemoInputLabel;

  /// No description provided for @homeDemoInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type something…'**
  String get homeDemoInputHint;

  /// No description provided for @homeToggleLoading.
  ///
  /// In en, this message translates to:
  /// **'Toggle loading'**
  String get homeToggleLoading;

  /// No description provided for @homeGlassOnLight.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get homeGlassOnLight;

  /// No description provided for @homeGlassPanel.
  ///
  /// In en, this message translates to:
  /// **'Panel'**
  String get homeGlassPanel;

  /// No description provided for @homeGlassOnGradient.
  ///
  /// In en, this message translates to:
  /// **'Accent'**
  String get homeGlassOnGradient;

  /// No description provided for @homeTypographySample.
  ///
  /// In en, this message translates to:
  /// **'The quick brown fox'**
  String get homeTypographySample;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileSectionAccount;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get deleteCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @categoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get categoryNameRequired;

  /// No description provided for @categoryNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Category name is too short'**
  String get categoryNameTooShort;

  /// No description provided for @updateCategory.
  ///
  /// In en, this message translates to:
  /// **'Update category'**
  String get updateCategory;

  /// No description provided for @deleteCategoryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this category?'**
  String get deleteCategoryConfirmation;

  /// No description provided for @categoryDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category deleted successfully'**
  String get categoryDeletedSuccessfully;

  /// No description provided for @categoryUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category updated successfully'**
  String get categoryUpdatedSuccessfully;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategoriesYet;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @addFirstCategory.
  ///
  /// In en, this message translates to:
  /// **'Add your first category'**
  String get addFirstCategory;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search'**
  String get tryDifferentSearch;

  /// No description provided for @searchCategories.
  ///
  /// In en, this message translates to:
  /// **'Search categories'**
  String get searchCategories;

  /// No description provided for @addNewCategoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addNewCategoryTooltip;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @updatePersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get updatePersonalInfo;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get personalInformation;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get changePasswordButton;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter current password'**
  String get enterCurrentPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPassword;

  /// No description provided for @confirmYourNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get confirmYourNewPassword;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get currentPasswordRequired;

  /// No description provided for @newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get newPasswordRequired;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountConfirmation;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get deleteAccountDescription;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted.'**
  String get deleteAccountWarning;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get dangerZone;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage your account'**
  String get manageAccount;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {minLength} characters'**
  String passwordTooShort(int minLength);

  /// No description provided for @newPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'New password must be at least {minLength} characters'**
  String newPasswordTooShort(int minLength);

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String fieldRequired(String fieldName);

  /// No description provided for @fieldTooShort.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} must be at least {minLength} characters'**
  String fieldTooShort(String fieldName, int minLength);

  /// No description provided for @nameLettersOnly.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} must contain only letters'**
  String nameLettersOnly(String fieldName);

  /// No description provided for @numberRequired.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is required'**
  String numberRequired(Object fieldName);

  /// No description provided for @numberInvalid.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} must be a valid number'**
  String numberInvalid(Object fieldName);

  /// No description provided for @numberMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} must be greater than zero'**
  String numberMustBePositive(Object fieldName);

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDontMatch;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get offlineBanner;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appearanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Light, dark, or system theme'**
  String get appearanceDescription;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'App display language'**
  String get languageDescription;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @errorBadRequest.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get errorBadRequest;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get errorUnauthorized;

  /// No description provided for @errorAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get errorAccessDenied;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get errorNotFound;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get errorTimeout;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Validation error'**
  String get errorValidation;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests'**
  String get errorTooManyRequests;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get errorServer;

  /// No description provided for @errorBadGateway.
  ///
  /// In en, this message translates to:
  /// **'Bad gateway'**
  String get errorBadGateway;

  /// No description provided for @errorServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get errorServiceUnavailable;

  /// No description provided for @errorGatewayTimeout.
  ///
  /// In en, this message translates to:
  /// **'Gateway timeout'**
  String get errorGatewayTimeout;

  /// No description provided for @errorClient.
  ///
  /// In en, this message translates to:
  /// **'Client error'**
  String get errorClient;

  /// No description provided for @errorRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get errorRequestCancelled;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get errorInvalidCredentials;

  /// No description provided for @errorResourceExists.
  ///
  /// In en, this message translates to:
  /// **'Resource already exists'**
  String get errorResourceExists;

  /// No description provided for @savingsTagline.
  ///
  /// In en, this message translates to:
  /// **'Turn every skipped impulse into your future capital'**
  String get savingsTagline;

  /// No description provided for @recordSaving.
  ///
  /// In en, this message translates to:
  /// **'I didn\'t spend'**
  String get recordSaving;

  /// No description provided for @savedToday.
  ///
  /// In en, this message translates to:
  /// **'Saved today'**
  String get savedToday;

  /// No description provided for @savedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get savedThisMonth;

  /// No description provided for @savedTotal.
  ///
  /// In en, this message translates to:
  /// **'Total saved'**
  String get savedTotal;

  /// No description provided for @investedTotal.
  ///
  /// In en, this message translates to:
  /// **'Actually set aside'**
  String get investedTotal;

  /// No description provided for @monthlyPace.
  ///
  /// In en, this message translates to:
  /// **'Monthly pace'**
  String get monthlyPace;

  /// No description provided for @futureProjection.
  ///
  /// In en, this message translates to:
  /// **'Future savings'**
  String get futureProjection;

  /// No description provided for @yearsAtCurrentPace.
  ///
  /// In en, this message translates to:
  /// **'years at your current pace'**
  String get yearsAtCurrentPace;

  /// No description provided for @interestIncome.
  ///
  /// In en, this message translates to:
  /// **'Interest income'**
  String get interestIncome;

  /// No description provided for @contributions.
  ///
  /// In en, this message translates to:
  /// **'Your contributions'**
  String get contributions;

  /// No description provided for @savingsDynamics.
  ///
  /// In en, this message translates to:
  /// **'Savings by month'**
  String get savingsDynamics;

  /// No description provided for @recentSavings.
  ///
  /// In en, this message translates to:
  /// **'Recent choices'**
  String get recentSavings;

  /// No description provided for @noSavingsYet.
  ///
  /// In en, this message translates to:
  /// **'No savings recorded yet'**
  String get noSavingsYet;

  /// No description provided for @habits.
  ///
  /// In en, this message translates to:
  /// **'Impulses'**
  String get habits;

  /// No description provided for @habitsDescription.
  ///
  /// In en, this message translates to:
  /// **'Edit prices and shortcuts for purchases you want to skip'**
  String get habitsDescription;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @historyDescription.
  ///
  /// In en, this message translates to:
  /// **'Every small choice that worked for your future'**
  String get historyDescription;

  /// No description provided for @goals.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goals;

  /// No description provided for @addGoal.
  ///
  /// In en, this message translates to:
  /// **'Add goal'**
  String get addGoal;

  /// No description provided for @goalName.
  ///
  /// In en, this message translates to:
  /// **'Goal name'**
  String get goalName;

  /// No description provided for @targetAmount.
  ///
  /// In en, this message translates to:
  /// **'Target amount'**
  String get targetAmount;

  /// No description provided for @noGoalsYet.
  ///
  /// In en, this message translates to:
  /// **'Add a goal to see your progress'**
  String get noGoalsYet;

  /// No description provided for @impulseItem.
  ///
  /// In en, this message translates to:
  /// **'What did you skip?'**
  String get impulseItem;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @actuallySetAside.
  ///
  /// In en, this message translates to:
  /// **'I actually set this money aside'**
  String get actuallySetAside;

  /// No description provided for @actuallySetAsideDescription.
  ///
  /// In en, this message translates to:
  /// **'Separates potential savings from real capital'**
  String get actuallySetAsideDescription;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @editHabit.
  ///
  /// In en, this message translates to:
  /// **'Edit impulse'**
  String get editHabit;

  /// No description provided for @addHabit.
  ///
  /// In en, this message translates to:
  /// **'Add impulse'**
  String get addHabit;

  /// No description provided for @habitName.
  ///
  /// In en, this message translates to:
  /// **'Impulse name'**
  String get habitName;

  /// No description provided for @defaultPrice.
  ///
  /// In en, this message translates to:
  /// **'Typical price'**
  String get defaultPrice;

  /// No description provided for @timesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Times per week'**
  String get timesPerWeek;

  /// No description provided for @frequencyZeroHint.
  ///
  /// In en, this message translates to:
  /// **'0 means once a month'**
  String get frequencyZeroHint;

  /// No description provided for @oncePerMonth.
  ///
  /// In en, this message translates to:
  /// **'once a month'**
  String get oncePerMonth;

  /// No description provided for @chooseIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get chooseIcon;

  /// No description provided for @deleteHabitConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete this impulse shortcut? Existing history will stay.'**
  String get deleteHabitConfirmation;

  /// No description provided for @deleteSavingConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Delete this savings record?'**
  String get deleteSavingConfirmation;

  /// No description provided for @noHabits.
  ///
  /// In en, this message translates to:
  /// **'No impulse shortcuts yet'**
  String get noHabits;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'Your savings history will appear here'**
  String get noHistory;

  /// No description provided for @weekShort.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get weekShort;

  /// No description provided for @rateAndHorizon.
  ///
  /// In en, this message translates to:
  /// **'Rate and horizon'**
  String get rateAndHorizon;

  /// No description provided for @annualRate.
  ///
  /// In en, this message translates to:
  /// **'Annual deposit rate'**
  String get annualRate;

  /// No description provided for @projectionYears.
  ///
  /// In en, this message translates to:
  /// **'Projection years'**
  String get projectionYears;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data yet'**
  String get noData;

  /// No description provided for @quickChoices.
  ///
  /// In en, this message translates to:
  /// **'Quick choice'**
  String get quickChoices;

  /// No description provided for @quickChoicesDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick the purchase you skipped just now'**
  String get quickChoicesDescription;

  /// No description provided for @recordThisSaving.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t spend'**
  String get recordThisSaving;

  /// No description provided for @annualPotential.
  ///
  /// In en, this message translates to:
  /// **'Yearly potential'**
  String get annualPotential;

  /// No description provided for @weeklyPotential.
  ///
  /// In en, this message translates to:
  /// **'Typical week'**
  String get weeklyPotential;

  /// No description provided for @savingsBreakdown.
  ///
  /// In en, this message translates to:
  /// **'How your capital is built'**
  String get savingsBreakdown;

  /// No description provided for @topSavingsSources.
  ///
  /// In en, this message translates to:
  /// **'Your strongest saving sources'**
  String get topSavingsSources;

  /// No description provided for @currentPace.
  ///
  /// In en, this message translates to:
  /// **'Current pace'**
  String get currentPace;

  /// No description provided for @decisionCount.
  ///
  /// In en, this message translates to:
  /// **'Choices for your future'**
  String get decisionCount;

  /// No description provided for @allSavings.
  ///
  /// In en, this message translates to:
  /// **'All choices'**
  String get allSavings;

  /// No description provided for @realSavings.
  ///
  /// In en, this message translates to:
  /// **'Actually set aside'**
  String get realSavings;

  /// No description provided for @potentialSavings.
  ///
  /// In en, this message translates to:
  /// **'Not set aside yet'**
  String get potentialSavings;

  /// No description provided for @compoundEffect.
  ///
  /// In en, this message translates to:
  /// **'Compound interest effect'**
  String get compoundEffect;

  /// No description provided for @projectionExplanation.
  ///
  /// In en, this message translates to:
  /// **'A scenario, not an account balance: every recorded saving is set aside, the last 90 days\' pace continues, and interest compounds monthly. The rate is hypothetical; returns are not guaranteed.'**
  String get projectionExplanation;

  /// No description provided for @impulseAnnualHint.
  ///
  /// In en, this message translates to:
  /// **'At your selected skip frequency'**
  String get impulseAnnualHint;

  /// No description provided for @projectionScenario.
  ///
  /// In en, this message translates to:
  /// **'After {years} years at {rate}% per year with monthly deposits. Assumes you set aside every saved amount; returns are not guaranteed.'**
  String projectionScenario(int years, String rate);

  /// No description provided for @projectionAfterYears.
  ///
  /// In en, this message translates to:
  /// **'After {years} years with interest'**
  String projectionAfterYears(int years);

  /// No description provided for @oneSkippedPurchase.
  ///
  /// In en, this message translates to:
  /// **'One skipped purchase'**
  String get oneSkippedPurchase;

  /// No description provided for @regularlySkippedPurchases.
  ///
  /// In en, this message translates to:
  /// **'Regular skips'**
  String get regularlySkippedPurchases;

  /// No description provided for @editImpulse.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get editImpulse;

  /// No description provided for @historyOverview.
  ///
  /// In en, this message translates to:
  /// **'Your choices at a glance'**
  String get historyOverview;

  /// No description provided for @noFilteredHistory.
  ///
  /// In en, this message translates to:
  /// **'No choices in this group among loaded entries'**
  String get noFilteredHistory;

  /// No description provided for @loadMoreHistory.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get loadMoreHistory;

  /// No description provided for @historyLoadedCount.
  ///
  /// In en, this message translates to:
  /// **'Loaded {count} of {total} choices'**
  String historyLoadedCount(int count, int total);

  /// No description provided for @projectionTableTitle.
  ///
  /// In en, this message translates to:
  /// **'Year-by-year amounts'**
  String get projectionTableTitle;

  /// No description provided for @projectionTableYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get projectionTableYear;

  /// No description provided for @projectionTableTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get projectionTableTotal;

  /// No description provided for @habitPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused · excluded from total potential'**
  String get habitPaused;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @editSaving.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get editSaving;

  /// No description provided for @moneyFormatError.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount with up to 10 digits and 2 decimal places'**
  String get moneyFormatError;

  /// No description provided for @frequencyRangeError.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number between 0 and 50'**
  String get frequencyRangeError;

  /// No description provided for @habitActive.
  ///
  /// In en, this message translates to:
  /// **'Include this habit'**
  String get habitActive;

  /// No description provided for @habitActiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Pausing excludes it from quick choices and total potential; history is kept'**
  String get habitActiveDescription;

  /// No description provided for @editGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit goal'**
  String get editGoal;

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'The target amount is set aside'**
  String get goalReached;

  /// No description provided for @goalRemaining.
  ///
  /// In en, this message translates to:
  /// **'Still to set aside: {amount}'**
  String goalRemaining(String amount);

  /// No description provided for @goalProgressExplanation.
  ///
  /// In en, this message translates to:
  /// **'Progress counts only money allocated to this goal. The same amount isn\'t counted toward multiple goals.'**
  String get goalProgressExplanation;

  /// No description provided for @rateFormatError.
  ///
  /// In en, this message translates to:
  /// **'Enter a rate from 0 to 100% with up to two decimal places'**
  String get rateFormatError;

  /// No description provided for @savingRecordedMessage.
  ///
  /// In en, this message translates to:
  /// **'Choice recorded'**
  String get savingRecordedMessage;

  /// No description provided for @savingUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Entry updated'**
  String get savingUpdatedMessage;

  /// No description provided for @habitSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Habit saved'**
  String get habitSavedMessage;

  /// No description provided for @goalSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Goal saved'**
  String get goalSavedMessage;

  /// No description provided for @settingsSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Projection updated'**
  String get settingsSavedMessage;

  /// No description provided for @entryDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get entryDeletedMessage;

  /// No description provided for @changesSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get changesSavedMessage;

  /// No description provided for @savingsSummaryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Overall totals are unavailable — your history is still here'**
  String get savingsSummaryUnavailable;

  /// No description provided for @savingsDataLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your data. Check your connection and try again.'**
  String get savingsDataLoadFailed;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @monthlyAmounts.
  ///
  /// In en, this message translates to:
  /// **'Monthly amounts'**
  String get monthlyAmounts;

  /// No description provided for @customSaving.
  ///
  /// In en, this message translates to:
  /// **'Another decision'**
  String get customSaving;

  /// No description provided for @customSavingHint.
  ///
  /// In en, this message translates to:
  /// **'A one-off entry: no new habit will be created.'**
  String get customSavingHint;

  /// No description provided for @oneDecisionProjection.
  ///
  /// In en, this message translates to:
  /// **'One skipped purchase: {amount} in {years} yr.'**
  String oneDecisionProjection(int years, String amount);

  /// No description provided for @oneDecisionProjectionHint.
  ///
  /// In en, this message translates to:
  /// **'If you set this amount aside now at {rate}% annually with monthly compounding, without further contributions. This is a hypothetical scenario, not a promised return.'**
  String oneDecisionProjectionHint(String rate);

  /// No description provided for @impulseIconCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get impulseIconCoffee;

  /// No description provided for @impulseIconRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Cafés and restaurants'**
  String get impulseIconRestaurant;

  /// No description provided for @impulseIconDelivery.
  ///
  /// In en, this message translates to:
  /// **'Food delivery'**
  String get impulseIconDelivery;

  /// No description provided for @impulseIconSmoking.
  ///
  /// In en, this message translates to:
  /// **'Cigarettes'**
  String get impulseIconSmoking;

  /// No description provided for @impulseIconTaxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get impulseIconTaxi;

  /// No description provided for @impulseIconShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get impulseIconShopping;

  /// No description provided for @impulseIconSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get impulseIconSubscription;

  /// No description provided for @impulseIconOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get impulseIconOther;

  /// No description provided for @scenarioComparison.
  ///
  /// In en, this message translates to:
  /// **'What if I bought less often?'**
  String get scenarioComparison;

  /// No description provided for @scenarioPrice.
  ///
  /// In en, this message translates to:
  /// **'Price: {amount} · hypothetical rate: {rate}%'**
  String scenarioPrice(String amount, String rate);

  /// No description provided for @scenarioBaseline.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get scenarioBaseline;

  /// No description provided for @scenarioModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate option'**
  String get scenarioModerate;

  /// No description provided for @scenarioMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal option'**
  String get scenarioMinimal;

  /// No description provided for @scenarioFrequency.
  ///
  /// In en, this message translates to:
  /// **'{name}: {count} purchases per week'**
  String scenarioFrequency(String name, int count);

  /// No description provided for @scenarioOwnMoney.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get scenarioOwnMoney;

  /// No description provided for @scenarioAssumptions.
  ///
  /// In en, this message translates to:
  /// **'Difference from the current frequency. 52 weeks per year; all savings are deposited at each month\'s end with monthly compounding. No starting capital, taxes or inflation; returns aren\'t guaranteed. This calculation doesn\'t create history entries.'**
  String get scenarioAssumptions;

  /// No description provided for @allocateGoal.
  ///
  /// In en, this message translates to:
  /// **'Allocate money'**
  String get allocateGoal;

  /// No description provided for @allocatedAmount.
  ///
  /// In en, this message translates to:
  /// **'Total allocated to this goal'**
  String get allocatedAmount;

  /// No description provided for @unallocatedMoney.
  ///
  /// In en, this message translates to:
  /// **'Available for goals: {amount}'**
  String unallocatedMoney(String amount);

  /// No description provided for @allocationCapacity.
  ///
  /// In en, this message translates to:
  /// **'You can allocate up to {amount} to this goal'**
  String allocationCapacity(String amount);

  /// No description provided for @allocationInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount of 0 or more with up to two decimal places'**
  String get allocationInvalid;

  /// No description provided for @allocationTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Not enough available money, or the goal amount is exceeded'**
  String get allocationTooLarge;

  /// No description provided for @goalBelowAllocation.
  ///
  /// In en, this message translates to:
  /// **'Release the excess allocation first'**
  String get goalBelowAllocation;

  /// No description provided for @releaseAllocationsFirst.
  ///
  /// In en, this message translates to:
  /// **'These funds are allocated to goals. Reduce the allocations first.'**
  String get releaseAllocationsFirst;

  /// No description provided for @releaseGoalMoney.
  ///
  /// In en, this message translates to:
  /// **'Release this goal\'s money'**
  String get releaseGoalMoney;

  /// No description provided for @allocationHint.
  ///
  /// In en, this message translates to:
  /// **'Set the total allocation, not an additional deposit. 0 returns the money to the available balance. No bank transfer is performed.'**
  String get allocationHint;

  /// No description provided for @allocationSaved.
  ///
  /// In en, this message translates to:
  /// **'Money allocated'**
  String get allocationSaved;

  /// No description provided for @savingReceipt.
  ///
  /// In en, this message translates to:
  /// **'Skipped purchase receipt'**
  String get savingReceipt;

  /// No description provided for @weeklyReceipt.
  ///
  /// In en, this message translates to:
  /// **'My decisions over 7 days'**
  String get weeklyReceipt;

  /// No description provided for @receiptPurchaseNotMade.
  ///
  /// In en, this message translates to:
  /// **'Purchase not made'**
  String get receiptPurchaseNotMade;

  /// No description provided for @receiptPrivateDecision.
  ///
  /// In en, this message translates to:
  /// **'A decision for myself'**
  String get receiptPrivateDecision;

  /// No description provided for @receiptFooter.
  ///
  /// In en, this message translates to:
  /// **'A personal record of a skipped purchase. Not a bank statement or fiscal receipt.'**
  String get receiptFooter;

  /// No description provided for @receiptHideName.
  ///
  /// In en, this message translates to:
  /// **'Hide purchase name'**
  String get receiptHideName;

  /// No description provided for @receiptExport.
  ///
  /// In en, this message translates to:
  /// **'Save / share PNG'**
  String get receiptExport;

  /// No description provided for @receiptExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t export the receipt. Please try again.'**
  String get receiptExportFailed;

  /// No description provided for @favoriteActions.
  ///
  /// In en, this message translates to:
  /// **'My three quick decisions'**
  String get favoriteActions;

  /// No description provided for @favoriteActionsHint.
  ///
  /// In en, this message translates to:
  /// **'Choose Add to favorites in a habit\'s menu. Up to three actions will appear here and in your phone\'s widget. To add the widget, hold the home screen → Widgets → Not spent.'**
  String get favoriteActionsHint;

  /// No description provided for @addFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites / widget'**
  String get addFavorite;

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFavorite;

  /// No description provided for @favoriteLimit.
  ///
  /// In en, this message translates to:
  /// **'You already have three favorites. Remove one first.'**
  String get favoriteLimit;

  /// No description provided for @widgetItemUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This item is deleted, paused, or unavailable to this account'**
  String get widgetItemUnavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
