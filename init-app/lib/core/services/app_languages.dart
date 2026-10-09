import 'package:flutter/material.dart';

/// Regional logo associations, not account currencies or exchange rates.
class AppLanguage {
  const AppLanguage(this.code, this.name, this.coinCode);
  final String code;
  final String name;
  final String coinCode;
  static const all = [
    AppLanguage('ru', 'Русский', 'RUB'),
    AppLanguage('en', 'English', 'USD'),
    AppLanguage('es', 'Español', 'EUR'),
    AppLanguage('pt', 'Português', 'BRL'),
    AppLanguage('fr', 'Français', 'EUR'),
    AppLanguage('de', 'Deutsch', 'EUR'),
    AppLanguage('zh', '中文', 'CNY'),
    AppLanguage('hi', 'हिन्दी', 'INR'),
    AppLanguage('ar', 'العربية', 'SAR'),
  ];
  static AppLanguage? find(Locale? locale) => all
      .where((language) => language.code == locale?.languageCode)
      .firstOrNull;
}
