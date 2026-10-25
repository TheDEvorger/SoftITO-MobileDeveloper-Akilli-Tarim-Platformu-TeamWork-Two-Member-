import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/language_controller.dart';
import 'app/role_controller.dart';
import 'app/theme_controller.dart';
import 'core/storage/app_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final storage = await AppStorage.initialize();
    final roleController = RoleController(storage.settings);
    final languageController = AppLanguageController(storage.settings);
    final themeController = AppThemeController(storage.settings);
    runApp(AkilliTarimApp(
      storage: storage,
      roleController: roleController,
      languageController: languageController,
      themeController: themeController,
    ));
  } catch (error) {
    runApp(MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Uygulama verileri başlatılamadı.\n$error'),
            ),
          ),
        ),
      ),
    ));
  }
}
