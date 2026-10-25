import 'dart:convert';

import 'package:akilli_tarim_platformu/app/app_scope.dart';
import 'package:akilli_tarim_platformu/app/app_translations.dart';
import 'package:akilli_tarim_platformu/app/language_controller.dart';
import 'package:akilli_tarim_platformu/app/role_controller.dart';
import 'package:akilli_tarim_platformu/core/models/product.dart';
import 'package:akilli_tarim_platformu/core/storage/app_storage.dart';
import 'package:akilli_tarim_platformu/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_json_box_repository.dart';

void main() {
  group('Multi-Language & Localization Tests (TR, EN, DE)', () {
    late FakeBox<String> settingsBox;
    late AppLanguageController langController;

    setUp(() {
      settingsBox = FakeBox<String>();
      langController = AppLanguageController(settingsBox);
    });

    tearDown(() {
      langController.dispose();
    });

    test('Varsayılan dil Türkçe (TR) olarak başlar', () {
      expect(langController.language, AppLanguage.tr);
      expect(langController.locale.languageCode, 'tr');
      expect(langController.displayName, 'Türkçe (TR)');
    });

    test('İngilizce (EN) ve Almanca (DE) dillerine geçiş ve kalıcılık testi',
        () async {
      await langController.setLanguage(AppLanguage.en);
      expect(langController.language, AppLanguage.en);
      expect(langController.locale.languageCode, 'en');
      expect(settingsBox.get('app_language'), 'en');

      await langController.setLanguage(AppLanguage.de);
      expect(langController.language, AppLanguage.de);
      expect(langController.locale.languageCode, 'de');
      expect(settingsBox.get('app_language'), 'de');

      // Yeni controller başlatıldığında saklanan dili yükler
      final reloadedController = AppLanguageController(settingsBox);
      expect(reloadedController.language, AppLanguage.de);
      reloadedController.dispose();
    });

    test('AppTranslations her 3 dilde de doğru anahtarları döndürür', () {
      const tr = AppTranslations(AppLanguage.tr);
      const en = AppTranslations(AppLanguage.en);
      const de = AppTranslations(AppLanguage.de);

      expect(tr.navHome, 'Ana Sayfa');
      expect(en.navHome, 'Home');
      expect(de.navHome, 'Startseite');

      expect(tr.appLanguageTitle, 'Uygulama Dili');
      expect(en.appLanguageTitle, 'App Language');
      expect(de.appLanguageTitle, 'App-Sprache');

      expect(tr.productsListed(6), '6 ürün listelendi');
      expect(en.productsListed(6), '6 products listed');
      expect(de.productsListed(6), '6 Produkte aufgelistet');
    });
  });

  group('Alıcı Modu Ürün Sayısı Senkronizasyon Testi (6 Çeşit / 6 Ürün)', () {
    late AppStorage fakeStorage;
    late RoleController roleController;
    late AppLanguageController langController;
    late FakeBox<String> settingsBox;
    late FakeBox<String> productBox;

    setUp(() {
      settingsBox = FakeBox<String>();
      settingsBox.put('user_role', 'consumer');
      roleController = RoleController(settingsBox);
      langController = AppLanguageController(settingsBox);
      productBox = FakeBox<String>();

      // 5 tanesi üreticiye ait (demo_producer_001), 6 tanesi diğer üreticilere ait = Toplam 11
      for (int i = 1; i <= 5; i++) {
        final p = Product(
          id: 'prod_producer_$i',
          sellerId: 'demo_producer_001',
          title: 'Üretici Ürün $i',
          category: 'Tahıl',
          quantity: 100,
          unit: 'kg',
          unitPrice: 20,
          city: 'Konya',
          district: 'Çumra',
          imagePath: '',
          sellerPhone: '',
          description: '',
          createdAt: '2026-10-25T12:00:00',
        );
        productBox.put(p.id, jsonEncode(p.toJson()));
      }
      for (int i = 1; i <= 6; i++) {
        final p = Product(
          id: 'prod_other_$i',
          sellerId: 'other_producer_$i',
          title: 'Diğer Mahsul $i',
          category: 'Sebze',
          quantity: 50,
          unit: 'kg',
          unitPrice: 35,
          city: 'Muğla',
          district: 'Marmaris',
          imagePath: '',
          sellerPhone: '',
          description: '',
          createdAt: '2026-10-25T12:00:00',
        );
        productBox.put(p.id, jsonEncode(p.toJson()));
      }

      fakeStorage = AppStorage.fromBoxes(
        animalBox: FakeBox<String>(),
        productBox: productBox,
        offerBox: FakeBox<String>(),
        greenhouseBox: FakeBox<String>(),
        serviceBox: FakeBox<String>(),
        settingsBox: settingsBox,
      );
    });

    tearDown(() {
      roleController.dispose();
      langController.dispose();
    });

    testWidgets(
        'Alıcı modunda Profil ekranında pazar mahsulü 6 Çeşit olarak görüntülenir',
        (tester) async {
      tester.view.physicalSize = const Size(600, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        AppScope(
          storage: fakeStorage,
          roleController: roleController,
          languageController: langController,
          child: const MaterialApp(
            home: Scaffold(
              body: ProfileScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Alıcı modunda 11 yerine pazarda satın alınabilir 6 çeşit görünmeli!
      expect(find.text('6 Çeşit'), findsOneWidget);
      expect(find.text('Pazar Mahsulü'), findsOneWidget);
    });

    testWidgets(
        'Uygulama Dili tıklandığında alt menü açılır ve Almanca / İngilizce seçenekleri görünür',
        (tester) async {
      tester.view.physicalSize = const Size(600, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        AppScope(
          storage: fakeStorage,
          roleController: roleController,
          languageController: langController,
          child: const MaterialApp(
            home: Scaffold(
              body: ProfileScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Uygulama Dili seçeneğine scroll yap ve tıkla
      await tester.scrollUntilVisible(
        find.text('Uygulama Dili'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Uygulama Dili'));
      await tester.pumpAndSettle();

      // Açılan modal bottom sheet içinde 3 dil görünmeli
      expect(find.text('Türkçe'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Deutsch'), findsOneWidget);

      // İngilizceyi seç
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(langController.language, AppLanguage.en);
    });

    testWidgets(
        'Dil İngilizce ve Almanca olarak değiştirildiğinde ekrandaki metinler anında güncellenir',
        (tester) async {
      tester.view.physicalSize = const Size(600, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        AnimatedBuilder(
          animation: langController,
          builder: (context, _) => AppScope(
            storage: fakeStorage,
            roleController: roleController,
            languageController: langController,
            currentLanguage: langController.language,
            child: const MaterialApp(
              home: Scaffold(
                body: ProfileScreen(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Başlangıçta Türkçe
      expect(find.text('Uygulama Dili'), findsOneWidget);
      expect(find.text('Hesap & Güvenlik Ayarları'), findsOneWidget);

      // İngilizceye çevir
      await langController.setLanguage(AppLanguage.en);
      await tester.pumpAndSettle();

      // Sayfa yeniden yüklenmeden anında İngilizceye dönmeli
      expect(find.text('App Language'), findsOneWidget);
      expect(find.text('Account & Security Settings'), findsOneWidget);
      expect(find.text('Marketplace Crops'), findsOneWidget);

      // Almancaya çevir
      await langController.setLanguage(AppLanguage.de);
      await tester.pumpAndSettle();

      // Anında Almancaya dönmeli
      expect(find.text('App-Sprache'), findsOneWidget);
      expect(find.text('Konto- & Sicherheitseinstellungen'), findsOneWidget);
      expect(find.text('Marktprodukte'), findsOneWidget);
    });

    test('Almanca ve İngilizce modunda tüm modüllerin çevirileri eksiksizdir', () {
      const de = AppTranslations(AppLanguage.de);
      const en = AppTranslations(AppLanguage.en);

      // Farm Management
      expect(de.farmName, 'Bereket Bauernhof');
      expect(de.farmCenterSubtitle, 'Herden- & Gewächshaus-Zentrum');
      expect(de.addAnimalBtn, 'Tier hinzufügen');
      expect(de.registeredAnimalsTitle, 'Erfasste Tiere');
      expect(de.pregnantFilter, 'Trächtig');
      expect(de.vaccinatedFilter, 'Geimpft');
      expect(de.greenhouseClimateTitle, 'Gewächshausklima-Überwachung');
      expect(de.addGreenhouseBtn, 'Gewächshaus hinzufügen');
      expect(de.optimalClimate, 'Optimales Klima');
      expect(de.balancedHumidity, 'Ausgeglichene Feuchtigkeit');

      expect(en.farmName, 'Bereket Farm');
      expect(en.farmCenterSubtitle, 'Herd & Greenhouse Operations Center');
      expect(en.addAnimalBtn, 'Add Animal');
      expect(en.registeredAnimalsTitle, 'Registered Animals');
      expect(en.pregnantFilter, 'Pregnant');
      expect(en.vaccinatedFilter, 'Vaccinated');
      expect(en.greenhouseClimateTitle, 'Greenhouse Climate Monitoring');
      expect(en.addGreenhouseBtn, 'Add Greenhouse');
      expect(en.optimalClimate, 'Optimal Climate');
      expect(en.balancedHumidity, 'Balanced Humidity');

      // Marketplace & Filters
      expect(de.translateCategory('Tahıl'), 'Getreide');
      expect(de.translateCategory('Meyve'), 'Obst');
      expect(de.translateCategory('Sebze'), 'Gemüse');
      expect(de.allCitiesLabel, 'Alle Städte');
      expect(de.filterResetBtn, 'Zurücksetzen');
      expect(de.publishListingBtn, 'Anzeige veröffentlichen');

      expect(en.translateCategory('Tahıl'), 'Grains');
      expect(en.translateCategory('Meyve'), 'Fruit');
      expect(en.translateCategory('Sebze'), 'Vegetables');
      expect(en.allCitiesLabel, 'All Cities');
      expect(en.filterResetBtn, 'Reset');
      expect(en.publishListingBtn, 'Publish Listing');

      // Offers & Services
      expect(de.sendOfferTitle, 'Kaufangebot senden');
      expect(de.createOfferTitle, 'Angebot erstellen');
      expect(de.buyerInfoTitle, 'Käuferinformationen');
      expect(de.submitOfferBtn, 'Angebot übermitteln');
      expect(de.serviceCategoryLabel('veterinary'), 'Tierarzt');
      expect(de.serviceCategoryLabel('tractor'), 'Traktor');

      expect(en.sendOfferTitle, 'Send Purchase Offer');
      expect(en.createOfferTitle, 'Create Offer');
      expect(en.buyerInfoTitle, 'Buyer Information');
      expect(en.submitOfferBtn, 'Submit Offer');
      expect(en.serviceCategoryLabel('veterinary'), 'Veterinary');
      expect(en.serviceCategoryLabel('tractor'), 'Tractor');

      // Species & Pregnancy Badges
      expect(de.translateSpecies('İnek (Büyükbaş)'), 'Kuh (Rind)');
      expect(de.pregnancyBadgeLabel('pregnant'), 'Trächtig');
      expect(de.pregnancyBadgeLabel('not_pregnant'), 'Nicht trächtig');

      expect(en.translateSpecies('İnek (Büyükbaş)'), 'Cow (Cattle)');
      expect(en.pregnancyBadgeLabel('pregnant'), 'Pregnant');
      expect(en.pregnancyBadgeLabel('not_pregnant'), 'Not Pregnant');

      // Units translation (DE, EN)
      expect(de.translateUnit('kg'), 'kg');
      expect(de.translateUnit('ton'), 'Tonne');
      expect(de.translateUnit('adet'), 'Stück');
      expect(de.translateUnit('kasa'), 'Kiste');
      expect(de.translateUnit('çuval'), 'Sack');

      expect(en.translateUnit('kg'), 'kg');
      expect(en.translateUnit('ton'), 'Ton');
      expect(en.translateUnit('adet'), 'Piece');
      expect(en.translateUnit('kasa'), 'Crate');
      expect(en.translateUnit('çuval'), 'Sack');

      // Product Detail & Actions (DE, EN)
      expect(de.productDetailUnitPrice, 'Einzelpreis');
      expect(de.productDetailAvailableQty, 'Verfügbare Menge');
      expect(de.productDetailLocationSellerTitle, 'Standort & Verkäuferdetails');
      expect(de.productDetailNoDesc, 'Keine zusätzliche Beschreibung vom Erzeuger angegeben.');

      expect(en.productDetailUnitPrice, 'Unit Price');
      expect(en.productDetailAvailableQty, 'Available Quantity');
      expect(en.productDetailLocationSellerTitle, 'Location & Seller Details');
      expect(en.productDetailNoDesc, 'No additional description provided by the producer.');

      // Quick Module Access & Profile (DE, EN)
      expect(de.quickModuleAccessTitle, 'Schnellzugriff auf Module');
      expect(de.farmHerdPanelTitle, 'Hof- & Herdenverwaltung');
      expect(de.marketplaceShowcaseTitle, 'Marktplatz-Schaufenster');
      expect(de.agriServiceGuideTitle, 'Agrardienst-Verzeichnis');

      expect(en.quickModuleAccessTitle, 'Quick Module Access');
      expect(en.farmHerdPanelTitle, 'Farm & Herd Dashboard');
      expect(en.marketplaceShowcaseTitle, 'Marketplace Showcase');
      expect(en.agriServiceGuideTitle, 'Agricultural Services Directory');

      // Validation errors translation (DE, EN)
      expect(de.translateValidationError('Küpe numarası boş bırakılamaz.'), 'Ohrmarkennummer darf nicht leer sein.');
      expect(en.translateValidationError('Küpe numarası boş bırakılamaz.'), 'Ear tag cannot be empty.');
    });
  });
}
