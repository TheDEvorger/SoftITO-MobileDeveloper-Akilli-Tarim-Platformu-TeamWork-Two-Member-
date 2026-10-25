import 'package:akilli_tarim_platformu/app/app.dart';
import 'package:akilli_tarim_platformu/app/app_router.dart';
import 'package:akilli_tarim_platformu/app/role_controller.dart';
import 'package:akilli_tarim_platformu/app/screens/login_screen.dart';
import 'package:akilli_tarim_platformu/core/storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_json_box_repository.dart';

void main() {
  group('LoginScreen Widget & Logic Tests', () {
    Widget buildTestableLogin() {
      return MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.home) {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Ana Sayfa')),
            );
          }
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        },
        home: const LoginScreen(),
      );
    }

    testWidgets('Kullanıcı adı ve şifre alanları ekranda görüntülenir',
        (tester) async {
      await tester.pumpWidget(buildTestableLogin());

      expect(find.text('Bereket Ovası'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Giriş Yap'), findsOneWidget);
      expect(find.text('Demo Giriş Bilgileri'), findsOneWidget);
    });

    testWidgets('Boş alanlarla giriş yapılmak istendiğinde uyarı verir',
        (tester) async {
      await tester.pumpWidget(buildTestableLogin());

      await tester.tap(find.text('Giriş Yap'));
      await tester.pumpAndSettle();

      expect(find.text('Kullanıcı adı boş bırakılamaz'), findsOneWidget);
      expect(find.text('Şifre boş bırakılamaz'), findsOneWidget);
    });

    testWidgets('Hatalı şifre girildiğinde hata mesajı gösterir',
        (tester) async {
      await tester.pumpWidget(buildTestableLogin());

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Kullanıcı Adı'), 'Admin');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Şifre'), 'yanlisSifre');

      await tester.tap(find.text('Giriş Yap'));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.textContaining('Geçersiz kullanıcı adı veya şifre'),
          findsOneWidget);
    });

    testWidgets('Otomatik doldur butonu Admin ve 123456 değerlerini yazar',
        (tester) async {
      await tester.pumpWidget(buildTestableLogin());

      await tester.ensureVisible(find.text('Otomatik Doldur'));
      await tester.tap(find.text('Otomatik Doldur'));
      await tester.pumpAndSettle();

      final userField =
          tester.widget<TextFormField>(find.byType(TextFormField).first);
      final passField =
          tester.widget<TextFormField>(find.byType(TextFormField).last);

      expect(userField.controller?.text, 'Admin');
      expect(passField.controller?.text, '123456');
    });

    testWidgets('Doğru bilgiler girildiğinde başarıyla ana sayfaya yönlendirir',
        (tester) async {
      await tester.pumpWidget(buildTestableLogin());

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Kullanıcı Adı'), 'Admin');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Şifre'), '123456');

      await tester.tap(find.text('Giriş Yap'));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.text('Ana Sayfa'), findsOneWidget);
    });

    testWidgets(
        'AkilliTarimApp kökünden başlatıldığında MaterialLocalizations eksiksizdir ve TextField hata vermez',
        (tester) async {
      final settingsBox = FakeBox<String>();
      final roleController = RoleController(settingsBox);
      final fakeStorage = AppStorage.fromBoxes(
        animalBox: FakeBox<String>(),
        productBox: FakeBox<String>(),
        offerBox: FakeBox<String>(),
        greenhouseBox: FakeBox<String>(),
        serviceBox: FakeBox<String>(),
        settingsBox: settingsBox,
      );

      await tester.pumpWidget(
        AkilliTarimApp(
          storage: fakeStorage,
          roleController: roleController,
        ),
      );
      // Splash animasyonu ve yönlendirme
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Giriş ekranı MaterialLocalizations hatası olmadan açılmalı
      expect(find.text('Bereket Ovası'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      roleController.dispose();
    });
  });
}
