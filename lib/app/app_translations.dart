import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'language_controller.dart';

class AppTranslations {
  const AppTranslations(this.language);

  final AppLanguage language;

  static AppTranslations of(BuildContext context) {
    try {
      final scope = AppScope.of(context);
      return AppTranslations(scope.effectiveLanguage);
    } catch (_) {
      return const AppTranslations(AppLanguage.tr);
    }
  }

  // Navigation
  String get navHome => switch (language) {
        AppLanguage.tr => 'Ana Sayfa',
        AppLanguage.en => 'Home',
        AppLanguage.de => 'Startseite',
      };

  String get navMyListings => switch (language) {
        AppLanguage.tr => 'İlanlarım',
        AppLanguage.en => 'My Listings',
        AppLanguage.de => 'Meine Anzeigen',
      };

  String get navMarket => switch (language) {
        AppLanguage.tr => 'Pazar',
        AppLanguage.en => 'Marketplace',
        AppLanguage.de => 'Marktplatz',
      };

  String get navFarm => switch (language) {
        AppLanguage.tr => 'Çiftlik',
        AppLanguage.en => 'Farm',
        AppLanguage.de => 'Bauernhof',
      };

  String get navOffers => switch (language) {
        AppLanguage.tr => 'Teklifler',
        AppLanguage.en => 'Offers',
        AppLanguage.de => 'Angebote',
      };

  String get navMyOffers => switch (language) {
        AppLanguage.tr => 'Tekliflerim',
        AppLanguage.en => 'My Offers',
        AppLanguage.de => 'Meine Angebote',
      };

  String get navServices => switch (language) {
        AppLanguage.tr => 'Hizmetler',
        AppLanguage.en => 'Services',
        AppLanguage.de => 'Agrardienste',
      };

  String get navProfile => switch (language) {
        AppLanguage.tr => 'Profil',
        AppLanguage.en => 'Profile',
        AppLanguage.de => 'Profil',
      };

  // Profile Titles & Dialogs
  String get profileProducerTitle => switch (language) {
        AppLanguage.tr => 'Çiftçi Profili & Yönetim',
        AppLanguage.en => 'Farmer Profile & Management',
        AppLanguage.de => 'Landwirtprofil & Verwaltung',
      };

  String get profileConsumerTitle => switch (language) {
        AppLanguage.tr => 'Tüketici Profili & Hesap',
        AppLanguage.en => 'Consumer Profile & Account',
        AppLanguage.de => 'Verbraucherprofil & Konto',
      };

  String get logoutTooltip => switch (language) {
        AppLanguage.tr => 'Çıkış Yap',
        AppLanguage.en => 'Log Out',
        AppLanguage.de => 'Abmelden',
      };

  String get logoutDialogTitle => switch (language) {
        AppLanguage.tr => 'Oturumu Kapat',
        AppLanguage.en => 'Log Out',
        AppLanguage.de => 'Abmelden',
      };

  String get logoutDialogContent => switch (language) {
        AppLanguage.tr =>
          'Bereket Ovası yönetim hesabınızdan çıkış yapmak istediğinize emin misiniz?',
        AppLanguage.en =>
          'Are you sure you want to log out of your Bereket Ovası account?',
        AppLanguage.de =>
          'Möchten Sie sich wirklich von Ihrem Bereket Ovası-Konto abmelden?',
      };

  String get cancel => switch (language) {
        AppLanguage.tr => 'Vazgeç',
        AppLanguage.en => 'Cancel',
        AppLanguage.de => 'Abbrechen',
      };

  String get logoutAction => switch (language) {
        AppLanguage.tr => 'Çıkış Yap',
        AppLanguage.en => 'Log Out',
        AppLanguage.de => 'Abmelden',
      };

  // Role Card
  String get activeRoleMode => switch (language) {
        AppLanguage.tr => 'Aktif Kullanım Modu',
        AppLanguage.en => 'Active Role Mode',
        AppLanguage.de => 'Aktiver Nutzungsmodus',
      };

  String get producerModeTitle => switch (language) {
        AppLanguage.tr => 'Üretici (Çiftçi) Modu',
        AppLanguage.en => 'Producer (Farmer) Mode',
        AppLanguage.de => 'Erzeuger- (Landwirt) Modus',
      };

  String get consumerModeTitle => switch (language) {
        AppLanguage.tr => 'Tüketici (Alıcı) Modu',
        AppLanguage.en => 'Consumer (Buyer) Mode',
        AppLanguage.de => 'Verbraucher- (Käufer) Modus',
      };

  String get producerTab => switch (language) {
        AppLanguage.tr => 'Üretici Modu',
        AppLanguage.en => 'Producer Mode',
        AppLanguage.de => 'Erzeugermodus',
      };

  String get consumerTab => switch (language) {
        AppLanguage.tr => 'Tüketici Modu',
        AppLanguage.en => 'Consumer Mode',
        AppLanguage.de => 'Verbrauchermodus',
      };

  String get producerRoleDesc => switch (language) {
        AppLanguage.tr =>
          'Kendi çiftliğinizi yönetin, mahsul ilanlarınızı yayınlayın ve gelen teklifleri değerlendirin.',
        AppLanguage.en =>
          'Manage your farm, publish crop listings, and evaluate incoming offers.',
        AppLanguage.de =>
          'Verwalten Sie Ihren Hof, veröffentlichen Sie Ernteangebote und prüfen Sie Angebote.',
      };

  String get consumerRoleDesc => switch (language) {
        AppLanguage.tr =>
          'Türkiye genelindeki yerel çiftçilerden doğrudan taze mahsul satın alın ve teklif iletin.',
        AppLanguage.en =>
          'Buy fresh produce directly from local farmers across Turkey and send offers.',
        AppLanguage.de =>
          'Kaufen Sie frische Erzeugnisse direkt von lokalen Erzeugern und senden Sie Angebote.',
      };

  // Stats Labels & Units
  String get statRegisteredHerd => switch (language) {
        AppLanguage.tr => 'Kayıtlı Sürü',
        AppLanguage.en => 'Registered Herd',
        AppLanguage.de => 'Registrierte Herde',
      };

  String get statCropsForSale => switch (language) {
        AppLanguage.tr => 'Satışta Mahsul',
        AppLanguage.en => 'Active Listings',
        AppLanguage.de => 'Aktive Angebote',
      };

  String get statGreenhouseHealth => switch (language) {
        AppLanguage.tr => 'Sera Sağlığı',
        AppLanguage.en => 'Greenhouse Health',
        AppLanguage.de => 'Gewächshauszustand',
      };

  String get statIncomingOffers => switch (language) {
        AppLanguage.tr => 'Gelen Teklif',
        AppLanguage.en => 'Incoming Offers',
        AppLanguage.de => 'Erhaltene Angebote',
      };

  String get statSentOffers => switch (language) {
        AppLanguage.tr => 'Verilen Teklif',
        AppLanguage.en => 'Sent Offers',
        AppLanguage.de => 'Gesendete Angebote',
      };

  String get statApprovedPurchases => switch (language) {
        AppLanguage.tr => 'Onaylanan Alım',
        AppLanguage.en => 'Approved Purchases',
        AppLanguage.de => 'Genehmigte Einkäufe',
      };

  String get statMarketCrops => switch (language) {
        AppLanguage.tr => 'Pazar Mahsulü',
        AppLanguage.en => 'Marketplace Crops',
        AppLanguage.de => 'Marktprodukte',
      };

  String get statAgriServices => switch (language) {
        AppLanguage.tr => 'Tarım Hizmeti',
        AppLanguage.en => 'Agri Services',
        AppLanguage.de => 'Agrardienste',
      };

  String get unitHead => switch (language) {
        AppLanguage.tr => 'Baş',
        AppLanguage.en => 'Head',
        AppLanguage.de => 'Tiere',
      };

  String get unitAd => switch (language) {
        AppLanguage.tr => 'İlan',
        AppLanguage.en => 'Ads',
        AppLanguage.de => 'Anzeigen',
      };

  String get unitUnit => switch (language) {
        AppLanguage.tr => 'Ünite',
        AppLanguage.en => 'Units',
        AppLanguage.de => 'Einheiten',
      };

  String get unitRequest => switch (language) {
        AppLanguage.tr => 'Talep',
        AppLanguage.en => 'Requests',
        AppLanguage.de => 'Anfragen',
      };

  String get unitOffer => switch (language) {
        AppLanguage.tr => 'Teklif',
        AppLanguage.en => 'Offers',
        AppLanguage.de => 'Angebote',
      };

  String get unitPurchase => switch (language) {
        AppLanguage.tr => 'Alım',
        AppLanguage.en => 'Purchases',
        AppLanguage.de => 'Einkäufe',
      };

  String get unitVariety => switch (language) {
        AppLanguage.tr => 'Çeşit',
        AppLanguage.en => 'Items',
        AppLanguage.de => 'Sorten',
      };

  String get unitFirm => switch (language) {
        AppLanguage.tr => 'Firma',
        AppLanguage.en => 'Firms',
        AppLanguage.de => 'Firmen',
      };

  // Badges Card
  String get producerBadgesTitle => switch (language) {
        AppLanguage.tr => 'Kazanılan Çiftçi Rozetleri',
        AppLanguage.en => 'Earned Farmer Badges',
        AppLanguage.de => 'Erhaltene Landwirt-Abzeichen',
      };

  String get consumerBadgesTitle => switch (language) {
        AppLanguage.tr => 'Kazanılan Tüketici Rozetleri',
        AppLanguage.en => 'Earned Consumer Badges',
        AppLanguage.de => 'Erhaltene Verbraucher-Abzeichen',
      };

  // Settings Section
  String get accountSettingsHeader => switch (language) {
        AppLanguage.tr => 'Hesap & Güvenlik Ayarları',
        AppLanguage.en => 'Account & Security Settings',
        AppLanguage.de => 'Konto- & Sicherheitseinstellungen',
      };

  String get notificationsTitle => switch (language) {
        AppLanguage.tr => 'Anlık Mahsul & Teklif Bildirimleri',
        AppLanguage.en => 'Instant Crop & Offer Notifications',
        AppLanguage.de => 'Ernte- & Angebotsbenachrichtigungen',
      };

  String get notificationsSubtitle => switch (language) {
        AppLanguage.tr => 'Teklif geldiğinde veya sera uyarısında haber ver',
        AppLanguage.en => 'Notify when offers arrive or greenhouse alerts',
        AppLanguage.de =>
          'Benachrichtigen bei Angeboten oder Gewächshausalarmen',
      };

  String get twoFactorTitle => switch (language) {
        AppLanguage.tr => 'İki Adımlı Giriş Güvenliği (2FA)',
        AppLanguage.en => 'Two-Factor Authentication (2FA)',
        AppLanguage.de => 'Zwei-Faktor-Authentifizierung (2FA)',
      };

  String get twoFactorSubtitle => switch (language) {
        AppLanguage.tr => 'Admin hesabı için yüksek güvenlik koruması',
        AppLanguage.en => 'High security protection for admin account',
        AppLanguage.de => 'Erhöhter Schutz für das Administratorkonto',
      };

  String get appLanguageTitle => switch (language) {
        AppLanguage.tr => 'Uygulama Dili',
        AppLanguage.en => 'App Language',
        AppLanguage.de => 'App-Sprache',
      };

  String get selectLanguageTitle => switch (language) {
        AppLanguage.tr => 'Uygulama Dili Seçin',
        AppLanguage.en => 'Select App Language',
        AppLanguage.de => 'App-Sprache wählen',
      };

  String get languageSelectSubtitle => switch (language) {
        AppLanguage.tr =>
          'Arayüz metinlerini ve bildirimleri görüntülemek istediğiniz dili seçiniz.',
        AppLanguage.en =>
          'Choose the language for the user interface and system notifications.',
        AppLanguage.de =>
          'Wählen Sie die Sprache für Benutzeroberfläche und Benachrichtigungen.',
      };

  String languageUpdatedMessage(String langName) => switch (language) {
        AppLanguage.tr => 'Uygulama dili $langName olarak güncellendi.',
        AppLanguage.en => 'App language updated to $langName.',
        AppLanguage.de => 'App-Sprache auf $langName aktualisiert.',
      };

  String get notificationsEnabled => switch (language) {
        AppLanguage.tr => 'Bildirimler etkinleştirildi.',
        AppLanguage.en => 'Notifications enabled.',
        AppLanguage.de => 'Benachrichtigungen aktiviert.',
      };

