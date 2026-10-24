# 🐄 AKILLI TARIM & HAYVANCILIK PLATFORMU
## EMİRHAN — Tek Branch, Tek Görev Planı (V4)

**Ekip:** Emirhan + Ayberk · **Tek repo:** ortak Flutter mobil uygulaması  
**Senin tek geliştirme branch'in:** `feature/emirhan`  
**Ayberk'in tek geliştirme branch'i:** `feature/ayberk`  
**Hedef:** İki kişi arasında yaklaşık **%50/%50 efor** ve en sonda birleşen **gerçekten çalışan** bir mobil MVP.

> **KURAL: SADECE İKİ FEATURE BRANCH.** Sen `feature/emirhan` dışında bir branch açma. Ayberk `feature/ayberk` dışında feature branch açmayacak. Yeni bir Flutter uygulaması veya ortak MD gerekmiyor; bu belge tüm gerekli ortak kuralları da içeriyor.

---

## 1. Dengeli iş paylaşımı

| Senin işin | Tahmini efor |
|---|---:|
| E1 · Hayvan kayıtları, doğrulama, kalıcılık | 16 |
| E2 · Sera kartları ve sanal sensör simülasyonu | 9 |
| E3 · Hizmet rehberi, arama, filtre, telefon | 10 |
| E4 · Ürün teklif/talep oluşturma ve gelen teklifler | 13 |
| E5 · Profil ekranı ve mevcut rol yönetimine bağlanma | 7 |
| E6 · Kendi modüllerinin testleri, mobil UX ve tasarım cilası | 5 |
| **EMİRHAN TOPLAM** | **60** |

**Ayberk de 60 göreli efor puanı:** Flutter kurulum (6), ortak modeller/Hive (11), router/rol controller (8), tema (10), pazar yeri (19), entegrasyon (6). Efor puanları saat değildir; ağırlıklar tahminidir.

### Senin dosyaların

- `lib/features/farm_management/**`
- `lib/features/services/**`
- `lib/features/offers/**`
- `lib/features/profile/**`
- Bu özelliklere ait `test/**` dosyaları.

**Ayberk'in sahip olduğu, doğrudan değiştirmeyeceğin alanlar:** `lib/main.dart`, `lib/app/**`, `lib/core/**`, `lib/features/marketplace/**`, `assets/mock_farms.json`, `pubspec.yaml`, merkezi ortak görsel bileşenleri. Gerekli model/tema/bağımlılık/rota değişikliğini Ayberk'e bildir; o uygulasın.

**Tek tema:** Ayberk merkezi `ThemeData` ve ortak widgetları oluşturur. Sen her ekranı **kendi modülünde** bu tasarım sistemine uygun, aynı premium özenle geliştirirsin. İkinci `RoleController`, ikinci `Product` modeli, ikinci Hive başlatma servisi veya bağımsız ikinci uygulama **yok**.

---

## 2. GitHub Desktop: sadece `feature/emirhan`

1. GitHub davetini kabul et. Ayberk ile **aynı repository'yi** GitHub Desktop'ta `File > Clone repository` ile kendi bilgisayarına al.
2. Ayberk `feature/ayberk` dalında ortak Flutter temelini bitirip **`main`'e PR ile merge ettikten sonra** başlayacaksın. Böylece model/Hive/tema sözleşmeleri ilk günden hazır olur.
3. GitHub Desktop: `Current Branch > main` → `Fetch origin` → gerekiyorsa `Pull origin` → `New Branch` → **`feature/emirhan`** → `Create Branch` → `Publish branch`.
4. Bu **aynı branch'te** hayvan, sera, hizmet, teklifler ve profil ekranlarını tamamla. Başka feature branch açma.
5. Değişiklikleri `Commit to feature/emirhan` → `Push origin` → `Create Pull Request` ile `main`'e öner. Kod incelemesi ve test ardından merge. Branch'i silmek veya yeniden adlandırmak gerekmiyor; ihtiyaç olursa aynı branch'ten yeni commit/PR devam edebilir.
6. Ayberk'in `main`'e giren değişikliklerini kendi branch'ine `Branch > Update from default branch`/`Choose a branch to merge into...` üzerinden güncelle. Çakışan dosyalarda rastgele çözüm seçme; önce görüş.
7. Antigravity'nin otomatik push, merge, force push veya ortak dosya silmesine izin verme.

---

## 3. İkinizin sabit veri/entegrasyon sözleşmesi

Ayberk bu modelleri **tek kez `lib/core/models/**` içinde** sağlar. Sen bu alan adlarını aynen kullanırsın.

