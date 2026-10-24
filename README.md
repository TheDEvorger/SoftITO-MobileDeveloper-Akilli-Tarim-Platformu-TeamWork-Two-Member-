# 🌾 Akıllı Tarım ve Hayvancılık Platformu · MAIN Starter

**Bu klasör**, iki kişilik Flutter **mobil** projesinin `main` dalına konulacak ortak temelidir. **Üçüncü feature branch yok.** İkiniz aynı repo üzerinde çalışacaksınız: `feature/ayberk` ve `feature/emirhan`.

## ⚠️ İlk kurulum, dikkat

Bu arşiv **Flutter kaynak kodu + seed + tema + test** içerir. İçinde `android/` ve `ios/` platform klasörleri **henüz yoktur**; bunları kendi bilgisayarınızda resmi Flutter CLI ile **bir defaya mahsus üretin**. Birbirinden ayrı iki Flutter uygulaması oluşturmayın.

### Windows (Android geliştirme)

1. GitHub Desktop'ta **ortak repository'yi klonla**, `Current Branch: main` olduğuna emin ol.
2. Arşivin **içindeki dosyaları** repository köküne kopyala (ikinci bir iç klasöre değil).
3. Repository kökünü terminalde aç. `flutter doctor` ile Flutter/Android SDK durumunu kontrol et.
4. İlk kurulumda sırayla:

```powershell
flutter create --project-name akilli_tarim_platformu --platforms=android .
flutter pub get
flutter analyze
flutter test
flutter devices
flutter run -d <cihaz_id>
```

`<cihaz_id>` yerine `flutter devices` çıktısındaki bağlı Android telefon veya emülatör kimliğini yaz. Emülatör yoksa Android Studio Device Manager'dan oluştur. **Windows üzerinde iOS uygulaması derlenemez.**

### macOS (Android + iOS)

```bash
flutter doctor
flutter create --project-name akilli_tarim_platformu --platforms=android,ios .
flutter pub get
flutter analyze
flutter test
flutter run
```

iOS derleme için macOS'ta Xcode ve CocoaPods yapılandırması gerekir.

> `flutter create ... .` sadece **bir kez** çalıştırılır ve standart platform klasörlerini oluşturur. Mevcut `lib/`, `assets/`, `test/` dosyalarını silmeyin. Flutter SDK bu çalışma ortamında bulunmadığı için `flutter analyze`, `flutter test` ve gerçek cihaz derlemesi burada **çalıştırılamadı**. Komutları bilgisayarınızda çalıştırıp hataları kontrol edin.

## ✅ Başlangıçta ne çalışıyor?

- Hive kutuları açılır: `products`, `offers`, `animals`, `greenhouses`, `serviceProviders`, `settings`.
- `assets/mock_farms.json` örnek veri yüklenir. Aynı örnek ikinci açılışta çoğalmaz; mevcut kayıt ezilmez.
- Beş ayrı model ve ortak yerel repository sınıfları hazırdır.
- Yeşil/altın/krem tarım teması, gerçek PNG arka planları, duyarlı ana ekran ve ürün önizleme kartları hazırdır.
- Üretici/Tüketici demo modu üst menü ve profil önizlemesinden değiştirilebilir; Hive'da korunur.
- Tamamlanmamış `farm`, `services`, `offers`, `profile`, `offer-form`, `add-product` rotaları **açıklayıcı geçici ekranlara** gider, çökmez. Bunlar **tamamlanmış feature değildir**.
- `/marketplace` rota ekranı Hive ürünlerini **salt-okunur** listeler; Ayberk gerçek pazaryeri ekranını yazınca değiştirir.

## 🌳 2 feature branch, değişmez dosya sahipliği

| Alan | Sahip |
|---|---|
| `lib/main.dart`, `lib/app/**`, `lib/core/**`, `assets/**`, `pubspec.yaml` | Ayberk |
| `lib/features/marketplace/**` (sonradan eklenecek) | Ayberk |
| `lib/features/farm_management/**` (sonradan eklenecek) | Emirhan |
| `lib/features/services/**` (sonradan eklenecek) | Emirhan |
| `lib/features/offers/**` (sonradan eklenecek) | Emirhan |
| `lib/features/profile/**` (sonradan eklenecek) | Emirhan |

**Önerilen sıra:** Starter'ı önce `main` dalına ekleyip Commit → Push yapın. İkiniz de GitHub Desktop'ta kendi feature branch'inize geçip **Branch → Update from default branch** ile yeni `main`'i alın. Artık paralel geliştirebilirsiniz. İki dal daha önce oluşturulmuşsa yeniden oluşturmayın.

## 🔌 Modül entegrasyon sözleşmesi

`lib/app/app_router.dart` **tek rota merkezi** olarak kalmalı. Geçici ekranları oradaki route `switch` dallarında gerçek ekranlarla değiştireceksiniz. Emirhan bu dosyayı değiştirmez; public widget adlarını Ayberk'e bildirir.

| Rota | Gerçek ekranı geliştirecek kişi |
|---|---|
| `/marketplace` → `MarketplaceScreen` | Ayberk |
| `/product-detail` → `ProductDetailScreen(productId: ...)` | Ayberk |
| `/add-product` → `AddProductScreen` | Ayberk |
| `/farm` → `FarmDashboardScreen` | Emirhan |
| `/services` → `ServiceProvidersScreen` | Emirhan |
| `/offers` → `OffersScreen` | Emirhan |
| `/offer-form` → `OfferFormScreen(productId: ...)` | Emirhan |
| `/profile` → `ProfileScreen` | Emirhan |

Ortak katman: `AppScope.of(context).storage` ve `AppScope.of(context).roleController`.

Model alanları ve JSON anahtarları iki görev MD'siyle aynıdır. `demo_producer_001` sabit üreticidir. `Box<String>` + JSON string kullanılır; TypeAdapter ve codegen gerekmez. Gerçek backend/IoT/cihazlar arası paylaşım **yoktur**, uygulama tek cihazda demo amaçlı çalışır.

## Görsel kalite ve üretim sınırı

`assets/images` görselleri **bu başlangıç paketi için üretilmiş illüstrasyonlardır**, gerçek çiftlik fotoğrafı değil. Ekranda okunaklı opak kart/overlay kullanılmıştır. Fotoğraf kalitesindeki lisanslı/özgün gerçek görselleri son ürün aşamasında değiştirebilirsiniz. Destek olmadan gerçek kullanıcılar arası ilan / sipariş gönderimi yapılmış gibi sunmayın.

## GitHub Desktop'ta ilk commit

- `Current Branch: main` seç; eklediğin dosyaları Changes bölümünde kontrol et.
- `Summary` alanına `chore: initialize shared Flutter mobile starter` yaz.
- **Commit to main → Push origin** yap. Bu ortak başlangıç için ayrı PR gerekmez.
- `feature/ayberk` ve `feature/emirhan` mevcut dallarında sırayla `Branch → Update from default branch` yapıp işe başla.

Not: `main` korunuyorsa doğrudan push yerine repository izinlerine uygun olarak mevcut branch üzerinden PR aç; **üçüncü feature branch oluşturma**.