  String get notificationsDisabled => switch (language) {
        AppLanguage.tr => 'Bildirimler sessize alındı.',
        AppLanguage.en => 'Notifications muted.',
        AppLanguage.de => 'Benachrichtigungen stummgeschaltet.',
      };

  String get logoutButtonLabel => switch (language) {
        AppLanguage.tr => 'Oturumu Kapat (Çıkış Yap)',
        AppLanguage.en => 'Log Out',
        AppLanguage.de => 'Abmelden',
      };

  // Marketplace
  String get searchHint => switch (language) {
        AppLanguage.tr => 'Ürün, ilçe veya açıklama ara...',
        AppLanguage.en => 'Search product, district or description...',
        AppLanguage.de => 'Produkt, Bezirk oder Beschreibung suchen...',
      };

  String productsListed(int count) => switch (language) {
        AppLanguage.tr => '$count ürün listelendi',
        AppLanguage.en => '$count products listed',
        AppLanguage.de => '$count Produkte aufgelistet',
      };

  String get allCategories => switch (language) {
        AppLanguage.tr => 'Tümü',
        AppLanguage.en => 'All',
        AppLanguage.de => 'Alle',
      };

  String get allCities => switch (language) {
        AppLanguage.tr => 'Tüm Şehirler',
        AppLanguage.en => 'All Cities',
        AppLanguage.de => 'Alle Städte',
      };

  String get resetFilters => switch (language) {
        AppLanguage.tr => 'Filtreleri Sıfırla',
        AppLanguage.en => 'Reset Filters',
        AppLanguage.de => 'Filter zurücksetzen',
      };

  String get postNewAd => switch (language) {
        AppLanguage.tr => 'Yeni İlan Ver',
        AppLanguage.en => 'Post New Ad',
        AppLanguage.de => 'Neue Anzeige aufgeben',
      };

  String get myGivenOffers => switch (language) {
        AppLanguage.tr => 'Verdiğim Teklifler',
        AppLanguage.en => 'My Offers',
        AppLanguage.de => 'Meine Angebote',
      };

  // General & Common
  String get appName => switch (language) {
        AppLanguage.tr => 'Bereket Ovası',
        AppLanguage.en => 'Fertile Valley',
        AppLanguage.de => 'Fruchtbares Tal',
      };

  String get save => switch (language) {
        AppLanguage.tr => 'Kaydet',
        AppLanguage.en => 'Save',
        AppLanguage.de => 'Speichern',
      };

  String get confirm => switch (language) {
        AppLanguage.tr => 'Onayla',
        AppLanguage.en => 'Confirm',
        AppLanguage.de => 'Bestätigen',
      };

  String get back => switch (language) {
        AppLanguage.tr => 'Geri Dön',
        AppLanguage.en => 'Back',
        AppLanguage.de => 'Zurück',
      };

  String get refresh => switch (language) {
        AppLanguage.tr => 'Yenile',
        AppLanguage.en => 'Refresh',
        AppLanguage.de => 'Aktualisieren',
      };

  String get stock => switch (language) {
        AppLanguage.tr => 'Stok',
        AppLanguage.en => 'Stock',
        AppLanguage.de => 'Bestand',
      };

  String get call => switch (language) {
        AppLanguage.tr => 'Ara',
        AppLanguage.en => 'Call',
        AppLanguage.de => 'Anrufen',
      };

  String get roleProducer => switch (language) {
        AppLanguage.tr => 'Üretici',
        AppLanguage.en => 'Producer',
        AppLanguage.de => 'Erzeuger',
      };

  String get roleConsumer => switch (language) {
        AppLanguage.tr => 'Tüketici',
        AppLanguage.en => 'Consumer',
        AppLanguage.de => 'Verbraucher',
      };

  // Home Screen & Harvest Hero
  String get harvestHeroTag => switch (language) {
        AppLanguage.tr => '🌾 BEREKETİN YOLCULUĞU',
        AppLanguage.en => '🌾 JOURNEY OF ABUNDANCE',
        AppLanguage.de => '🌾 DIE REISE DES SEGENS',
      };

  String get harvestHeroTitle => switch (language) {
        AppLanguage.tr => 'Tarladan sofraya',
        AppLanguage.en => 'From field to table',
        AppLanguage.de => 'Vom Feld auf den Tisch',
      };

  String get harvestHeroDesc => switch (language) {
        AppLanguage.tr =>
          'Üretici ve alıcıyı aynı ovada buluşturan yeni deneyim.',
        AppLanguage.en =>
          'Connecting producers and buyers directly in one fertile valley.',
        AppLanguage.de =>
          'Das neue Erlebnis, das Erzeuger und Käufer direkt vereint.',
      };

  String get harvestHeroAction => switch (language) {
        AppLanguage.tr => 'Pazarı keşfet',
        AppLanguage.en => 'Explore Market',
        AppLanguage.de => 'Markt erkunden',
      };

  String get producerPanelBanner => switch (language) {
        AppLanguage.tr => '🌱 Üretici (Çiftçi) Paneli',
        AppLanguage.en => '🌱 Producer (Farmer) Panel',
        AppLanguage.de => '🌱 Erzeuger- (Landwirt) Bereich',
      };

  String get consumerPanelBanner => switch (language) {
        AppLanguage.tr => '🛒 Tüketici (Alıcı) Paneli',
        AppLanguage.en => '🛒 Consumer (Buyer) Panel',
        AppLanguage.de => '🛒 Verbraucher- (Käufer) Bereich',
      };

  String get producerHomeDesc => switch (language) {
        AppLanguage.tr =>
          'Mahsullerinizi pazara sunun, sürü ve sera durumunu takip edin.',
        AppLanguage.en =>
          'Market your crops, track livestock and greenhouse status.',
        AppLanguage.de =>
          'Vermarkten Sie Ihre Ernte, überwachen Sie Tiere und Gewächshaus.',
      };

  String get consumerHomeDesc => switch (language) {
        AppLanguage.tr =>
          'Yerel üreticilerden taze mahsul bulun ve doğrudan teklif verin.',
        AppLanguage.en =>
          'Find fresh crops from local growers and make direct offers.',
        AppLanguage.de =>
          'Finden Sie frische Produkte lokaler Erzeuger und bieten Sie direkt.',
      };

  String get quickNewAd => switch (language) {
        AppLanguage.tr => '+ Yeni İlan Ver',
        AppLanguage.en => '+ Post New Ad',
        AppLanguage.de => '+ Neue Anzeige',
      };

  String get moduleIncomingOffers => switch (language) {
        AppLanguage.tr => 'Gelen Teklifler',
        AppLanguage.en => 'Incoming Offers',
        AppLanguage.de => 'Erhaltene Angebote',
      };

  String get moduleSentOffers => switch (language) {
        AppLanguage.tr => 'Verdiğim Teklifler',
        AppLanguage.en => 'My Offers',
        AppLanguage.de => 'Meine Angebote',
      };

  String get moduleLogisticsService => switch (language) {
        AppLanguage.tr => 'Nakliye & Hizmet',
        AppLanguage.en => 'Logistics & Services',
        AppLanguage.de => 'Transport & Dienste',
      };

  String get quickIncomingOffers => switch (language) {
        AppLanguage.tr => 'Gelen Teklifler',
        AppLanguage.en => 'Incoming Offers',
        AppLanguage.de => 'Erhaltene Angebote',
      };

  String get quickHerdGreenhouse => switch (language) {
        AppLanguage.tr => 'Sürü & Sera',
        AppLanguage.en => 'Herd & Greenhouse',
        AppLanguage.de => 'Herde & Gewächshaus',
      };

  String get quickSentOffers => switch (language) {
        AppLanguage.tr => 'Verdiğim Teklifler',
        AppLanguage.en => 'My Offers',
        AppLanguage.de => 'Meine Angebote',
      };

  String get quickLogistics => switch (language) {
        AppLanguage.tr => 'Nakliye & Hizmet',
        AppLanguage.en => 'Logistics & Services',
        AppLanguage.de => 'Transport & Dienste',
      };

  String get quickExploreMarket => switch (language) {
        AppLanguage.tr => 'Pazarı Keşfet',
        AppLanguage.en => 'Explore Market',
        AppLanguage.de => 'Marktplatz erkunden',
      };

  String get producerModules => switch (language) {
        AppLanguage.tr => 'Çiftçi Modülleri',
        AppLanguage.en => 'Farmer Modules',
        AppLanguage.de => 'Landwirt-Module',
      };

  String get consumerModules => switch (language) {
        AppLanguage.tr => 'Alıcı Modülleri',
        AppLanguage.en => 'Buyer Modules',
        AppLanguage.de => 'Käufer-Module',
      };

  String get moduleMyListings => switch (language) {
        AppLanguage.tr => 'Mahsul İlanlarım',
        AppLanguage.en => 'My Crop Listings',
        AppLanguage.de => 'Meine Ernteanzeigen',
      };

  String get moduleAnimalsGreenhouse => switch (language) {
        AppLanguage.tr => 'Hayvan ve Sera',
        AppLanguage.en => 'Livestock & Greenhouse',
        AppLanguage.de => 'Tiere & Gewächshaus',
      };

  String get moduleServicesGuide => switch (language) {
        AppLanguage.tr => 'Hizmet Rehberi',
        AppLanguage.en => 'Services Directory',
        AppLanguage.de => 'Agrardienst-Leitfaden',
      };

  String get moduleFreshMarket => switch (language) {
        AppLanguage.tr => 'Taze Mahsul Pazarı',
        AppLanguage.en => 'Fresh Produce Market',
        AppLanguage.de => 'Frischemarkt',
      };

  String get moduleBuyerProfile => switch (language) {
        AppLanguage.tr => 'Alıcı Profilim',
        AppLanguage.en => 'Buyer Profile',
        AppLanguage.de => 'Käuferprofil',
      };

  String get yourListingsHeader => switch (language) {
        AppLanguage.tr => 'Satıştaki Mahsulleriniz',
        AppLanguage.en => 'Your Active Listings',
        AppLanguage.de => 'Ihre aktiven Angebote',
      };

  String get freshFromFieldHeader => switch (language) {
        AppLanguage.tr => 'Tarladan Taze Mahsuller',
        AppLanguage.en => 'Fresh From the Field',
        AppLanguage.de => 'Frisch vom Feld',
      };

  String get manageListings => switch (language) {
        AppLanguage.tr => 'İlanları Yönet',
        AppLanguage.en => 'Manage Listings',
        AppLanguage.de => 'Anzeigen verwalten',
      };

  String get seeAll => switch (language) {
        AppLanguage.tr => 'Tümünü Gör',
        AppLanguage.en => 'See All',
        AppLanguage.de => 'Alle anzeigen',
      };

  String get noProducerProducts => switch (language) {
        AppLanguage.tr =>
          'Henüz satışta bir mahsul ilanınız yok. "+ Yeni İlan Ver" butonuna dokunarak hemen ekleyin.',
        AppLanguage.en =>
          'No active listings yet. Tap "+ Post New Ad" to add one.',
        AppLanguage.de =>
          'Noch keine aktiven Angebote. Tippen Sie auf "+ Neue Anzeige", um eines hinzuzufügen.',
      };

  String get noConsumerProducts => switch (language) {
        AppLanguage.tr => 'Henüz satışta yerel üretici mahsulü bulunmuyor.',
        AppLanguage.en => 'No local produce listings available yet.',
        AppLanguage.de => 'Derzeit sind noch keine Angebote lokaler Erzeuger verfügbar.',
      };

  String get producerHiveNote => switch (language) {
        AppLanguage.tr =>
          '🌱 Üretici modundasınız. Çiftlik verileriniz, sürü aşıları ve pazar ilanlarınız yerel Hive veritabanında saklanır.',
        AppLanguage.en =>
          '🌱 Producer mode active. Farm data, herd vaccines, and listings are stored locally in Hive.',
        AppLanguage.de =>
          '🌱 Erzeugermodus aktiv. Hofdaten, Impfungen und Angebote werden lokal in Hive gespeichert.',
      };