| Model | Zorunlu alanlar | Biçim |
|---|---|---|
| `Product` | `id`, `sellerId`, `title`, `category`, `quantity`, `unit`, `unitPrice`, `city`, `district`, `imagePath`, `sellerPhone`, `description`, `createdAt` | `quantity`, `unitPrice`: `double`; diğerleri `String`; zaman ISO-8601 |
| `Offer` | `id`, `productId`, `buyerName`, `buyerPhone`, `requestedQuantity`, `note`, `status`, `createdAt` | Miktar `double`; durum `pending`, `accepted`, `rejected` |
| `Animal` | `id`, `earTag`, `species`, `lastVaccinationDate`, `pregnancyStatus` | Tarih `YYYY-MM-DD`; durum `pregnant`, `not_pregnant`, `unknown` |
| `Greenhouse` | `id`, `name`, `temperatureC`, `humidityPercent`, `updatedAt` | Ölçümler `double`; zaman ISO-8601 |
| `ServiceProvider` | `id`, `name`, `type`, `city`, `district`, `phone`, `description` | Tür `veterinary`, `tractor`, `harvester`, `logistics` |
| `UserRole` | `producer`, `consumer` | Yerel demo görünüm modu |

**Ortak JSON dosyası `assets/mock_farms.json`** (dosya sahibi Ayberk):

```json
{
  "products": [],
  "offers": [],
  "animals": [],
  "greenhouses": [],
  "serviceProviders": []
}
```

- Hive kutuları: `products`, `offers`, `animals`, `greenhouses`, `serviceProviders`, `settings`.
- Ortak depolama biçimi: `Box<String>` + `jsonEncode(toJson())` / `jsonDecode`, key = `id`.
- Seed yalnızca eksik ID'leri ekler; mevcut kullanıcı kayıtlarını **ezmez**. Ortak seed işlemini tekrar yazma.
- Ortak demo üreticisi `demo_producer_001`; yeni ürün ilanları ile tekliflerin bağlanması `Offer.productId → Product.id → Product.sellerId` üzerinden. Rol değiştirmek başka telefona ileti göndermek değildir.
- `Screen/Widget → Controller/ViewModel → Repository → Hive` sınırını koru. `flutter analyze` / `flutter test` sırasında geçersiz örnek veri ve bozuk kayıtları da düşün.
- Teklif ürün miktarından fazla olamaz; gerçek stok/ödeme rezervasyonu yoktur. Son aşı tarihinden yeni aşı tarihi uydurma. Sera sensörleri **simüle** etiketi taşır. Sahte gerçek telefon numarası ekleme.

### Ayberk'in bağlayacağı rota/public widgetlar

| Rota | Widget | Sorumlu |
|---|---|---|
| `/marketplace` | `MarketplaceScreen` | Ayberk |
| `/product-detail` (+ `productId`) | `ProductDetailScreen` | Ayberk |
| `/add-product` | `AddProductScreen` | Ayberk |
| `/farm` | `FarmDashboardScreen` | **Sen** |
| `/services` | `ServiceProvidersScreen` | **Sen** |
| `/offers` | `OffersScreen` | **Sen** |
| `/offer-form` (+ `productId`) | `OfferFormScreen` | **Sen** |
| `/profile` | `ProfileScreen` | **Sen** |

Sen kendi ekranlarının public export'unu ve gerekli parametreleri sağla; Ayberk `app_router.dart` ile bağlasın. `RoleController`'ı `lib/app/` içinden kullan, kendine başka bir controller kopyalama. Ekranların bağımlılık enjeksiyonunu Ayberk'le aynı yöntemde yap.

---

## 4. Ortak görsel kimlik: gerçek çiftçilik + zarif fantastik dünya

Hayvan, sera, makine, lojistik ve ticaret atmosferi **gerçekçi**, kart/arka plan/kenar bezemeleri **fantastik ve özgün** olacak. Kırsal lüks hissi: mera manzarası, güneş ışığı, sera camları, ince botanik süslemeler, doğal doku, kabartma altın detaylar; ama çocuk oyunu veya savaş arayüzü gibi değil.

| Renk | HEX | İşlev |
|---|---|---|
| Deep Forest | `#214A3D` | Ana CTA |
| Harvest Gold | `#B88422` | Hasat/vurgu |
| Field Olive | `#566D36` | Üretim/kategori |
| Earth Brown | `#75503B` | Kırsal dekor |
| Cream Canvas | `#F7F1E5` | Açık zemin |
| Milk Surface | `#FFFDF8` | Kart/form |
| Ink | `#1F2721` | Ana metin |
| Alert | `#A34422` | Hata |

