import 'package:flutter/widgets.dart';

import '../core/storage/app_storage.dart';
import 'language_controller.dart';
import 'role_controller.dart';

/// Feature ekranları ortak servisleri buradan alır; ikinci Hive altyapısı kurmayın.
class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required super.child,
    required this.storage,
    required this.roleController,
    this.languageController,
    this.currentLanguage,
  });

  final AppStorage storage;
  final RoleController roleController;
  final AppLanguageController? languageController;
  final AppLanguage? currentLanguage;

  AppLanguage get effectiveLanguage =>
      currentLanguage ?? languageController?.language ?? AppLanguage.tr;

  static AppScope of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(result != null, 'AppScope, widget ağacında bulunamadı');
    return result!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      storage != oldWidget.storage ||
      roleController != oldWidget.roleController ||
      languageController != oldWidget.languageController ||
      effectiveLanguage != oldWidget.effectiveLanguage;
}