  String get consumerHiveNote => switch (language) {
        AppLanguage.tr =>
          '🛒 Tüketici modundasınız. Yerel üreticilerden doğrudan taze mahsul siparişi ve alım teklifi oluşturabilirsiniz.',
        AppLanguage.en =>
          '🛒 Consumer mode active. Order fresh produce and submit purchase offers directly to local farmers.',
        AppLanguage.de =>
          '🛒 Verbrauchermodus aktiv. Bestellen Sie frische Erzeugnisse und geben Sie Angebote direkt an Landwirte ab.',
      };

  String get badgeYourListing => switch (language) {
        AppLanguage.tr => 'İlanınız',
        AppLanguage.en => 'Your Listing',
        AppLanguage.de => 'Ihre Anzeige',
      };

  String get badgeLocalProducer => switch (language) {
        AppLanguage.tr => 'Yerel Üretici',
        AppLanguage.en => 'Local Producer',
        AppLanguage.de => 'Lokaler Erzeuger',
      };

  String get actionEdit => switch (language) {
        AppLanguage.tr => 'Düzenle →',
        AppLanguage.en => 'Edit →',
        AppLanguage.de => 'Bearbeiten →',
      };

  String get actionMakeOffer => switch (language) {
        AppLanguage.tr => 'Talip Ol →',
        AppLanguage.en => 'Make Offer →',
        AppLanguage.de => 'Anbieten →',
      };

  // Marketplace
  String get marketProducerTitle => switch (language) {
        AppLanguage.tr => 'Mahsul Satış İlanlarım',
        AppLanguage.en => 'My Crop Listings',
        AppLanguage.de => 'Meine Ernteanzeigen',
      };

  String get marketConsumerTitle => switch (language) {
        AppLanguage.tr => 'Tarladan Sofraya Pazar',
        AppLanguage.en => 'Field to Table Market',
        AppLanguage.de => 'Vom-Feld-auf-den-Tisch Markt',
      };

  String get marketProducerBannerTitle => switch (language) {
        AppLanguage.tr => '🌾 Satıştaki Mahsul İlanlarınız',
        AppLanguage.en => '🌾 Your Active Crop Listings',
        AppLanguage.de => '🌾 Ihre aktiven Ernteanzeigen',
      };

  String get marketProducerBannerDesc => switch (language) {
        AppLanguage.tr =>
          'Hasat mahsullerinizi pazara sunun, stok miktarını güncelleyin ve gelen alıcı tekliflerini yanıtlayın.',
        AppLanguage.en =>
          'Publish your harvest, update stock, and respond to incoming buyer offers.',
        AppLanguage.de =>
          'Veröffentlichen Sie Ihre Ernte, aktualisieren Sie Bestände und prüfen Sie Angebote.',
      };

  String get marketConsumerBannerTitle => switch (language) {
        AppLanguage.tr => '🛒 Tarladan Taze Mahsuller',
        AppLanguage.en => '🛒 Fresh Farm Produce',
        AppLanguage.de => '🛒 Frische Produkte vom Erzeuger',
      };

  String get marketConsumerBannerDesc => switch (language) {
        AppLanguage.tr =>
          'Yerel çiftçilerin taze mahsullerini inceleyin, doğrudan teklif verin ve aracısız satın alın.',
        AppLanguage.en =>
          'Browse fresh produce from local farmers, submit offers directly without middlemen.',
        AppLanguage.de =>
          'Entdecken Sie frische Erzeugnisse lokaler Bauern und kaufen Sie direkt ohne Zwischenhändler.',
      };

  String get marketNoResults => switch (language) {
        AppLanguage.tr => 'Arama kriterlerine uygun ilan bulunamadı.',
        AppLanguage.en => 'No listings match your search criteria.',
        AppLanguage.de => 'Keine Angebote entsprechen Ihren Suchkriterien.',
      };

  String get marketEditListing => switch (language) {
        AppLanguage.tr => 'İlanı ve Fiyatı Düzenle',
        AppLanguage.en => 'Edit Listing & Price',
        AppLanguage.de => 'Anzeige & Preis bearbeiten',
      };

  String get marketMakeOffer => switch (language) {
        AppLanguage.tr => 'Bu İlana Talip Ol / Teklif Ver',
        AppLanguage.en => 'Make Offer on This Listing',
        AppLanguage.de => 'Angebot für diese Anzeige abgeben',
      };

  String get stockUpdateTitle => switch (language) {
        AppLanguage.tr => 'Stok Miktarını Güncelle',
        AppLanguage.en => 'Update Stock Quantity',
        AppLanguage.de => 'Bestandsmenge aktualisieren',
      };

  String newQuantityLabel(String unit) => switch (language) {
        AppLanguage.tr => 'Yeni Miktar ($unit)',
        AppLanguage.en => 'New Quantity ($unit)',
        AppLanguage.de => 'Neue Menge ($unit)',
      };

  String get productNotFound => switch (language) {
        AppLanguage.tr => 'Ürün bulunamadı veya yayından kaldırılmış.',
        AppLanguage.en => 'Product not found or removed.',
        AppLanguage.de => 'Produkt nicht gefunden oder entfernt.',
      };

  String stockUpdatedMsg(num qty, String unit) => switch (language) {
        AppLanguage.tr => 'Stok miktarı $qty $unit olarak güncellendi.',
        AppLanguage.en => 'Stock updated to $qty $unit.',
        AppLanguage.de => 'Bestand auf $qty $unit aktualisiert.',
      };

  String get noPhoneProvided => switch (language) {
        AppLanguage.tr => 'Satıcı telefon numarası belirtmemiş.',
        AppLanguage.en => 'No seller phone number provided.',
        AppLanguage.de => 'Keine Telefonnummer des Verkäufers angegeben.',
      };

  String get callFailed => switch (language) {
        AppLanguage.tr => 'Arama başlatılamadı.',
        AppLanguage.en => 'Could not start call.',
        AppLanguage.de => 'Anruf konnte nicht gestartet werden.',
      };

  String get btnViewIncomingOffers => switch (language) {
        AppLanguage.tr => 'Gelen Teklifleri Gör',
        AppLanguage.en => 'View Incoming Offers',
        AppLanguage.de => 'Erhaltene Angebote ansehen',
      };

  // Profile Header & Badges
  String get legendaryFarmer => switch (language) {
        AppLanguage.tr => 'Efsanevi Çiftçi',
        AppLanguage.en => 'Legendary Farmer',
        AppLanguage.de => 'Legendärer Landwirt',
      };

  String get naturalProduceExplorer => switch (language) {
        AppLanguage.tr => 'Doğal Ürün Kaşifi',
        AppLanguage.en => 'Natural Produce Explorer',
        AppLanguage.de => 'Naturprodukt-Entdecker',
      };

  String get producerRoleTitleBadge => switch (language) {
        AppLanguage.tr => 'Başçiftçi • Süper Yönetici (Admin)',
        AppLanguage.en => 'Lead Farmer • Super Admin',
        AppLanguage.de => 'Cheflandwirt • Super-Admin',
      };

  String get consumerRoleTitleBadge => switch (language) {
        AppLanguage.tr => 'Tüketici & Alıcı Üye (Admin)',
        AppLanguage.en => 'Consumer & Buyer Member (Admin)',
        AppLanguage.de => 'Verbraucher & Käufer (Admin)',
      };

  String get producerLocation => switch (language) {
        AppLanguage.tr => 'Konya / Çumra — Bereket Vadisi',
        AppLanguage.en => 'Konya / Çumra — Bereket Valley',
        AppLanguage.de => 'Konya / Çumra — Bereket-Tal',
      };

  String get consumerLocation => switch (language) {
        AppLanguage.tr => 'Konya / Çumra — Doğrudan Alıcı',
        AppLanguage.en => 'Konya / Çumra — Direct Buyer',
        AppLanguage.de => 'Konya / Çumra — Direktkäufer',
      };

  String get badgeHarvestTitle => switch (language) {
        AppLanguage.tr => 'Efsane Hasat',
        AppLanguage.en => 'Legendary Harvest',
        AppLanguage.de => 'Legendäre Ernte',
      };

  String get badgeHarvestDesc => switch (language) {
        AppLanguage.tr => 'Sezonda 500+ kg kaliteli mahsul hasat edildi',
        AppLanguage.en => '500+ kg of quality crop harvested this season',
        AppLanguage.de => '500+ kg Qualitätsfrüchte in der Saison geerntet',
      };

  String get badgeGreenhouseTitle => switch (language) {
        AppLanguage.tr => 'Akıllı Sera 4.0',
        AppLanguage.en => 'Smart Greenhouse 4.0',
        AppLanguage.de => 'Smartes Gewächshaus 4.0',
      };

  String get badgeGreenhouseDesc => switch (language) {
        AppLanguage.tr =>
          'Sera iklim sensörleri %90+ dengeli aralıkta çalışıyor',
        AppLanguage.en =>
          'Greenhouse sensors operate at 90%+ optimal balance',
        AppLanguage.de =>
          'Gewächshaussensoren arbeiten zu 90%+ optimal',
      };

  String get badgeDripTitle => switch (language) {
        AppLanguage.tr => 'Damlama Lideri',
        AppLanguage.en => 'Drip Pioneer',
        AppLanguage.de => 'Tröpfchen-Pionier',
      };

  String get badgeDripDesc => switch (language) {
        AppLanguage.tr =>
          'Suyu verimli kullanan damlama sulama sistemi devrede',
        AppLanguage.en => 'Water-efficient drip irrigation is active',
        AppLanguage.de => 'Wassersparende Tröpfchenbewässerung aktiv',
      };

  String get badgeOrganicTitle => switch (language) {
        AppLanguage.tr => 'Organik Sertifika',
        AppLanguage.en => 'Organic Certified',
        AppLanguage.de => 'Bio-Zertifikat',
      };

  String get badgeOrganicDesc => switch (language) {
        AppLanguage.tr =>
          'Tarımsal kimyasal barındırmayan doğal üretim onayı',
        AppLanguage.en =>
          'Certified natural production free of chemicals',
        AppLanguage.de =>
          'Zertifizierte pestizidfreie Naturproduktion',
      };

  String get badgeFieldToTableTitle => switch (language) {
        AppLanguage.tr => 'Tarladan Sofraya',
        AppLanguage.en => 'Field to Table',
        AppLanguage.de => 'Vom Feld auf den Tisch',
      };

  String get badgeFieldToTableDesc => switch (language) {
        AppLanguage.tr =>
          'Aracısız doğrudan yerel çiftçiden alışveriş yapıldı',
        AppLanguage.en =>
          'Purchased directly from local farmers without middlemen',
        AppLanguage.de =>
          'Direkt vom Erzeuger ohne Zwischenhändler gekauft',
      };

  String get badgeReliableBuyerTitle => switch (language) {
        AppLanguage.tr => 'Güvenilir Alıcı',
        AppLanguage.en => 'Reliable Buyer',
        AppLanguage.de => 'Zuverlässiger Käufer',
      };

  String get badgeReliableBuyerDesc => switch (language) {
        AppLanguage.tr =>
          'Verilen alım teklifleri zamanında ve eksiksiz karşılandı',
        AppLanguage.en =>
          'Purchase offers fulfilled on time and in full',
        AppLanguage.de =>
          'Kaufangebote pünktlich und vollständig erfüllt',
      };

  String get badgeZeroWasteTitle => switch (language) {
        AppLanguage.tr => 'Sıfır Atık Alıcısı',
        AppLanguage.en => 'Zero Waste Buyer',
        AppLanguage.de => 'Zero-Waste Käufer',
      };

  String get badgeZeroWasteDesc => switch (language) {
        AppLanguage.tr =>
          'Hasat fazlası ürünleri değerlendiren bilinçli tüketici',
        AppLanguage.en =>
          'Conscious consumer valuing surplus harvest',
        AppLanguage.de =>
          'Bewusster Verbraucher von Ernteüberschüssen',
      };

  String get badgeRegionalSupportTitle => switch (language) {
        AppLanguage.tr => 'Bölge Destekçisi',
        AppLanguage.en => 'Regional Supporter',
        AppLanguage.de => 'Regionaler Förderer',
      };

  String get badgeRegionalSupportDesc => switch (language) {
        AppLanguage.tr =>
          'Yerel üreticileri destekleyen sürdürülebilir tüketim',
        AppLanguage.en =>
          'Sustainable consumption supporting local growers',
        AppLanguage.de =>
          'Nachhaltiger Konsum zur Unterstützung regionaler Bauern',
      };