- Temayı Ayberk'ten al; kendi ekranlarında ikinci `ThemeData` üretme. `Theme.of(context)` ve ortak component stillerini kullan.
- Metinlerin arka planda kaybolması **kesinlikle kabul edilmez**. Normal metin kontrastı hedefi 4.5:1, büyük metin 3:1. Görsel üzerindeki metni opak panel/uygun gradyan ile koru.
- 360 px ekran, büyük yazı, klavye, uzun Türkçe etiketler, erişilebilirlik, SafeArea ve yaklaşık 48 px dokunma alanı düşün.
- Emek verilmiş görseller kullan; **olmayan asset dosyasına referans verme**. Yüksek kaliteli özgün/izinli görselleri optimize et. Performans ve form işlevlerini gösteriş uğruna bozmadan zenginlik yarat.
- Hayvan panelinde mera/ahır estetiği, serada ışıklı cam/bitki dokuları; hizmette traktör/yol/lojistik hissi; tekliflerde hasat-ticaret motifleri; profilde dingin üretici/tüketici kimliği.
- Durumlar yalnızca renkle anlaşılmamalı; metin + ikonla desteklenmeli. Yükleniyor/boş/hata/kayıt başarılı/telefon kullanılamıyor durumları tasarımlı olsun.

---

## 5. E1: Hayvan yönetimi (`features/farm_management/**`)

**Public ekran:** `FarmDashboardScreen`.

- [ ] **Hayvanlarım** ve **Seralarım** bölümleri; toplam hayvan/sera ve aşı tarihi kayıt sayısı özetleri.
- [ ] Hayvan kartında `earTag`, `species`, `lastVaccinationDate`, `pregnancyStatus` alanları; detay ekranı veya bottom sheet.
- [ ] **Hayvan Ekle** formu; boş küpe no, geçersiz tarih, aynı küpe no tekrarı engellensin. `unknown` gebelik durumunu destekle.
- [ ] Kayıtları Hive `animals` kutusuna sakla; uygulama yeniden açılınca korunsun.
- [ ] Son aşı tarihini göster; **bir sonraki aşı için tıbbi takvim uydurma**.
- [ ] Hayvan kayıtları için repository/form birim testleri oluştur.

## 6. E2: Sera izleme / sanal sensör

- [ ] En az iki sera kartı: `name`, `temperatureC`, `humidityPercent`, `updatedAt`.
- [ ] `Timer.periodic` ile yaklaşık **5 saniyede bir** sıcaklık ±0.5 °C, nem ±2 puan dalgalanması. Nemi `0–100` aralığına sabitle.
- [ ] Her ekranda görünür **“Simüle sensör verisi”** ibaresi. Gerçek IoT/MQTT/backend ekleme.
- [ ] `dispose()` içerisinde timer kapat; widget yokken `setState` çağırma. Gereksiz her 5 sn Hive yazımına gerek yok; ana sera bilgisi kalıcı kalır.
- [ ] Timer yaşam döngüsü ve değer aralığı testlerini oluştur; hafif animasyonlar kullan.

## 7. E3: Hizmet / destek rehberi (`features/services/**`)

**Public ekran:** `ServiceProvidersScreen`.

- [ ] **Veteriner**, **Traktör Kiralama**, **Biçerdöver Kiralama**, **Lojistik** kategorilerini göster.
- [ ] Kart: işletme adı, kategori, şehir/ilçe, açıklama, telefon.
- [ ] Kategori + şehir filtreleri **beraber** çalışsın; sağlayıcı adına göre arama ekle.
- [ ] `url_launcher` ile `tel:` arama niyetini aç; telefon boşsa buton pasif. Açılmıyorsa kullanıcıya hata bilgisi.
- [ ] Kaynak ortak seed'den yüklenmiş Hive `serviceProviders` verisidir; kendine ayrı rehber JSON'u açma.
- [ ] Boş filtre sonucu, sıfırla ve bağlantı hatası durumlarını açık göster; test et.

## 8. E4: Teklif / talep modülü (`features/offers/**`)

**Public ekranlar:** `OffersScreen`, `OfferFormScreen(productId: ...)`.

- [ ] Tüketici modunda Ayberk'in ilan detayından `/offer-form` ekranına ürün ID'siyle geçiş desteklenir.
- [ ] İstenilen miktar, alıcı adı, telefon, isteğe bağlı not; miktar >0 ve ilandaki toplamı aşamaz.
- [ ] Teklif `Offer(status: 'pending')` olarak Hive `offers` kutusuna kalıcı yazılır.
- [ ] Üretici modunda gelen teklifler yalnızca `sellerId=demo_producer_001` ilanları için listelenir. Kullanıcı rol geçişinde kendi demo verisini görür.
- [ ] İsteğe bağlı `accepted`/`rejected` yerel durum değişikliği. Bu gerçek ödeme/sipariş tamamlama değildir.
- [ ] Boş teklif, geçersiz ürün, silinmiş ilan ve miktar doğrulama durumlarını ele al.
- [ ] Teklif oluşturma, filtreleme/ilişkilendirme ve yeniden başlatma testleri yaz.

