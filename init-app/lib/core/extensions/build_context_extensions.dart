import 'package:mobile_template/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Extension to make localization easier to access from BuildContext
extension BuildContextExtensions on BuildContext {
  /// Get AppLocalizations instance
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Get current locale
  Locale get locale => Localizations.localeOf(this);

  /// Check if current locale is English
  bool get isEnglish => locale.languageCode == 'en';

  /// Check if current locale is Russian
  bool get isRussian => locale.languageCode == 'ru';

  /// Get current language code
  String get languageCode => locale.languageCode;

  /// Get theme
  ThemeData get theme => Theme.of(this);
}