  String get roleExplanationHeader => switch (language) {
        AppLanguage.tr => 'Yerel Demo & Veri Kapsamı',
        AppLanguage.en => 'Local Demo & Data Scope',
        AppLanguage.de => 'Lokale Demo & Datenbereich',
      };

  String get roleExplanationBody => switch (language) {
        AppLanguage.tr =>
          'Bu mobil uygulama MVP aşamasında tek cihaz üzerinde Hive veritabanı ile çalışır. İnternet bağlantısı olmadan da verileriniz cihazınızda güvenle saklanır.',
        AppLanguage.en =>
          'This mobile app runs offline with Hive database. Your data is stored safely on device.',
        AppLanguage.de =>
          'Diese App läuft offline mit der Hive-Datenbank. Ihre Daten werden sicher auf dem Gerät gespeichert.',
      };

  String get roleExplanationBullet => switch (language) {
        AppLanguage.tr =>
          '• Üretici kimliği demo_producer_001 olarak temsil edilir.\n• Rol değişimi simülasyon amaçlıdır, anında aktif görünüm filtrelerini uyarlar.',
        AppLanguage.en =>
          '• Producer identity is represented as demo_producer_001.\n• Role switching is instant and adapts view filters.',
        AppLanguage.de =>
          '• Erzeuger-ID wird als demo_producer_001 dargestellt.\n• Rollenwechsel passt Ansichtsfilter sofort an.',
      };

  // Farm Dashboard
  String get farmDashboardTitle => switch (language) {
        AppLanguage.tr => 'Çiftlik & Üretim Paneli',
        AppLanguage.en => 'Farm & Production Panel',
        AppLanguage.de => 'Bauernhof & Produktionsbereich',
      };

  String get tooltipAddGreenhouse => switch (language) {
        AppLanguage.tr => 'Yeni Sera Ekle',
        AppLanguage.en => 'Add New Greenhouse',
        AppLanguage.de => 'Neues Gewächshaus hinzufügen',
      };

  String get tooltipAddAnimal => switch (language) {
        AppLanguage.tr => 'Yeni Hayvan Ekle',
        AppLanguage.en => 'Add New Animal',
        AppLanguage.de => 'Neues Tier hinzufügen',
      };

  String get producerModeRequiredTitle => switch (language) {
        AppLanguage.tr => 'Üretici Modu Gerekli',
        AppLanguage.en => 'Producer Mode Required',
        AppLanguage.de => 'Erzeugermodus erforderlich',
      };

  String get producerModeRequiredDesc => switch (language) {
        AppLanguage.tr =>
          'Yeni kayıt oluşturabilmek için aktif modunuzun Üretici (Çiftçi) olması gerekmektedir. Şimdi Üretici moduna geçiş yapmak ister misiniz?',
        AppLanguage.en =>
          'To create a new record, your active mode must be Producer (Farmer). Switch to Producer mode now?',
        AppLanguage.de =>
          'Um einen neuen Eintrag zu erstellen, muss Ihr Modus Erzeuger (Landwirt) sein. Jetzt wechseln?',
      };

  String get switchToProducerAction => switch (language) {
        AppLanguage.tr => 'Üretici Moduna Geç',
        AppLanguage.en => 'Switch to Producer Mode',
        AppLanguage.de => 'In Erzeugermodus wechseln',
      };

  String get consumerFarmNotice => switch (language) {
        AppLanguage.tr =>
          '🌾 Tüketici İnceleme Modu: Bereket Ovası çiftlik ve sera refahı verilerini görüntülüyorsunuz. Sürüye hayvan kaydetmek için Üretici moduna geçebilirsiniz.',
        AppLanguage.en =>
          '🌾 Consumer Review Mode: Viewing farm and greenhouse welfare data. Switch to Producer mode to register livestock.',
        AppLanguage.de =>
          '🌾 Verbraucher-Prüfmodus: Sie sehen Hof- und Gewächshausdaten. Wechseln Sie in den Erzeugermodus, um Tiere zu erfassen.',
      };

  String get farmTabOverview => switch (language) {
        AppLanguage.tr => 'Tüm Tesis',
        AppLanguage.en => 'All Facility',
        AppLanguage.de => 'Gesamtanlage',
      };

  String get farmTabHerd => switch (language) {
        AppLanguage.tr => 'Sürü Takibi',
        AppLanguage.en => 'Herd Tracking',
        AppLanguage.de => 'Herdenverfolgung',
      };

  String get farmTabGreenhouse => switch (language) {
        AppLanguage.tr => 'Sera Sensörleri',
        AppLanguage.en => 'Greenhouse Sensors',
        AppLanguage.de => 'Gewächshaussensoren',
      };

  // Offers
  String get offersProducerTitle => switch (language) {
        AppLanguage.tr => 'Gelen Ürün Teklifleri',
        AppLanguage.en => 'Incoming Crop Offers',
        AppLanguage.de => 'Erhaltene Produktangebote',
      };

  String get offersConsumerTitle => switch (language) {
        AppLanguage.tr => 'Verilen Tekliflerim',
        AppLanguage.en => 'My Submitted Offers',
        AppLanguage.de => 'Meine abgegebenen Angebote',
      };

  String get offersProducerInfo => switch (language) {
        AppLanguage.tr =>
          'Üretici Modu: Bereket Ovası (demo_producer_001) ilanlarınıza alıcılardan gelen talepler.',
        AppLanguage.en =>
          'Producer Mode: Requests received from buyers for your listings.',
        AppLanguage.de =>
          'Erzeugermodus: Anfragen von Käufern für Ihre Angebote.',
      };

  String get offersConsumerInfo => switch (language) {
        AppLanguage.tr =>
          'Tüketici Modu: Üreticilere ilettiğiniz ürün alım talepleri.',
        AppLanguage.en =>
          'Consumer Mode: Purchase requests sent to growers.',
        AppLanguage.de =>
          'Verbrauchermodus: An Erzeuger übermittelte Kaufanfragen.',
      };

  String get offerFilterAll => switch (language) {
        AppLanguage.tr => 'Tümü',
        AppLanguage.en => 'All',
        AppLanguage.de => 'Alle',
      };

  String get offerFilterPending => switch (language) {
        AppLanguage.tr => 'Bekleyen',
        AppLanguage.en => 'Pending',
        AppLanguage.de => 'Ausstehend',
      };

  String get offerFilterAccepted => switch (language) {
        AppLanguage.tr => 'Kabul Edilen',
        AppLanguage.en => 'Accepted',
        AppLanguage.de => 'Angenommen',
      };

  String get offerFilterRejected => switch (language) {
        AppLanguage.tr => 'Reddedilen',
        AppLanguage.en => 'Rejected',
        AppLanguage.de => 'Abgelehnt',
      };

  String offerDialogTitle(String action) => switch (language) {
        AppLanguage.tr => 'Teklifi $action',
        AppLanguage.en => '$action Offer',
        AppLanguage.de => 'Angebot $action',
      };

  String offerDialogContent(String action) => switch (language) {
        AppLanguage.tr =>
          'Bu teklif yerel olarak "$action" durumuna alınacaktır. Bu işlem gerçek bir ödeme veya sipariş tamamlama değildir.',
        AppLanguage.en =>
          'This offer will locally be marked as "$action". This action is not an actual payment.',
        AppLanguage.de =>
          'Dieses Angebot wird lokal als "$action" markiert. Dies ist keine tatsächliche Zahlung.',
      };

  String offerUpdatedSnackbar(String action) => switch (language) {
        AppLanguage.tr => 'Teklif $action durumuna güncellendi.',
        AppLanguage.en => 'Offer updated to $action.',
        AppLanguage.de => 'Angebot auf $action aktualisiert.',
      };

  String get offerStatusAccepted => switch (language) {
        AppLanguage.tr => 'Kabul Edildi',
        AppLanguage.en => 'Accepted',
        AppLanguage.de => 'Angenommen',
      };

  String get offerStatusRejected => switch (language) {
        AppLanguage.tr => 'Reddedildi',
        AppLanguage.en => 'Rejected',
        AppLanguage.de => 'Abgelehnt',
      };

  String get offerStatusPending => switch (language) {
        AppLanguage.tr => 'Cevap Bekliyor',
        AppLanguage.en => 'Pending',
        AppLanguage.de => 'Warten auf Antwort',
      };

  String get offerActionAccept => switch (language) {
        AppLanguage.tr => 'Kabul Et',
        AppLanguage.en => 'Accept',
        AppLanguage.de => 'Annehmen',
      };

  String get offerActionReject => switch (language) {
        AppLanguage.tr => 'Reddet',
        AppLanguage.en => 'Reject',
        AppLanguage.de => 'Ablehnen',
      };

  String get offerNoOffers => switch (language) {
        AppLanguage.tr => 'Kayıtlı Teklif Bulunamadı',
        AppLanguage.en => 'No Offers Found',
        AppLanguage.de => 'Keine Angebote gefunden',
      };

  String get offerNoProducerOffersDesc => switch (language) {
        AppLanguage.tr =>
          'İlanlarınıza henüz bu filtrede bir teklif gelmedi. Pazar yeri vitrininden ilanlarınızı kontrol edebilir veya yeni teklifler oluşturabilirsiniz.',
        AppLanguage.en =>
          'No offers received in this filter yet. Check your listings in the marketplace or create new offers.',
        AppLanguage.de =>
          'Noch keine Angebote in diesem Filter erhalten. Überprüfen Sie Ihre Angebote auf dem Marktplatz.',
      };

  String get offerNoConsumerOffersDesc => switch (language) {
        AppLanguage.tr =>
          'Henüz bir üretici ilanına teklif vermediniz. Pazar yerinden dilediğiniz mahsule teklif verebilirsiniz.',
        AppLanguage.en =>
          'You have not submitted an offer yet. Browse marketplace produce to submit an offer.',
        AppLanguage.de =>
          'Sie haben noch kein Angebot abgegeben. Durchsuchen Sie Ernteprodukte auf dem Marktplatz.',
      };

  String offerShowAll(int count) => switch (language) {
        AppLanguage.tr => 'Tüm Teklifleri Göster ($count)',
        AppLanguage.en => 'Show All Offers ($count)',
        AppLanguage.de => 'Alle Angebote anzeigen ($count)',
      };

  String get offerLoadDemo => switch (language) {
        AppLanguage.tr => 'Örnek Teklifleri Yükle',
        AppLanguage.en => 'Load Sample Offers',
        AppLanguage.de => 'Beispielangebote laden',
      };

  String get offerGoToMarketplace => switch (language) {
        AppLanguage.tr => 'Pazar Yeri Vitrinine Git',
        AppLanguage.en => 'Go to Marketplace',
        AppLanguage.de => 'Zum Marktplatz',
      };

  String get offerDatePrefix => switch (language) {
        AppLanguage.tr => 'Teklif Tarihi:',
        AppLanguage.en => 'Offer Date:',
        AppLanguage.de => 'Angebotsdatum:',
      };

  String get offerRequestedQty => switch (language) {
        AppLanguage.tr => 'Talep Edilen Miktar',
        AppLanguage.en => 'Requested Quantity',
        AppLanguage.de => 'Angeforderte Menge',
      };

  String get offerEstimatedAmount => switch (language) {
        AppLanguage.tr => 'Tahmini Tutar',
        AppLanguage.en => 'Estimated Amount',
        AppLanguage.de => 'Geschätzter Betrag',
      };

  String get offerBuyerPrefix => switch (language) {
        AppLanguage.tr => 'Alıcı:',
        AppLanguage.en => 'Buyer:',
        AppLanguage.de => 'Käufer:',
      };

  String get offerProducerPrefix => switch (language) {
        AppLanguage.tr => 'Üretici:',
        AppLanguage.en => 'Producer:',
        AppLanguage.de => 'Erzeuger:',
      };

  String offerBuyerYou(String name) => switch (language) {
        AppLanguage.tr => 'Teklif Veren: $name (Siz)',
        AppLanguage.en => 'Offer By: $name (You)',
        AppLanguage.de => 'Angebot von: $name (Sie)',
      };

  String offerRemovedProduct(String id) => switch (language) {
        AppLanguage.tr => 'Kaldırılmış Ürün (#$id)',
        AppLanguage.en => 'Removed Product (#$id)',
        AppLanguage.de => 'Entferntes Produkt (#$id)',
      };

