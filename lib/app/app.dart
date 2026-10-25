import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/storage/app_storage.dart';
import 'app_router.dart';
import 'app_scope.dart';
import 'app_theme.dart';
import 'language_controller.dart';
import 'role_controller.dart';
import 'theme_controller.dart';

class AkilliTarimApp extends StatefulWidget {
  const AkilliTarimApp({
    super.key,
    required this.storage,
    required this.roleController,
    this.languageController,
    this.themeController,
  });

  final AppStorage storage;
  final RoleController roleController;
  final AppLanguageController? languageController;
  final AppThemeController? themeController;

  @override
  State<AkilliTarimApp> createState() => _AkilliTarimAppState();
}

class _AkilliTarimAppState extends State<AkilliTarimApp> {
  late final AppLanguageController _languageController;
  late final AppThemeController _themeController;
  bool _createdOwnLangController = false;
  bool _createdOwnThemeController = false;

  @override
  void initState() {
    super.initState();
    if (widget.languageController != null) {
      _languageController = widget.languageController!;
    } else {
      _languageController = AppLanguageController(widget.storage.settings);
      _createdOwnLangController = true;
    }

    if (widget.themeController != null) {
      _themeController = widget.themeController!;
    } else {
      _themeController = AppThemeController(widget.storage.settings);
      _createdOwnThemeController = true;
    }
  }

  @override
  void dispose() {
    if (_createdOwnLangController) {
      _languageController.dispose();
    }
    if (_createdOwnThemeController) {
      _themeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _languageController,
        _themeController,
        widget.roleController,
      ]),
      builder: (context, _) => AppScope(
        storage: widget.storage,
        roleController: widget.roleController,
        languageController: _languageController,
        themeController: _themeController,
        currentLanguage: _languageController.language,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bereket Ovası | Akıllı Tarım',
          theme: FarmTheme.light,
          darkTheme: FarmTheme.dark,
          themeMode: _themeController.themeMode,
          locale: _languageController.locale,
          supportedLocales: AppLanguage.values.map((l) => l.locale),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ),
      ),
    );
  }
}
