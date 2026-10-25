import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Kullanıcının açık / karanlık tema tercihini yöneten ve Hive 'settings' kutusunda saklayan kontrolcü.
class AppThemeController extends ChangeNotifier {
  AppThemeController([Box<String>? settings])
      : _settings = settings,
        _themeMode = _parseThemeMode(
          settings?.get('app_theme_mode') ?? settings?.get('theme_mode'),
        );

  final Box<String>? _settings;
  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  static ThemeMode _parseThemeMode(String? value) {
    if (value == null) return ThemeMode.light;
    switch (value.toLowerCase()) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  /// Temayı anında açık <-> karanlık arasında değiştirir.
  Future<void> toggleTheme() async {
    final nextMode = isDark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(nextMode);
  }

  /// İstenilen tema modunu ayarlar ve Hive 'settings' kutusuna kalıcı olarak yazar.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    final value = mode == ThemeMode.dark ? 'dark' : 'light';
    await _settings?.put('app_theme_mode', value);
    await _settings?.put('theme_mode', value);
    notifyListeners();
  }
}