  // Services
  String get servicesTitle => switch (language) {
        AppLanguage.tr => 'Tarımsal Hizmet Rehberi',
        AppLanguage.en => 'Agricultural Services Guide',
        AppLanguage.de => 'Agrardienst-Leitfaden',
      };

  String get servicesSearchHint => switch (language) {
        AppLanguage.tr => 'Hizmet, veteriner veya makine ara...',
        AppLanguage.en => 'Search services, vets or machinery...',
        AppLanguage.de => 'Dienste, Tierärzte oder Maschinen suchen...',
      };

  String get servicesEmpty => switch (language) {
        AppLanguage.tr =>
          'Aradığınız kriterlere uygun hizmet sağlayıcı bulunamadı.',
        AppLanguage.en => 'No service providers found matching your criteria.',
        AppLanguage.de => 'Keine Dienstleister gefunden.',
      };

  String get servicesEmptyTitle => switch (language) {
        AppLanguage.tr => 'Eşleşen Hizmet Bulunamadı',
        AppLanguage.en => 'No Matching Services Found',
        AppLanguage.de => 'Keine passenden Dienste gefunden',
      };

  String get servicesEmptyDesc => switch (language) {
        AppLanguage.tr =>
          'Seçilen kategori veya şehirde kayıtlı hizmet sağlayıcı bulunmuyor. Farklı arama terimleri deneyebilirsiniz.',
        AppLanguage.en =>
          'No service providers registered in this category or city. Try different search terms.',
        AppLanguage.de =>
          'Keine Dienstleister in dieser Kategorie oder Region gefunden. Probieren Sie andere Suchbegriffe.',
      };

  String get servicesClearFilters => switch (language) {
        AppLanguage.tr => 'Filtreleri Temizle',
        AppLanguage.en => 'Clear Filters',
        AppLanguage.de => 'Filter zurücksetzen',
      };

  String get servicesAllCities => switch (language) {
        AppLanguage.tr => 'Tüm Şehirler / Bölgeler',
        AppLanguage.en => 'All Cities / Regions',
        AppLanguage.de => 'Alle Städte / Regionen',
      };

  String get servicesCallNow => switch (language) {
        AppLanguage.tr => 'Hemen Ara',
        AppLanguage.en => 'Call Now',
        AppLanguage.de => 'Jetzt anrufen',
      };

  String get servicesNoPhone => switch (language) {
        AppLanguage.tr => 'Telefon belirtilmemiş',
        AppLanguage.en => 'No phone provided',
        AppLanguage.de => 'Kein Telefon angegeben',
      };

  String serviceCategoryLabel(String key) => switch (key.toLowerCase()) {
        'veterinary' => switch (language) {
            AppLanguage.tr => 'Veteriner',
            AppLanguage.en => 'Veterinary',
            AppLanguage.de => 'Tierarzt',
          },
        'tractor' => switch (language) {
            AppLanguage.tr => 'Traktör',
            AppLanguage.en => 'Tractor',
            AppLanguage.de => 'Traktor',
          },
        'harvester' => switch (language) {
            AppLanguage.tr => 'Biçerdöver',
            AppLanguage.en => 'Harvester',
            AppLanguage.de => 'Mähdrescher',
          },
        'logistics' => switch (language) {
            AppLanguage.tr => 'Lojistik',
            AppLanguage.en => 'Logistics',
            AppLanguage.de => 'Logistik',
          },
        _ => switch (language) {
            AppLanguage.tr => 'Tümü',
            AppLanguage.en => 'All',
            AppLanguage.de => 'Alle',
          },
      };

  String serviceTypeLabel(String key) => switch (key.toLowerCase()) {
        'veterinary' => switch (language) {
            AppLanguage.tr => 'Veteriner Hekim',
            AppLanguage.en => 'Veterinarian',
            AppLanguage.de => 'Tierarzt',
          },
        'tractor' => switch (language) {
            AppLanguage.tr => 'Traktör Kiralama',
            AppLanguage.en => 'Tractor Rental',
            AppLanguage.de => 'Traktorverleih',
          },
        'harvester' => switch (language) {
            AppLanguage.tr => 'Biçerdöver',
            AppLanguage.en => 'Harvester',
            AppLanguage.de => 'Mähdrescher',
          },
        'logistics' => switch (language) {
            AppLanguage.tr => 'Ürün Nakliyesi',
            AppLanguage.en => 'Product Logistics',
            AppLanguage.de => 'Produktlogistik',
          },
        _ => switch (language) {
            AppLanguage.tr => 'Tarım Desteği',
            AppLanguage.en => 'Agri Support',
            AppLanguage.de => 'Agrarhilfe',
          },
      };

  // Category and Filter Helpers
  String translateCategory(String cat) {
    final lower = cat.toLowerCase().trim();
    if (lower == 'tümü' || lower == 'all' || lower == 'alle') {
      return switch (language) {
        AppLanguage.tr => 'Tümü',
        AppLanguage.en => 'All',
        AppLanguage.de => 'Alle',
      };
    }
    if (lower == 'tahıl' || lower == 'grains' || lower == 'getreide') {
      return switch (language) {
        AppLanguage.tr => 'Tahıl',
        AppLanguage.en => 'Grains',
        AppLanguage.de => 'Getreide',
      };
    }
    if (lower == 'meyve' || lower == 'fruit' || lower == 'obst') {
      return switch (language) {
        AppLanguage.tr => 'Meyve',
        AppLanguage.en => 'Fruit',
        AppLanguage.de => 'Obst',
      };
    }
    if (lower == 'sebze' || lower == 'vegetables' || lower == 'gemüse') {
      return switch (language) {
        AppLanguage.tr => 'Sebze',
        AppLanguage.en => 'Vegetables',
        AppLanguage.de => 'Gemüse',
      };
    }
    if (lower.contains('süt') || lower.contains('dairy') || lower.contains('milch')) {
      return switch (language) {
        AppLanguage.tr => 'Süt & Hayvancılık',
        AppLanguage.en => 'Dairy & Livestock',
        AppLanguage.de => 'Milch & Vieh',
      };
    }
    if (lower == 'bakliyat' || lower == 'legumes' || lower == 'hülsenfrüchte') {
      return switch (language) {
        AppLanguage.tr => 'Bakliyat',
        AppLanguage.en => 'Legumes',
        AppLanguage.de => 'Hülsenfrüchte',
      };
    }
    if (lower == 'yem' || lower == 'feed' || lower == 'futtermittel') {
      return switch (language) {
        AppLanguage.tr => 'Yem',
        AppLanguage.en => 'Feed',
        AppLanguage.de => 'Futtermittel',
      };
    }
    return cat;
  }

  String translateCity(String city) {
    if (city.toLowerCase() == 'tümü' || city.toLowerCase() == 'all') {
      return switch (language) {
        AppLanguage.tr => 'Tüm Şehirler',
        AppLanguage.en => 'All Cities',
        AppLanguage.de => 'Alle Städte',
      };
    }
    return city;
  }

  String translateUnit(String unit) {
    final lower = unit.toLowerCase();
    if (lower == 'adet' || lower == 'piece' || lower == 'stück') {
      return switch (language) {
        AppLanguage.tr => 'Adet',
        AppLanguage.en => 'Piece',
        AppLanguage.de => 'Stück',
      };
    }
    if (lower == 'kasa' || lower == 'crate' || lower == 'kiste') {
      return switch (language) {
        AppLanguage.tr => 'Kasa',
        AppLanguage.en => 'Crate',
        AppLanguage.de => 'Kiste',
      };
    }
    if (lower == 'çuval' || lower == 'cuval' || lower == 'sack') {
      return switch (language) {
        AppLanguage.tr => 'Çuval',
        AppLanguage.en => 'Sack',
        AppLanguage.de => 'Sack',
      };
    }
    if (lower == 'bağ' || lower == 'bag' || lower == 'bundle' || lower == 'bund') {
      return switch (language) {
        AppLanguage.tr => 'Bağ',
        AppLanguage.en => 'Bundle',
        AppLanguage.de => 'Bund',
      };
    }
    if (lower == 'demet' || lower == 'bunch') {
      return switch (language) {
        AppLanguage.tr => 'Demet',
        AppLanguage.en => 'Bunch',
        AppLanguage.de => 'Bund',
      };
    }
    if (lower == 'ton' || lower == 'tonne') {
      return switch (language) {
        AppLanguage.tr => 'Ton',
        AppLanguage.en => 'Ton',
        AppLanguage.de => 'Tonne',
      };
    }
    if (lower == 'litre' || lower == 'lt' || lower == 'liter') {
      return switch (language) {
        AppLanguage.tr => 'Litre',
        AppLanguage.en => 'Liter',
        AppLanguage.de => 'Liter',
      };
    }
    if (lower == 'kg' || lower == 'kilogram') {
      return 'kg';
    }
    return unit;
  }

  String translateSpecies(String species) {
    final lower = species.toLowerCase();
    if (lower.contains('inek')) {
      return switch (language) {
        AppLanguage.tr => 'İnek (Büyükbaş)',
        AppLanguage.en => 'Cow (Cattle)',
        AppLanguage.de => 'Kuh (Rind)',
      };
    } else if (lower.contains('düve')) {
      return switch (language) {
        AppLanguage.tr => 'Düve (Büyükbaş)',
        AppLanguage.en => 'Heifer (Cattle)',
        AppLanguage.de => 'Färse (Rind)',
      };
    } else if (lower.contains('tosun') || lower.contains('boğa')) {
      return switch (language) {
        AppLanguage.tr => 'Tosun (Büyükbaş)',
        AppLanguage.en => 'Bull (Cattle)',
        AppLanguage.de => 'Stier (Rind)',
      };
    } else if (lower.contains('koyun')) {
      return switch (language) {
        AppLanguage.tr => 'Koyun (Küçükbaş)',
        AppLanguage.en => 'Sheep (Small ruminant)',
        AppLanguage.de => 'Schaf (Kleinvieh)',
      };
    } else if (lower.contains('kuzu')) {
      return switch (language) {
        AppLanguage.tr => 'Kuzu (Küçükbaş)',
        AppLanguage.en => 'Lamb (Small ruminant)',
        AppLanguage.de => 'Lamm (Kleinvieh)',
      };
    } else if (lower.contains('keçi')) {
      return switch (language) {
        AppLanguage.tr => 'Keçi (Küçükbaş)',
        AppLanguage.en => 'Goat (Small ruminant)',
        AppLanguage.de => 'Ziege (Kleinvieh)',
      };
    } else if (lower.contains('manda')) {
      return switch (language) {
        AppLanguage.tr => 'Manda (Büyükbaş)',
        AppLanguage.en => 'Water Buffalo',
        AppLanguage.de => 'Wasserbüffel',
      };
    }
    return species;
  }

  String pregnancyBadgeLabel(String status) => switch (status.toLowerCase()) {
        'pregnant' => switch (language) {
            AppLanguage.tr => 'Gebe',
            AppLanguage.en => 'Pregnant',
            AppLanguage.de => 'Trächtig',
          },
        'not_pregnant' => switch (language) {
            AppLanguage.tr => 'Gebe Değil',
            AppLanguage.en => 'Not Pregnant',
            AppLanguage.de => 'Nicht trächtig',
          },
        _ => switch (language) {
            AppLanguage.tr => 'Bilinmiyor',
            AppLanguage.en => 'Unknown',
            AppLanguage.de => 'Unbekannt',
          },
      };

  // Farm Summary Header & Animals
  String get farmName => switch (language) {
        AppLanguage.tr => 'Bereket Çiftliği',
        AppLanguage.en => 'Bereket Farm',
        AppLanguage.de => 'Bereket Bauernhof',
      };

  String get farmCenterSubtitle => switch (language) {
        AppLanguage.tr => 'Sürü & Sera Operasyon Merkezi',
        AppLanguage.en => 'Herd & Greenhouse Operations Center',
        AppLanguage.de => 'Herden- & Gewächshaus-Zentrum',
      };

  String get addAnimalBtn => switch (language) {
        AppLanguage.tr => 'Hayvan Ekle',
        AppLanguage.en => 'Add Animal',
        AppLanguage.de => 'Tier hinzufügen',
      };

  String get registeredHerdLabel => switch (language) {
        AppLanguage.tr => 'Kayıtlı Sürü',
        AppLanguage.en => 'Registered Herd',
        AppLanguage.de => 'Erfasste Herde',
      };

