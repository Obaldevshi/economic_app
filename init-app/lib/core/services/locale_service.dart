import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_template/core/services/app_languages.dart';

class LocaleService extends ChangeNotifier with WidgetsBindingObserver {
  LocaleService(this._prefs, {this.onChanged});
  final Future<void> Function(String?)? onChanged;

  final SharedPreferences _prefs;
  static const _key = 'locale';

  Locale? _locale;

  Locale? get locale => _locale;

  void init() {
    WidgetsBinding.instance.addObserver(this);
    final stored = _prefs.getString(_key);
    if (stored != null && AppLanguage.find(Locale(stored)) != null) {
      _locale = Locale(stored);
    }
    onChanged?.call(_locale?.languageCode);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (_locale == null) {
      onChanged?.call(null);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> setLocale(Locale? locale) async {
    if (locale != null && AppLanguage.find(locale) == null) return;
    _locale = locale;
    notifyListeners();
    if (locale == null) {
      await _prefs.remove(_key);
    } else {
      await _prefs.setString(_key, locale.languageCode);
    }
    await onChanged?.call(locale?.languageCode);
  }
}
