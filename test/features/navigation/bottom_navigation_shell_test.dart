import 'package:akilli_tarim_platformu/app/app_scope.dart';
import 'package:akilli_tarim_platformu/app/role_controller.dart';
import 'package:akilli_tarim_platformu/app/screens/home_screen.dart';
import 'package:akilli_tarim_platformu/core/storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_json_box_repository.dart';

void main() {
  group('Persistent Bottom Navigation Widget Tests', () {
    late AppStorage fakeStorage;
    late RoleController roleController;
    late FakeBox<String> settingsBox;

    setUp(() {
      settingsBox = FakeBox<String>();
      settingsBox.put('user_role', 'producer');
      roleController = RoleController(settingsBox);

      fakeStorage = AppStorage.fromBoxes(
        animalBox: FakeBox<String>(),
        productBox: FakeBox<String>(),
        offerBox: FakeBox<String>(),
        greenhouseBox: FakeBox<String>(),
        serviceBox: FakeBox<String>(),
        settingsBox: settingsBox,
      );
    });

    tearDown(() {
      roleController.dispose();
    });

    Widget createTestableWidget({int initialIndex = 0}) {
      return AppScope(
        storage: fakeStorage,
        roleController: roleController,
        child: MaterialApp(
          home: HomeScreen(initialIndex: initialIndex),
        ),
      );
    }

    testWidgets('Kalıcı NavigationBar ekranda mevcuttur ve 5 sekme içerir',
        (tester) async {
      await tester.pumpWidget(createTestableWidget());

      // NavigationBar mevcut olmalı
      expect(find.byType(NavigationBar), findsOneWidget);

      // 5 sekme etiketi bulunmalı (Üretici modunda)
      expect(find.text('Ana Sayfa'), findsOneWidget);
      expect(find.text('İlanlarım'), findsOneWidget);
      expect(find.text('Çiftlik'), findsOneWidget);
      expect(find.text('Teklifler'), findsOneWidget);
      expect(find.text('Profil'), findsOneWidget);
    });

    testWidgets('Profil sekmesine dokunulduğunda Profil ekranına geçilir',
        (tester) async {
      await tester.pumpWidget(createTestableWidget());

      // Profil sekmesine tıkla
      await tester.tap(find.text('Profil'));
      await tester.pumpAndSettle();

      // NavigationBar hala orada olmalı (asla kaybolmamalı!)
      expect(find.byType(NavigationBar), findsOneWidget);

      // Profil başlığı veya içeriği görüntülenmeli
      expect(find.text('Hüsnü Çoban'), findsOneWidget);
    });

    testWidgets(
        'initialIndex: 4 ile başlatıldığında doğrudan Profil ekranı ve NavigationBar açılır',
        (tester) async {
      tester.view.physicalSize = const Size(600, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestableWidget(initialIndex: 4));
      await tester.pumpAndSettle();

      // Alt navigasyon çubuğu aktif olmalı
      expect(find.byType(NavigationBar), findsOneWidget);

      // Profil ekranı görünür olmalı
      expect(find.text('Hüsnü Çoban'), findsOneWidget);
      expect(find.text('Hesap & Güvenlik Ayarları'), findsOneWidget);
    });

    testWidgets(
        'Ekran boyutları daraltıldığında ve genişletildiğinde akıcı şekilde çalışır',
        (tester) async {
      // Dar ekran (Mobil genişliği: 380x800)
      tester.view.physicalSize = const Size(380, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);

      // Geniş ekran (Tablet/Masaüstü: 1200x800)
      tester.view.physicalSize = const Size(1200, 800);
      await tester.pumpAndSettle();
      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });
}