  String get vaccinationRecordsLabel => switch (language) {
        AppLanguage.tr => 'Aşı Kaydı',
        AppLanguage.en => 'Vaccination Records',
        AppLanguage.de => 'Impfungen',
      };

  String get activeGreenhousesLabel => switch (language) {
        AppLanguage.tr => 'Aktif Sera',
        AppLanguage.en => 'Active Greenhouses',
        AppLanguage.de => 'Aktive Gewächshäuser',
      };

  String get registeredAnimalsTitle => switch (language) {
        AppLanguage.tr => 'Kayıtlı Hayvanlar',
        AppLanguage.en => 'Registered Animals',
        AppLanguage.de => 'Erfasste Tiere',
      };

  String get filterAll => switch (language) {
        AppLanguage.tr => 'Tümü',
        AppLanguage.en => 'All',
        AppLanguage.de => 'Alle',
      };

  String get pregnantFilter => switch (language) {
        AppLanguage.tr => 'Gebeler',
        AppLanguage.en => 'Pregnant',
        AppLanguage.de => 'Trächtig',
      };

  String get vaccinatedFilter => switch (language) {
        AppLanguage.tr => 'Aşılı',
        AppLanguage.en => 'Vaccinated',
        AppLanguage.de => 'Geimpft',
      };

  String get noAnimalsFound => switch (language) {
        AppLanguage.tr => 'Bu kritere uygun hayvan kaydı yok',
        AppLanguage.en => 'No animal records match this filter',
        AppLanguage.de => 'Keine passenden Tiere gefunden',
      };

  String get noAnimalsDesc => switch (language) {
        AppLanguage.tr =>
          'Yeni hayvan kaydı ekleyerek sürünüzü takip edebilirsiniz.',
        AppLanguage.en => 'Track your herd by adding new animals.',
        AppLanguage.de =>
          'Verfolgen Sie Ihre Herde, indem Sie neue Tiere erfassen.',
      };

  String get addFirstAnimalBtn => switch (language) {
        AppLanguage.tr => 'İlk Hayvanı Ekle',
        AppLanguage.en => 'Add First Animal',
        AppLanguage.de => 'Erstes Tier hinzufügen',
      };

  String get lastVaccineLabel => switch (language) {
        AppLanguage.tr => 'Son Aşı:',
        AppLanguage.en => 'Last Vaccine:',
        AppLanguage.de => 'Letzte Impfung:',
      };

  String get noVaccineRecord => switch (language) {
        AppLanguage.tr => 'Kayıtlı Aşı Yok',
        AppLanguage.en => 'No Vaccine Record',
        AppLanguage.de => 'Keine Impfung erfasst',
      };

  String animalDeletedMsg(String tag) => switch (language) {
        AppLanguage.tr => '$tag kaydı silindi.',
        AppLanguage.en => '$tag record deleted.',
        AppLanguage.de => '$tag Datensatz gelöscht.',
      };

  // Greenhouse
  String get greenhouseClimateTitle => switch (language) {
        AppLanguage.tr => 'Sera İklim İzleme',
        AppLanguage.en => 'Greenhouse Climate Monitoring',
        AppLanguage.de => 'Gewächshausklima-Überwachung',
      };

  String get addGreenhouseBtn => switch (language) {
        AppLanguage.tr => 'Sera Ekle',
        AppLanguage.en => 'Add Greenhouse',
        AppLanguage.de => 'Gewächshaus hinzufügen',
      };

  String get simStop => switch (language) {
        AppLanguage.tr => 'Durdur',
        AppLanguage.en => 'Pause',
        AppLanguage.de => 'Pause',
      };

  String get simLive => switch (language) {
        AppLanguage.tr => 'Canlı',
        AppLanguage.en => 'Live',
        AppLanguage.de => 'Live',
      };

  String get noGreenhousesFound => switch (language) {
        AppLanguage.tr => 'Kayıtlı sera ünitesi bulunamadı.',
        AppLanguage.en => 'No registered greenhouse units found.',
        AppLanguage.de => 'Keine Gewächshauseinheiten gefunden.',
      };

  String get addFirstGreenhouseBtn => switch (language) {
        AppLanguage.tr => 'İlk Sera Ünitesini Ekle',
        AppLanguage.en => 'Add First Greenhouse',
        AppLanguage.de => 'Erstes Gewächshaus hinzufügen',
      };

  String get lastUpdateLabel => switch (language) {
        AppLanguage.tr => 'Son Güncelleme:',
        AppLanguage.en => 'Last Update:',
        AppLanguage.de => 'Letzte Aktualisierung:',
      };

  String get editDeleteGreenhouseTooltip => switch (language) {
        AppLanguage.tr => 'Serayı Düzenle / Sil',
        AppLanguage.en => 'Edit / Delete Greenhouse',
        AppLanguage.de => 'Gewächshaus bearbeiten / löschen',
      };

  String get simulatedSensorNotice => switch (language) {
        AppLanguage.tr => 'Simüle sensör verisi (5 sn döngülü)',
        AppLanguage.en => 'Simulated sensor data (5s cycle)',
        AppLanguage.de => 'Simulierte Sensordaten (5 Sek. Zyklus)',
      };

  String get temperatureLabel => switch (language) {
        AppLanguage.tr => 'Sıcaklık',
        AppLanguage.en => 'Temperature',
        AppLanguage.de => 'Temperatur',
      };

  String get optimalClimate => switch (language) {
        AppLanguage.tr => 'Optimal İklim',
        AppLanguage.en => 'Optimal Climate',
        AppLanguage.de => 'Optimales Klima',
      };

  String get outOfRange => switch (language) {
        AppLanguage.tr => 'Limit Dışı',
        AppLanguage.en => 'Out of Range',
        AppLanguage.de => 'Außerhalb des Bereichs',
      };

  String get humidityLabel => switch (language) {
        AppLanguage.tr => 'Hava Nemi',
        AppLanguage.en => 'Air Humidity',
        AppLanguage.de => 'Luftfeuchtigkeit',
      };

  String get balancedHumidity => switch (language) {
        AppLanguage.tr => 'Dengeli Nem',
        AppLanguage.en => 'Balanced Humidity',
        AppLanguage.de => 'Ausgeglichene Feuchtigkeit',
      };

  String get adjustmentNeeded => switch (language) {
        AppLanguage.tr => 'Ayarlama Gerekli',
        AppLanguage.en => 'Adjustment Needed',
        AppLanguage.de => 'Anpassung erforderlich',
      };

  // Sheets & Dialogs
  String get newAnimalTitle => switch (language) {
        AppLanguage.tr => 'Yeni Hayvan Kaydı',
        AppLanguage.en => 'New Animal Record',
        AppLanguage.de => 'Neue Tiererfassung',
      };

  String get editAnimalTitle => switch (language) {
        AppLanguage.tr => 'Hayvan Bilgilerini Düzenle',
        AppLanguage.en => 'Edit Animal Info',
        AppLanguage.de => 'Tierdaten bearbeiten',
      };

  String get animalDetailsTitle => switch (language) {
        AppLanguage.tr => 'Hayvan Detayları',
        AppLanguage.en => 'Animal Details',
        AppLanguage.de => 'Tierdetails',
      };

  String get earTagLabel => switch (language) {
        AppLanguage.tr => 'Küpe Numarası *',
        AppLanguage.en => 'Ear Tag Number *',
        AppLanguage.de => 'Ohrmarkennummer *',
      };

  String get earTagHint => switch (language) {
        AppLanguage.tr => 'Örn: TR-06-A-9921',
        AppLanguage.en => 'E.g: TR-06-A-9921',
        AppLanguage.de => 'Z.B: TR-06-A-9921',
      };

  String get speciesLabel => switch (language) {
        AppLanguage.tr => 'Hayvan Türü / Irkı *',
        AppLanguage.en => 'Animal Species / Breed *',
        AppLanguage.de => 'Tierart / Rasse *',
      };

  String get pregnancyStatusLabel => switch (language) {
        AppLanguage.tr => 'Gebelik Durumu',
        AppLanguage.en => 'Pregnancy Status',
        AppLanguage.de => 'Trächtigkeitsstatus',
      };

  String get lastVaccineDateLabel => switch (language) {
        AppLanguage.tr => 'Son Aşı Tarihi',
        AppLanguage.en => 'Last Vaccination Date',
        AppLanguage.de => 'Letztes Impfdatum',
      };

  String get pickDateHelp => switch (language) {
        AppLanguage.tr => 'Son Aşı Tarihini Seçin',
        AppLanguage.en => 'Select Last Vaccination Date',
        AppLanguage.de => 'Letztes Impfdatum auswählen',
      };

  String get selectBtn => switch (language) {
        AppLanguage.tr => 'Seç',
        AppLanguage.en => 'Select',
        AppLanguage.de => 'Auswählen',
      };

  String get newGreenhouseTitle => switch (language) {
        AppLanguage.tr => 'Yeni Sera Ünitesi Ekle',
        AppLanguage.en => 'Add New Greenhouse Unit',
        AppLanguage.de => 'Neues Gewächshaus hinzufügen',
      };

  String get editGreenhouseTitle => switch (language) {
        AppLanguage.tr => 'Sera Ünitesini Düzenle',
        AppLanguage.en => 'Edit Greenhouse Unit',
        AppLanguage.de => 'Gewächshaus bearbeiten',
      };

  String get greenhouseNameLabel => switch (language) {
        AppLanguage.tr => 'Sera Adı *',
        AppLanguage.en => 'Greenhouse Name *',
        AppLanguage.de => 'Gewächshausname *',
      };

  String get initialTempLabel => switch (language) {
        AppLanguage.tr => 'Başlangıç Sıcaklığı (°C)',
        AppLanguage.en => 'Initial Temperature (°C)',
        AppLanguage.de => 'Starttemperatur (°C)',
      };

  String get initialHumLabel => switch (language) {
        AppLanguage.tr => 'Başlangıç Nemi (%)',
        AppLanguage.en => 'Initial Humidity (%)',
        AppLanguage.de => 'Startfeuchtigkeit (%)',
      };

  String get deleteGreenhouseBtn => switch (language) {
        AppLanguage.tr => 'Serayı Sil',
        AppLanguage.en => 'Delete Greenhouse',
        AppLanguage.de => 'Gewächshaus löschen',
      };

  String get deleteAnimalBtn => switch (language) {
        AppLanguage.tr => 'Hayvanı Sil',
        AppLanguage.en => 'Delete Animal',
        AppLanguage.de => 'Tier löschen',
      };

  String get saveBtn => switch (language) {
        AppLanguage.tr => 'Kaydet',
        AppLanguage.en => 'Save',
        AppLanguage.de => 'Speichern',
      };

  String get deleteBtn => switch (language) {
        AppLanguage.tr => 'Sil',
        AppLanguage.en => 'Delete',
        AppLanguage.de => 'Löschen',
      };

  String get editBtn => switch (language) {
        AppLanguage.tr => 'Düzenle',
        AppLanguage.en => 'Edit',
        AppLanguage.de => 'Bearbeiten',
      };

  // Marketplace & Add Product Form
  String get allCitiesLabel => switch (language) {
        AppLanguage.tr => 'Tüm Şehirler',
        AppLanguage.en => 'All Cities',
        AppLanguage.de => 'Alle Städte',
      };

  String get filterResetBtn => switch (language) {
        AppLanguage.tr => 'Sıfırla',
        AppLanguage.en => 'Reset',
        AppLanguage.de => 'Zurücksetzen',
      };

  String get categoryTitle => switch (language) {
        AppLanguage.tr => 'Kategori',
        AppLanguage.en => 'Category',
        AppLanguage.de => 'Kategorie',
      };

  String get productTitleLabel => switch (language) {
        AppLanguage.tr => 'İlan Başlığı *',
        AppLanguage.en => 'Listing Title *',
        AppLanguage.de => 'Anzeigentitel *',
      };

  String get titleRequiredMsg => switch (language) {
        AppLanguage.tr => 'Başlık zorunludur',
        AppLanguage.en => 'Title is required',
        AppLanguage.de => 'Titel ist erforderlich',
      };

  String get quantityLabel => switch (language) {
        AppLanguage.tr => 'Miktar *',
        AppLanguage.en => 'Quantity *',
        AppLanguage.de => 'Menge *',
      };

  String get unitLabel => switch (language) {
        AppLanguage.tr => 'Birim',
        AppLanguage.en => 'Unit',
        AppLanguage.de => 'Einheit',
      };

