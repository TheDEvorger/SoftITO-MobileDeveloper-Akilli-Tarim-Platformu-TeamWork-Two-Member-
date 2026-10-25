import 'package:akilli_tarim_platformu/app/app.dart';
import 'package:akilli_tarim_platformu/app/language_controller.dart';
import 'package:akilli_tarim_platformu/app/role_controller.dart';
import 'package:akilli_tarim_platformu/app/theme_controller.dart';
import 'package:akilli_tarim_platformu/core/models/user_role.dart';
import 'package:akilli_tarim_platformu/core/storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_json_box_repository.dart';
import 'package:akilli_tarim_platformu/app/app_theme.dart';

void main() {
  test('Inspect button and chip styles and lerp between light and dark', () {
    final styleFromBtn = FilledButton.styleFrom(
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
    ).textStyle?.resolve({});
    expect(styleFromBtn, isNull);

    final lightBtn = FarmTheme.light.filledButtonTheme.style?.textStyle?.resolve({});
    final darkBtn = FarmTheme.dark.filledButtonTheme.style?.textStyle?.resolve({});
    expect(lightBtn, isNull);
    expect(darkBtn, isNull);

    final lightChip = FarmTheme.light.chipTheme.labelStyle;
    final darkChip = FarmTheme.dark.chipTheme.labelStyle;
    expect(lightChip, isNull);
    expect(darkChip, isNull);

    // Test ThemeData lerp at multiple intervals
    for (double t = 0.0; t <= 1.0; t += 0.1) {
      final lerped = ThemeData.lerp(FarmTheme.light, FarmTheme.dark, t);
      expect(lerped, isNotNull);
    }
  });

  testWidgets('Light to dark mode toggle test on HomeScreen and ServiceProvidersScreen',
      (tester) async {
    final settingsBox = FakeBox<String>();
    final roleController = RoleController(settingsBox);
    final themeController = AppThemeController(settingsBox);
    final langController = AppLanguageController(settingsBox);

    final storage = AppStorage.fromBoxes(
      animalBox: FakeBox<String>(),
      productBox: FakeBox<String>(),
      offerBox: FakeBox<String>(),
      greenhouseBox: FakeBox<String>(),
      serviceBox: FakeBox<String>(),
      settingsBox: settingsBox,
    );

    await tester.pumpWidget(
      AkilliTarimApp(
        storage: storage,
        roleController: roleController,
        themeController: themeController,
        languageController: langController,
      ),
    );
    await tester.pumpAndSettle();

    // 1. Navigate to /home
    tester.state<NavigatorState>(find.byType(Navigator)).pushReplacementNamed('/home');
    await tester.pumpAndSettle();

    // Switch theme back and forth in Producer mode
    themeController.toggleTheme(); // Dark
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    themeController.toggleTheme(); // Light
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 2. Set role to consumer so 'Pazarı Keşfet' chip appears
    await roleController.setRole(UserRole.consumer);
    await tester.pumpAndSettle();

    // Switch theme from light to dark with Consumer Home screen visible
    themeController.toggleTheme(); // Dark
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Check if HarvestHero explore market button is there and interactive
    final heroAction = find.text('Pazarı keşfet');
    expect(heroAction, findsOneWidget);
    await tester.tap(heroAction);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Go back to home
    tester.state<NavigatorState>(find.byType(Navigator)).pushReplacementNamed('/home');
    await tester.pumpAndSettle();

    // Find Pazarı Keşfet chip and tap it
    final exploreChip = find.text('Pazarı Keşfet');
    expect(exploreChip, findsOneWidget);
    await tester.tap(exploreChip);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 3. Go to Tarımsal Hizmet Rehberi (/services)
    tester.state<NavigatorState>(find.byType(Navigator)).pushReplacementNamed('/services');
    await tester.pumpAndSettle();

    // Switch theme back to light and then to dark while on /services
    themeController.toggleTheme(); // Light
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    themeController.toggleTheme(); // Dark
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Interact with category chips
    final vetChip = find.text('Veteriner');
    if (vetChip.evaluate().isNotEmpty) {
      await tester.tap(vetChip.first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    // Toggle theme while filtered
    themeController.toggleTheme(); // Light
    await tester.pumpAndSettle();
    themeController.toggleTheme(); // Dark
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