## 9. E5: Profil ve rol arayüzü (`features/profile/**`)

**Public ekran:** `ProfileScreen`.

- [ ] **Üretici / Tüketici** mod değiştirici, kısa rol açıklamaları ve ilgili ekranlara yönlendirme.
- [ ] Ayberk'in **tek** `RoleController`'ına bağlan; seçilen rol `settings` Hive kutusunda korunur; yeni rol servisi yazma.
- [ ] Üreticiye ilan ekleme, gelen teklifler, çiftlik paneli; tüketiciye pazar, teklif verme, hizmet rehberi gibi uygun eylemler göster.
- [ ] Geçersiz rolün erişmemesi gereken CTA, çökmek yerine anlaşılır açıklama verir.
- [ ] Rol değişimi widget testini ve yeniden başlatma kalıcılık testini yaz.

## 10. E6: Kalite ve kabul testleri

- [ ] Kendi modüllerinde `dart format`, `flutter analyze`, `flutter test` başarılı.
- [ ] Her sayfada gerçek veriyle yükleniyor/boş/hata/başarı görünümleri hazır.
- [ ] Telefon yok, hayvan kaydı yok, sensör simülasyonu kapandı, teklif miktarı geçersiz gibi hata durumları çökmüyor.
- [ ] 360 px ve büyük ekranlarda taşma/kontrast kusurları giderildi.
- [ ] Ayberk'e public ekran adları, constructor imzaları, route parametreleri, test sonucu ve PR açıklamasını ilet.

### Ortak demo kabul senaryosu

1. Offline çalıştır; örnek ürünler/hizmetler listelenir.
2. Üretici modunda 500 kg elma ilanı eklenir (Ayberk).
3. Tüketici modunda ürün bulunur ve **200 kg teklif** gönderilir (Emirhan).
4. Üretici moduna dönülür, `pending` teklif görülür.
5. Hayvan eklenir; aynı küpe no reddedilir, sera değeri simülasyon etiketiyle değişir.
6. Hizmetler filtrelenir; telefon yoksa çağrı butonu kapalıdır.
7. Uygulama yeniden açılır: ilan, teklif, hayvan ve son rol kaybolmaz.

### Gerçekten canlıya alma gerçeği

Bu MVP **tek cihazda yerel veri** kullanır; farklı telefonlar arasında otomatik eşleşme **yoktur**. Canlı ticaret için sonradan kimlik doğrulama, backend, cihazlar arası senkronizasyon, güvenli medya depolama, izinler, veri gizliliği/KVKK ve sunucu doğrulamaları gerekecek. Simülasyonu gerçek servis diye göstermeyin.

---

## 11. Antigravity'ye tek başlangıç komutu (kopyala)

> `EMIRHAN_GOREV_PLANI.md` dosyasını baştan sona oku. **Sadece `feature/emirhan` branch'inde** çalış ve ek branch oluşturma. Ayberk'in ortak altyapısı `main` içinde mevcut olmalı; aynı Flutter projesini kullan. Görevlerin: hayvan kayıtları, sera simülasyonu, hizmet rehberi, teklif/talep sistemi ve profil UI. `lib/app`, `lib/core`, `lib/main.dart`, `pubspec.yaml`, `assets/mock_farms.json` ve `marketplace` Ayberk'in alanı, dokunma; ihtiyaç bildir. Aynı modelleri, Hive kutularını, `RoleController`'ı ve merkezi temayı kullan. Her ekranı gerçekçi çiftlik-hayvancılık-ticaret atmosferli, hafif fantastik, bol bezemeli ama yüksek kontrastlı ve erişilebilir yap; olmayan asset dosyasına referans verme. SOLID, DRY, KISS, YAGNI, SRP ve feature-first yaklaşımını uygula; gerektiğinde dosyaları 200–300 satır civarında anlamlı şekilde böl. `dart format`, `flutter analyze`, `flutter test` ile doğrula, başarısızlığı gizleme. Git push/merge/force push'u otomatik yapma. Backend veya gerçek IoT varmış gibi davranma. Teslimde public ekranları, dosya değişimlerini ve test sonuçlarını raporla.