  String get unitPriceLabel => switch (language) {
        AppLanguage.tr => 'Birim Fiyat (₺) *',
        AppLanguage.en => 'Unit Price (₺) *',
        AppLanguage.de => 'Einzelpreis (₺) *',
      };

  String get cityLabel => switch (language) {
        AppLanguage.tr => 'Şehir *',
        AppLanguage.en => 'City *',
        AppLanguage.de => 'Stadt *',
      };

  String get districtLabel => switch (language) {
        AppLanguage.tr => 'İlçe *',
        AppLanguage.en => 'District *',
        AppLanguage.de => 'Bezirk *',
      };

  String get contactPhoneLabel => switch (language) {
        AppLanguage.tr => 'İletişim Telefonu *',
        AppLanguage.en => 'Contact Phone *',
        AppLanguage.de => 'Kontakt-Telefon *',
      };

  String get descriptionLabel => switch (language) {
        AppLanguage.tr => 'Açıklama',
        AppLanguage.en => 'Description',
        AppLanguage.de => 'Beschreibung',
      };

  String get publishListingBtn => switch (language) {
        AppLanguage.tr => 'İlanı Yayınla',
        AppLanguage.en => 'Publish Listing',
        AppLanguage.de => 'Anzeige veröffentlichen',
      };

  String get listingPublishedSuccess => switch (language) {
        AppLanguage.tr => 'İlanınız başarıyla yayına alındı.',
        AppLanguage.en => 'Your listing has been published.',
        AppLanguage.de => 'Ihre Anzeige wurde veröffentlicht.',
      };

  String get producerOnlyPublishWarning => switch (language) {
        AppLanguage.tr => 'Yalnızca üreticiler yeni ilan verebilir',
        AppLanguage.en => 'Only producers can post new listings',
        AppLanguage.de => 'Nur Erzeuger können neue Anzeigen aufgeben',
      };

  // Offer Form Screen
  String get sendOfferTitle => switch (language) {
        AppLanguage.tr => 'Alım Teklifi Gönder',
        AppLanguage.en => 'Send Purchase Offer',
        AppLanguage.de => 'Kaufangebot senden',
      };

  String get createOfferTitle => switch (language) {
        AppLanguage.tr => 'Teklif Oluştur',
        AppLanguage.en => 'Create Offer',
        AppLanguage.de => 'Angebot erstellen',
      };

  String get productNotFoundTitle => switch (language) {
        AppLanguage.tr => 'Ürün Bulunamadı',
        AppLanguage.en => 'Product Not Found',
        AppLanguage.de => 'Produkt nicht gefunden',
      };

  String get productNotFoundDesc => switch (language) {
        AppLanguage.tr =>
          'Teklif vermek istediğiniz ürün satıştan kaldırılmış veya sistemde kayıtlı değil.',
        AppLanguage.en =>
          'The product you want to offer on has been removed or is not registered.',
        AppLanguage.de =>
          'Das gewünschte Produkt wurde entfernt oder ist nicht registriert.',
      };

  String get backToMarketBtn => switch (language) {
        AppLanguage.tr => 'Pazara Geri Dön',
        AppLanguage.en => 'Back to Market',
        AppLanguage.de => 'Zurück zum Markt',
      };

  String get availableStockLabel => switch (language) {
        AppLanguage.tr => 'Mevcut Stok:',
        AppLanguage.en => 'Available Stock:',
        AppLanguage.de => 'Verfügbarer Bestand:',
      };

  String get buyerInfoTitle => switch (language) {
        AppLanguage.tr => 'Alıcı Bilgileri',
        AppLanguage.en => 'Buyer Information',
        AppLanguage.de => 'Käuferinformationen',
      };

  String get buyerNameLabel => switch (language) {
        AppLanguage.tr => 'İsim Soyisim *',
        AppLanguage.en => 'Full Name *',
        AppLanguage.de => 'Vor- und Nachname *',
      };

  String get buyerPhoneLabel => switch (language) {
        AppLanguage.tr => 'Telefon *',
        AppLanguage.en => 'Phone *',
        AppLanguage.de => 'Telefon *',
      };

  String get offerQtyLabel => switch (language) {
        AppLanguage.tr => 'Teklif Miktarı *',
        AppLanguage.en => 'Offer Quantity *',
        AppLanguage.de => 'Angebotsmenge *',
      };

  String get offerNoteLabel => switch (language) {
        AppLanguage.tr => 'Not / Mesaj',
        AppLanguage.en => 'Note / Message',
        AppLanguage.de => 'Notiz / Nachricht',
      };

  String get estimatedTotalLabel => switch (language) {
        AppLanguage.tr => 'Tahmini Toplam Tutar',
        AppLanguage.en => 'Estimated Total Amount',
        AppLanguage.de => 'Geschätzter Gesamtbetrag',
      };

  String get submitOfferBtn => switch (language) {
        AppLanguage.tr => 'Teklifi İlet',
        AppLanguage.en => 'Submit Offer',
        AppLanguage.de => 'Angebot übermitteln',
      };

  String get offerSubmittedSuccess => switch (language) {
        AppLanguage.tr => 'Teklifiniz başarıyla üreticiye iletildi.',
        AppLanguage.en => 'Your offer was successfully submitted.',
        AppLanguage.de => 'Ihr Angebot wurde erfolgreich übermittelt.',
      };

  // Login & Splash Screen
  String get loginSubtitle => switch (language) {
        AppLanguage.tr => 'Üretici ve alıcı ekosistemine giriş yapın',
        AppLanguage.en => 'Sign in to the grower & buyer ecosystem',
        AppLanguage.de => 'Melden Sie sich im Erzeuger- & Käufer-Ökosystem an',
      };

  String get usernameLabel => switch (language) {
        AppLanguage.tr => 'Kullanıcı Adı',
        AppLanguage.en => 'Username',
        AppLanguage.de => 'Benutzername',
      };

  String get usernameRequired => switch (language) {
        AppLanguage.tr => 'Kullanıcı adı boş bırakılamaz',
        AppLanguage.en => 'Username cannot be empty',
        AppLanguage.de => 'Benutzername darf nicht leer sein',
      };

  String get passwordLabel => switch (language) {
        AppLanguage.tr => 'Şifre',
        AppLanguage.en => 'Password',
        AppLanguage.de => 'Passwort',
      };

  String get passwordRequired => switch (language) {
        AppLanguage.tr => 'Şifre boş bırakılamaz',
        AppLanguage.en => 'Password cannot be empty',
        AppLanguage.de => 'Passwort darf nicht leer sein',
      };

  String get quickDemoLogin => switch (language) {
        AppLanguage.tr => 'Otomatik Doldur',
        AppLanguage.en => 'Auto Fill',
        AppLanguage.de => 'Automatisch ausfüllen',
      };

  String get demoLoginInfoTitle => switch (language) {
        AppLanguage.tr => 'Demo Giriş Bilgileri',
        AppLanguage.en => 'Demo Login Credentials',
        AppLanguage.de => 'Demo-Anmeldedaten',
      };

  String get loginButton => switch (language) {
        AppLanguage.tr => 'Giriş Yap',
        AppLanguage.en => 'Sign In',
        AppLanguage.de => 'Anmelden',
      };

  String get loginSuccessMsg => switch (language) {
        AppLanguage.tr => 'Giriş başarılı! Bereketli günler dileriz.',
        AppLanguage.en => 'Login successful! Have a fruitful day.',
        AppLanguage.de => 'Anmeldung erfolgreich!',
      };

  String get loginErrorMsg => switch (language) {
        AppLanguage.tr =>
          'Geçersiz kullanıcı adı veya şifre.\n(Demo: Admin / 123456)',
        AppLanguage.en =>
          'Invalid username or password.\n(Demo: Admin / 123456)',
        AppLanguage.de =>
          'Ungültiger Benutzername oder Passwort.\n(Demo: Admin / 123456)',
      };

  String get splashSubtitle => switch (language) {
        AppLanguage.tr => 'Akıllı Tarım ve Hayvancılık Platformu',
        AppLanguage.en => 'Smart Agriculture & Livestock Platform',
        AppLanguage.de => 'Smarte Agrar- und Viehwirtschaftsplattform',
      };

  String get splashLoading => switch (language) {
        AppLanguage.tr => 'Toprağın bereketi hazırlanıyor...',
        AppLanguage.en => 'Preparing the bounty of the land...',
        AppLanguage.de => 'Die Fruchtbarkeit des Bodens wird vorbereitet...',
      };

  String get skipBtn => switch (language) {
        AppLanguage.tr => 'Geç',
        AppLanguage.en => 'Skip',
        AppLanguage.de => 'Überspringen',
      };

  // Product Detail
  String get productDetailOwnListingNotice => switch (language) {
        AppLanguage.tr => 'Bu ürün sizin Bereket Ovası satış ilanınızdır.',
        AppLanguage.en => 'This product is your active Bereket Ovası listing.',
        AppLanguage.de => 'Dieses Produkt ist Ihre aktive Bereket Ovası-Anzeige.',
      };

  String get productDetailUnitPrice => switch (language) {
        AppLanguage.tr => 'Birim Fiyat',
        AppLanguage.en => 'Unit Price',
        AppLanguage.de => 'Einzelpreis',
      };

  String get productDetailAvailableQty => switch (language) {
        AppLanguage.tr => 'Mevcut Miktar',
        AppLanguage.en => 'Available Quantity',
        AppLanguage.de => 'Verfügbare Menge',
      };

  String get productDetailLocationSellerTitle => switch (language) {
        AppLanguage.tr => 'Konum ve Satıcı Bilgileri',
        AppLanguage.en => 'Location & Seller Details',
        AppLanguage.de => 'Standort & Verkäuferdetails',
      };

  String get productDetailLocationTitle => switch (language) {
        AppLanguage.tr => 'Ürün Konumu',
        AppLanguage.en => 'Product Location',
        AppLanguage.de => 'Produktstandort',
      };

  String get productDetailProducerCodeTitle => switch (language) {
        AppLanguage.tr => 'Üretici Kodu',
        AppLanguage.en => 'Producer Code',
        AppLanguage.de => 'Erzeugercode',
      };

  String get youParenthesis => switch (language) {
        AppLanguage.tr => 'Siz',
        AppLanguage.en => 'You',
        AppLanguage.de => 'Sie',
      };

  String get productDetailNoDesc => switch (language) {
        AppLanguage.tr => 'Üretici tarafından ek bir açıklama girilmedi.',
        AppLanguage.en => 'No additional description provided by the producer.',
        AppLanguage.de => 'Keine zusätzliche Beschreibung vom Erzeuger angegeben.',
      };

  // Product Image Picker
  String get addProductPhotoTitle => switch (language) {
        AppLanguage.tr => 'Ürün Fotoğrafı Ekle',
        AppLanguage.en => 'Add Product Photo',
        AppLanguage.de => 'Produktfoto hinzufügen',
      };

  String get cameraCaptureOption => switch (language) {
        AppLanguage.tr => 'Kamera ile Çek',
        AppLanguage.en => 'Take Photo',
        AppLanguage.de => 'Foto aufnehmen',
      };

  String get gallerySelectOption => switch (language) {
        AppLanguage.tr => 'Galeriden Seç',
        AppLanguage.en => 'Choose from Gallery',
        AppLanguage.de => 'Aus Galerie wählen',
      };

  String get uploadProductPhotoBtn => switch (language) {
        AppLanguage.tr => 'Ürün Fotoğrafı Yükle',
        AppLanguage.en => 'Upload Product Photo',
        AppLanguage.de => 'Produktfoto hochladen',
      };

  String get uploadPhotoSubtitle => switch (language) {
        AppLanguage.tr => 'Kamera veya galeriden seçin (isteğe bağlı)',
        AppLanguage.en => 'Choose from camera or gallery (optional)',
        AppLanguage.de => 'Aus Kamera oder Galerie wählen (optional)',
      };

  // Animal Vaccine Notice
  String get vaccineScheduleNotice => switch (language) {
        AppLanguage.tr =>
          'Aşı takvimleri hayvan türüne, mevsime ve ilçe tarım müdürlüğü talimatlarına göre veteriner hekim tarafından belirlenmelidir.',
        AppLanguage.en =>
          'Vaccination schedules should be determined by a veterinarian based on species, season, and agricultural directorate guidelines.',
        AppLanguage.de =>
          'Impfpläne sollten von einem Tierarzt basierend auf Tierart, Saison und behördlichen Richtlinien festgelegt werden.',
      };

