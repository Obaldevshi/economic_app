import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends ChangeNotifier {
  LocaleService(this._prefs);

  final SharedPreferences _prefs;
  static const _key = 'locale';

  Locale? _locale;

  Locale? get locale => _locale;

  void init() {
    final stored = _prefs.getString(_key);
    if (stored != null) {
      _locale = Locale(stored);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    if (locale == null) {
      await _prefs.remove(_key);
    } else {
      await _prefs.setString(_key, locale.languageCode);
    }
    notifyListeners();
  }
}
