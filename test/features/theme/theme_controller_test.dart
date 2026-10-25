import 'package:akilli_tarim_platformu/app/app_scope.dart';
import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/language_controller.dart';
import 'package:akilli_tarim_platformu/app/role_controller.dart';
import 'package:akilli_tarim_platformu/app/theme_controller.dart';
import 'package:akilli_tarim_platformu/core/storage/app_storage.dart';
import 'package:akilli_tarim_platformu/features/profile/presentation/widgets/profile_settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_json_box_repository.dart';

void main() {
  group('Theme Engine & Hive Persistence Tests', () {
    late FakeBox<String> settingsBox;
    late AppThemeController themeController;

    setUp(() {
      settingsBox = FakeBox<String>();
      themeController = AppThemeController(settingsBox);
    });

    tearDown(() {
      themeController.dispose();
    });

    test('Varsayılan tema Light (Açık) olarak başlar', () {
      expect(themeController.themeMode, ThemeMode.light);
      expect(themeController.isDark, isFalse);
    });

    test('toggleTheme() açık temadan karanlık temaya ve geri geçirir, Hive kutusuna kaydeder', () async {
      await themeController.toggleTheme();
      expect(themeController.themeMode, ThemeMode.dark);
      expect(themeController.isDark, isTrue);
      expect(settingsBox.get('app_theme_mode'), 'dark');
      expect(settingsBox.get('theme_mode'), 'dark');

      await themeController.toggleTheme();
      expect(themeController.themeMode, ThemeMode.light);
      expect(themeController.isDark, isFalse);
      expect(settingsBox.get('app_theme_mode'), 'light');
      expect(settingsBox.get('theme_mode'), 'light');
    });

    test('Hive ayarlarından önceden kaydedilmiş karanlık tema tercihi geri yüklenir', () {
      settingsBox.put('app_theme_mode', 'dark');

      final reloadedController = AppThemeController(settingsBox);
      expect(reloadedController.themeMode, ThemeMode.dark);
      expect(reloadedController.isDark, isTrue);
      reloadedController.dispose();
    });

    test('setThemeMode doğrudan tema modunu ayarlar', () async {
      await themeController.setThemeMode(ThemeMode.dark);
      expect(themeController.themeMode, ThemeMode.dark);

      await themeController.setThemeMode(ThemeMode.light);
      expect(themeController.themeMode, ThemeMode.light);
    });
  });

  group('Dark Theme Renk ve Kontrast Kriterleri (WCAG AA & Doğa Konsepti)', () {
    test('Karanlık temada saf siyah (#000000) veya standart Material gri kullanılmaz', () {
      final darkTheme = FarmTheme.dark;

      expect(darkTheme.scaffoldBackgroundColor, isNot(const Color(0xFF000000)));
      expect(darkTheme.scaffoldBackgroundColor, isNot(const Color(0xFF121212)));
      expect(darkTheme.scaffoldBackgroundColor, isNot(const Color(0xFF212121)));
      expect(darkTheme.scaffoldBackgroundColor, const Color(0xFF121614)); // Tarım koyu yeşil-gri

      expect(darkTheme.cardColor, isNot(const Color(0xFF000000)));
      expect(darkTheme.cardColor, const Color(0xFF1E2420)); // Antrasit yüzey
      expect(darkTheme.colorScheme.surface, const Color(0xFF1E2420));
    });

    test('Vurgu renkleri pastel/aydınlık uyarlanmış olup WCAG AA kontrast şartını sağlar', () {
      // Background luminance
      final bgLuminance = const Color(0xFF121614).computeLuminance();
      final surfaceLuminance = const Color(0xFF1E2420).computeLuminance();

      // Deep Forest karanlık uyarlaması: #5DB88E
      final forestLuminance = FarmDarkColors.forest.computeLuminance();
      final forestContrastOnBg = (forestLuminance + 0.05) / (bgLuminance + 0.05);
      final forestContrastOnSurface = (forestLuminance + 0.05) / (surfaceLuminance + 0.05);

      expect(forestContrastOnBg, greaterThanOrEqualTo(4.5)); // WCAG AA normal metin: >= 4.5
      expect(forestContrastOnSurface, greaterThanOrEqualTo(4.5));

      // Harvest Gold karanlık uyarlaması: #F3C766
      final goldLuminance = FarmDarkColors.gold.computeLuminance();
      final goldContrastOnBg = (goldLuminance + 0.05) / (bgLuminance + 0.05);
      final goldContrastOnSurface = (goldLuminance + 0.05) / (surfaceLuminance + 0.05);

      expect(goldContrastOnBg, greaterThanOrEqualTo(4.5)); // WCAG AA
      expect(goldContrastOnSurface, greaterThanOrEqualTo(4.5));

      // Metin kontrastı
      final textLuminance = FarmDarkColors.ink.computeLuminance();
      final textContrast = (textLuminance + 0.05) / (bgLuminance + 0.05);
      expect(textContrast, greaterThanOrEqualTo(7.0)); // WCAG AAA
    });
  });

  group('Arayüz Tema Toggle Widget Testleri', () {
    testWidgets('Profil ayarlarındaki Dark Theme toggle anahtarı çalışır', (tester) async {
      final settingsBox = FakeBox<String>();
      final themeCtrl = AppThemeController(settingsBox);
      final langCtrl = AppLanguageController(settingsBox);
      final roleCtrl = RoleController(settingsBox);
      final storage = AppStorage.fromBoxes(
        animalBox: FakeBox<String>(),
        productBox: FakeBox<String>(),
        offerBox: FakeBox<String>(),
        greenhouseBox: FakeBox<String>(),
        serviceBox: FakeBox<String>(),
        settingsBox: settingsBox,
      );

      await tester.pumpWidget(
        AppScope(
          storage: storage,
          roleController: roleCtrl,
          languageController: langCtrl,
          themeController: themeCtrl,
          child: ListenableBuilder(
            listenable: themeCtrl,
            builder: (context, _) => MaterialApp(
              theme: FarmTheme.light,
              darkTheme: FarmTheme.dark,
              themeMode: themeCtrl.themeMode,
              home: const Scaffold(
                body: SingleChildScrollView(
                  child: ProfileSettingsSection(),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Başlangıçta switch kapalı olmalı
      final tileFinder = find.byKey(const Key('theme_dark_switch_tile'));
      expect(tileFinder, findsOneWidget);
      final switchFinder = find.descendant(of: tileFinder, matching: find.byType(Switch));
      expect(switchFinder, findsOneWidget);
      final initialSwitch = tester.widget<Switch>(switchFinder);
      expect(initialSwitch.value, isFalse);

      // Switch'e dokun
      await tester.tap(tileFinder);
      await tester.pumpAndSettle();

      // Switch açık ve tema karanlık olmalı
      expect(themeCtrl.isDark, isTrue);
      final updatedSwitch = tester.widget<Switch>(switchFinder);
      expect(updatedSwitch.value, isTrue);

      themeCtrl.dispose();
      langCtrl.dispose();
      roleCtrl.dispose();
    });
  });
}
