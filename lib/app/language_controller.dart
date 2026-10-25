import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum AppLanguage {
  tr(
    code: 'tr',
    displayName: 'Türkçe',
    countryCode: 'TR',
    flag: '🇹🇷',
  ),
  en(
    code: 'en',
    displayName: 'English',
    countryCode: 'EN',
    flag: '🇬🇧',
  ),
  de(
    code: 'de',
    displayName: 'Deutsch',
    countryCode: 'DE',
    flag: '🇩🇪',
  );

  const AppLanguage({
    required this.code,
    required this.displayName,
    required this.countryCode,
    required this.flag,
  });

  final String code;
  final String displayName;
  final String countryCode;
  final String flag;

  String get labelWithFlag => '$flag $displayName ($countryCode)';
  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    if (code == null) return AppLanguage.tr;
    for (final lang in AppLanguage.values) {
      if (lang.code.toLowerCase() == code.toLowerCase()) {
        return lang;
      }
    }
    return AppLanguage.tr;
  }
}

class AppLanguageController extends ChangeNotifier {
  AppLanguageController([Box<String>? settings])
      : _settings = settings,
        _language = AppLanguage.fromCode(settings?.get('app_language'));

  final Box<String>? _settings;
  AppLanguage _language;

  AppLanguage get language => _language;
  Locale get locale => _language.locale;
  String get displayName => '${_language.displayName} (${_language.countryCode})';
  String get labelWithFlag => _language.labelWithFlag;

  Future<void> setLanguage(AppLanguage value) async {
    if (_language == value) return;
    _language = value;
    await _settings?.put('app_language', value.code);
    notifyListeners();
  }
}
