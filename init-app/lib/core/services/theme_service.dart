import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  ThemeService(this._prefs);

  final SharedPreferences _prefs;
  final _paletteDrafts = <Brightness, String>{};
  String? paletteDraft(Brightness brightness) => _paletteDrafts[brightness];
  void setPaletteDraft(Brightness brightness, String? text) {
    if (text == null) {
      _paletteDrafts.remove(brightness);
    } else {
      _paletteDrafts[brightness] = text;
    }
  }

  static const _key = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  Color? get lightSeed => _readColor('light_seed');
  Color? get darkSeed => _readColor('dark_seed');

  Color? _readColor(String key) {
    final value = _prefs.getInt(key);
    return value == null ? null : Color(value);
  }

  Future<void> setSeed(Brightness brightness, Color? color) async {
    final key = brightness == Brightness.light ? 'light_seed' : 'dark_seed';
    if (color == null) {
      await _prefs.remove(key);
    } else {
      await _prefs.setInt(key, color.toARGB32());
    }
    notifyListeners();
  }

  void init() {
    final stored = _prefs.getString(_key);
    _themeMode = switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString(_key, mode.name);
    notifyListeners();
  }
}