  // Profile Modules & Tiles
  String get quickModuleAccessTitle => switch (language) {
        AppLanguage.tr => 'Hızlı Modül Erişimi',
        AppLanguage.en => 'Quick Module Access',
        AppLanguage.de => 'Schnellzugriff auf Module',
      };

  String get farmHerdPanelTitle => switch (language) {
        AppLanguage.tr => 'Çiftlik & Sürü Paneli',
        AppLanguage.en => 'Farm & Herd Dashboard',
        AppLanguage.de => 'Hof- & Herdenverwaltung',
      };

  String get farmHerdPanelDesc => switch (language) {
        AppLanguage.tr => 'Hayvan aşı takibi, gebelik ve sera sensör simülasyonu',
        AppLanguage.en =>
          'Animal vaccine tracking, pregnancy, and greenhouse sensor simulation',
        AppLanguage.de =>
          'Impfverfolgung, Trächtigkeit und Gewächshaus-Sensorsimulation',
      };

  String get postNewCropDesc => switch (language) {
        AppLanguage.tr => 'Ürettiğiniz buğday, elma, süt vb. pazara listeleyin',
        AppLanguage.en =>
          'List your harvested wheat, apples, milk, etc. on the market',
        AppLanguage.de =>
          'Listen Sie Weizen, Äpfel, Milch usw. auf dem Markt',
      };

  String get offerDemandManagementTitle => switch (language) {
        AppLanguage.tr => 'Teklif & Talep Yönetimi',
        AppLanguage.en => 'Offer & Request Management',
        AppLanguage.de => 'Angebots- & Anfragenverwaltung',
      };

  String get offerDemandManagementDesc => switch (language) {
        AppLanguage.tr => 'Gelen veya alıcı olarak ilettiğiniz ürün teklifleri',
        AppLanguage.en => 'Incoming offers or offers sent as a buyer',
        AppLanguage.de => 'Eingehende oder als Käufer gesendete Angebote',
      };

  String get marketplaceShowcaseTitle => switch (language) {
        AppLanguage.tr => 'Pazar Yeri Vitrini',
        AppLanguage.en => 'Marketplace Showcase',
        AppLanguage.de => 'Marktplatz-Schaufenster',
      };

  String get marketDirectDesc => switch (language) {
        AppLanguage.tr => 'Tüm üreticilerin doğrudan satış listeleri',
        AppLanguage.en => 'Direct sales listings from all local producers',
        AppLanguage.de => 'Direktverkaufsangebote aller lokalen Erzeuger',
      };

  String get agriServiceGuideTitle => switch (language) {
        AppLanguage.tr => 'Tarımsal Hizmet Rehberi',
        AppLanguage.en => 'Agricultural Services Directory',
        AppLanguage.de => 'Agrardienst-Verzeichnis',
      };

  String get agriServiceGuideDesc => switch (language) {
        AppLanguage.tr => 'Bölgesel veteriner, traktör ve nakliye sağlayıcıları',
        AppLanguage.en => 'Regional veterinary, tractor, and logistics providers',
        AppLanguage.de => 'Regionale Tierarzt-, Traktor- und Logistikanbieter',
      };

  String roleRequiredTitle(String roleText) => switch (language) {
        AppLanguage.tr => '$roleText Modu Gerekli',
        AppLanguage.en => '$roleText Mode Required',
        AppLanguage.de => '$roleText-Modus erforderlich',
      };

  String roleSwitchPrompt(String feature, String roleText) => switch (language) {
        AppLanguage.tr =>
          '"$feature" özelliğine erişebilmek için aktif modunuzun $roleText olması gerekmektedir. Şimdi bu moda geçiş yapmak ister misiniz?',
        AppLanguage.en =>
          'To access "$feature", your active mode must be $roleText. Would you like to switch to this mode now?',
        AppLanguage.de =>
          'Um auf "$feature" zuzugreifen, muss Ihr aktiver Modus $roleText sein. Möchten Sie jetzt in diesen Modus wechseln?',
      };

  String switchToRoleBtn(String roleText) => switch (language) {
        AppLanguage.tr => '$roleText Moduna Geç',
        AppLanguage.en => 'Switch to $roleText',
        AppLanguage.de => 'Zu $roleText wechseln',
      };

  String callFailedWithPhone(String phone) => switch (language) {
        AppLanguage.tr =>
          'Arama başlatılamadı ($phone). Cihazınız telefon aramasını desteklemiyor olabilir.',
        AppLanguage.en =>
          'Could not initiate call ($phone). Your device may not support phone calls.',
        AppLanguage.de =>
          'Anruf konnte nicht gestartet werden ($phone). Ihr Gerät unterstützt möglicherweise keine Anrufe.',
      };

  String get demoCredentialsHint => switch (language) {
        AppLanguage.tr => 'Kullanıcı: Admin  •  Şifre: 123456',
        AppLanguage.en => 'User: Admin  •  Password: 123456',
        AppLanguage.de => 'Benutzer: Admin  •  Passwort: 123456',
      };

  String get splashEcosystemTag => switch (language) {
        AppLanguage.tr => 'Tarladan Sofraya Yerel ve Akıllı Ekosistem',
        AppLanguage.en => 'From Field to Table: Local & Smart Ecosystem',
        AppLanguage.de => 'Vom Feld auf den Tisch: Lokales & smartes Ökosystem',
      };

  String get pageNotFound => switch (language) {
        AppLanguage.tr => 'Sayfa bulunamadı',
        AppLanguage.en => 'Page Not Found',
        AppLanguage.de => 'Seite nicht gefunden',
      };

  String get howToUseTitle => switch (language) {
        AppLanguage.tr => 'Nasıl kullanmak istersin?',
        AppLanguage.en => 'How would you like to use the app?',
        AppLanguage.de => 'Wie möchten Sie die App nutzen?',
      };

  String get producerModeDesc => switch (language) {
        AppLanguage.tr => 'İlan ve çiftlik yönetimi görünümü',
        AppLanguage.en => 'Listing and farm management view',
        AppLanguage.de => 'Anzeigen- und Hofverwaltungsansicht',
      };

  String get consumerModeDesc => switch (language) {
        AppLanguage.tr => 'Pazar keşfi ve teklif görünümü',
        AppLanguage.en => 'Marketplace discovery and offer view',
        AppLanguage.de => 'Marktplatz- und Angebotsansicht',
      };

  String get modePreviewNotice => switch (language) {
        AppLanguage.tr =>
          'Bu bir demo tercihidir; gerçek kullanıcı hesabı veya kimlik doğrulaması değildir.',
        AppLanguage.en =>
          'This is a demo preference; it is not a real user account or authentication.',
        AppLanguage.de =>
          'Dies ist eine Demo-Einstellung; kein reales Benutzerkonto oder Authentifizierung.',
      };

  String get goToMarketBtn => switch (language) {
        AppLanguage.tr => 'Pazara Git',
        AppLanguage.en => 'Go to Market',
        AppLanguage.de => 'Zum Markt',
      };

  String get backToHomeBtn => switch (language) {
        AppLanguage.tr => 'Ana ekrana dön',
        AppLanguage.en => 'Back to Home',
        AppLanguage.de => 'Zurück zur Startseite',
      };

  String comingSoonTitle(String owner) => switch (language) {
        AppLanguage.tr => '$owner tarafından geliştirilecek özellik ekranı',
        AppLanguage.en => 'Feature screen under development by $owner',
        AppLanguage.de => 'Funktionsbildschirm in Entwicklung von $owner',
      };

  String get comingSoonDesc => switch (language) {
        AppLanguage.tr =>
          'Ortak main temeli hazır, bu bölüm geçici olarak gösteriliyor.',
        AppLanguage.en =>
          'Shared core architecture is ready; this section is shown temporarily.',
        AppLanguage.de =>
          'Gemeinsame Basis ist bereit; dieser Bereich wird temporär angezeigt.',
      };

  String get langTrSubtitle => switch (language) {
        AppLanguage.tr => 'Varsayılan Sistem Dili (TR)',
        AppLanguage.en => 'Default System Language (TR)',
        AppLanguage.de => 'Standard-Systemsprache (TR)',
      };

  String get langEnSubtitle => switch (language) {
        AppLanguage.tr => 'İngilizce Dil Desteği (EN)',
        AppLanguage.en => 'English Language (EN)',
        AppLanguage.de => 'Englische Sprache (EN)',
      };

  String get langDeSubtitle => switch (language) {
        AppLanguage.tr => 'Almanca Dil Desteği (DE)',
        AppLanguage.en => 'German Language (DE)',
        AppLanguage.de => 'Deutsche Sprache (DE)',
      };

  String translateValidationError(String? error) {
    if (error == null || error.isEmpty) return '';
    final lower = error.toLowerCase();
    if (lower.contains('küpe numarası boş') ||
        lower.contains('ear tag cannot be empty')) {
      return switch (language) {
        AppLanguage.tr => 'Küpe numarası boş bırakılamaz.',
        AppLanguage.en => 'Ear tag cannot be empty.',
        AppLanguage.de => 'Ohrmarkennummer darf nicht leer sein.',
      };
    }
    if (lower.contains('zaten mevcut') || lower.contains('already exists')) {
      return switch (language) {
        AppLanguage.tr => error,
        AppLanguage.en => 'An animal with this ear tag already exists.',
        AppLanguage.de => 'Ein Tier mit dieser Ohrmarke existiert bereits.',
      };
    }
    if (lower.contains('hayvan türünü seçiniz') ||
        lower.contains('select animal species')) {
      return switch (language) {
        AppLanguage.tr => 'Lütfen hayvan türünü seçiniz.',
        AppLanguage.en => 'Please select the animal species.',
        AppLanguage.de => 'Bitte wählen Sie die Tierart aus.',
      };
    }
    if (lower.contains('geçersiz tarih') ||
        lower.contains('invalid date format')) {
      return switch (language) {
        AppLanguage.tr => 'Geçersiz tarih biçimi! Tarih YYYY-AA-GG olmalıdır.',
        AppLanguage.en => 'Invalid date format! Date must be YYYY-MM-DD.',
        AppLanguage.de => 'Ungültiges Datumsformat! Datum muss JJJJ-MM-TT sein.',
      };
    }
    if (lower.contains('gelecekteki bir tarih') ||
        lower.contains('future date')) {
      return switch (language) {
        AppLanguage.tr => 'Son aşı tarihi gelecekteki bir tarih olamaz.',
        AppLanguage.en => 'Last vaccination date cannot be in the future.',
        AppLanguage.de => 'Das Impfdatum darf nicht in der Zukunft liegen.',
      };
    }
    if (lower.contains('ürün bulunamadı') ||
        lower.contains('product not found')) {
      return switch (language) {
        AppLanguage.tr =>
          'Teklif verilmek istenen ürün bulunamadı veya ilandan kaldırılmış.',
        AppLanguage.en =>
          'The product could not be found or has been removed.',
        AppLanguage.de => 'Das Produkt wurde nicht gefunden oder entfernt.',
      };
    }
    if (lower.contains('lütfen adınızı') ||
        lower.contains('enter your name')) {
      return switch (language) {
        AppLanguage.tr => 'Lütfen adınızı veya ticari unvanınızı giriniz.',
        AppLanguage.en => 'Please enter your name or business title.',
        AppLanguage.de =>
          'Bitte geben Sie Ihren Namen oder Firmennamen ein.',
      };
    }
    if (lower.contains('talep miktarı') || lower.contains('quantity')) {
      return switch (language) {
        AppLanguage.tr =>
          'Lütfen geçerli ve 0\'dan büyük bir talep miktarı giriniz.',
        AppLanguage.en =>
          'Please enter a valid request quantity greater than 0.',
        AppLanguage.de =>
          'Bitte geben Sie eine gültige Menge größer als 0 ein.',
      };
    }
    if (lower.contains('stoktan') || lower.contains('stock')) {
      return switch (language) {
        AppLanguage.tr => error,
        AppLanguage.en => 'Requested quantity exceeds available stock.',
        AppLanguage.de =>
          'Die angeforderte Menge übersteigt den verfügbaren Bestand.',
      };
    }
    return error;
  }
}
