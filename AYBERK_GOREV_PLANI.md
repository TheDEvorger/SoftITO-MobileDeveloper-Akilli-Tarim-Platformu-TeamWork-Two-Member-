# 🌾 AKILLI TARIM & HAYVANCILIK PLATFORMU
## AYBERK — Tek Branch, Tek Görev Planı (V4)

**Ekip:** Ayberk + Emirhan · **Tek repo:** ortak Flutter mobil uygulaması  
**Senin tek geliştirme branch'in:** `feature/ayberk`  
**Emirhan'ın tek geliştirme branch'i:** `feature/emirhan`  
**Ortak hedef:** İki kişinin yaklaşık **%50/%50 eforla** geliştirdiği, test edilebilir, tek cihazda çalışan MVP; ileride gerçek backend eklemeye elverişli mimari.

> **KURAL: SADECE İKİ FEATURE BRANCH.** `feature/foundation`, `feature/marketplace`, `feature/integration` veya başka ek branch **AÇMA**. `main` sadece onaylanmış kod. Ortak kurallar bu ve Emirhan'ın MD'sinde yer alır; üçüncü ortak MD yok.

---

## 1. Dengeli iş paylaşımı

| Senin işin | Tahmini efor |
|---|---:|
| A1 · Flutter proje temeli ve repo düzeni | 6 |
| A2 · Ortak veri modelleri, Hive, JSON seed ve kalıcılık | 11 |
| A3 · Navigasyon, uygulama kabuğu, ortak rol durumu | 8 |
| A4 · Ortak yüksek kaliteli görsel tasarım sistemi | 10 |
| A5 · Pazar yeri, ürün detayı, ilan ekleme, filtre, fotoğraf | 19 |
| A6 · Nihai entegrasyon, uçtan uca test ve yayın hazırlığı değerlendirmesi | 6 |
| **AYBERK TOPLAM** | **60** |

**Emirhan toplamı da 60:** Hayvan kayıtları (16), sera (9), hizmet rehberi (10), teklifler (13), profil UI (7), test ve UX (5). Puanlar kesin saat değil; zorluk ve risk için yaklaşık başlangıç tahmini. İş büyürse birlikte yeniden dengeleyin.

### Dosya sahipliği

| Yalnızca senin düzenleyebileceğin yollar | Emirhan'ın sahip olduğu, dokunmayacağın yollar |
|---|---|
| `lib/main.dart`, `lib/app/**` | `lib/features/farm_management/**` |
| `lib/core/**` | `lib/features/services/**` |
| `lib/features/marketplace/**` | `lib/features/offers/**` |
| `pubspec.yaml`, `assets/mock_farms.json`, ortak asset manifesti | `lib/features/profile/**` |
| Ortak navigasyon/entegrasyon testleri | Bu modüllerin birim/widget testleri |

Emirhan ihtiyaç duyduğu model, route, tema veya bağımlılık değişikliğini sana bildirir. Karşı tarafın dosyasını habersiz değiştirmeyin. UI görsellerini her modül sahibi hazırlasın; **sen bütün ekranların süsleme yükünü üstlenmiyorsun**.

---

## 2. İki branch ile GitHub Desktop akışı (ek branch yok)

1. Sen GitHub'da **tek repository** kur; Emirhan'ı `Settings > Collaborators > Add people` ile davet et. İkiniz **aynı repository'yi ayrı bilgisayarlara** `File > Clone repository` ile alın.
2. Sen `Current Branch > main > New Branch` ile **`feature/ayberk`** dalını açıp `Publish branch` yap.
3. **İlk etapta sadece ortak iskelet, modeller, Hive/seed, tema, `RoleController`, geçici rota/ekranlar** üret. `flutter analyze` ve `flutter test` çalıştır. `Commit to feature/ayberk` → `Push origin` → **Pull Request: `feature/ayberk` → `main`** → kontrol → merge. **Branch'i silme.**
4. Bu ortak temel `main`'e girince Emirhan `main` üzerinde `Fetch origin` / `Pull origin` yaparak **`feature/emirhan`** dalını açsın. İki ayrı Flutter projesi oluşturmayın.
5. Sen aynı **`feature/ayberk`** dalında kalarak pazar yerini geliştir; gerekirse `Branch > Update from default branch` / `Choose a branch to merge into...` ile güncel `main` değişikliklerini al. Ek dal açma.
6. Her geliştirici kendi değişikliklerini Commit → Push origin → Pull Request ile `main`'e önerir. Önce test, sonra inceleme, sonra merge. Aynı branch sonraki yeni commit'lerle tekrar PR açılabilecek şekilde kullanılabilir.
7. Otomatik `force push`, izinsiz merge, başkasının dosyasını silme veya Antigravity'nin kendiliğinden Git işlemi yapması **yok**.

**Aktif branch kontrolü:** Antigravity'ye her görev öncesi `feature/ayberk` dalında olduğunu doğrulat.

---

## 3. Ortak sözleşme: İKİNİZDE AYNI OLACAK

**Model dosyalarının tek sahibi sensin.** Emirhan aynı modellerin kopyasını üretmeyecek.

| Model | Zorunlu alanlar | Veri kuralı |
|---|---|---|
| `Product` | `id`, `sellerId`, `title`, `category`, `quantity`, `unit`, `unitPrice`, `city`, `district`, `imagePath`, `sellerPhone`, `description`, `createdAt` | `quantity`, `unitPrice`: `double`; diğerleri `String`; zaman ISO-8601 |
| `Offer` | `id`, `productId`, `buyerName`, `buyerPhone`, `requestedQuantity`, `note`, `status`, `createdAt` | Miktar `double`; durum `pending`, `accepted`, `rejected` |
| `Animal` | `id`, `earTag`, `species`, `lastVaccinationDate`, `pregnancyStatus` | Tarih `YYYY-MM-DD`; durum `pregnant`, `not_pregnant`, `unknown` |
| `Greenhouse` | `id`, `name`, `temperatureC`, `humidityPercent`, `updatedAt` | Sıcaklık/nem `double`; zaman ISO-8601 |
| `ServiceProvider` | `id`, `name`, `type`, `city`, `district`, `phone`, `description` | Tür `veterinary`, `tractor`, `harvester`, `logistics` |
| `UserRole` | `producer`, `consumer` | Yalnızca yerel demo modu |

**`assets/mock_farms.json` kökü aynen:**

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
- MVP için `Box<String>` ve `jsonEncode(toJson())` / `jsonDecode` kullan; kayıt anahtarı `id`.
- `SeedLoader` yalnızca **eksik ID**'leri yükler; kullanıcı kayıtlarını ezmez, örnekleri çoğaltmaz. Veriyi mevcut kurulu uygulamada test et.
- Ortak demo üreticisi sabiti: `demo_producer_001`; `Product.sellerId` bu ID ile eşleşir. Üreticinin gelen teklifleri `Offer.productId → Product.id → Product.sellerId` üzerinden bulunur.
- Tüm modeller `fromJson` / `toJson` içerir. Sayı, tarih, durum ve boş alan doğrulamalarını test et.
- UI katmanı → controller/viewmodel → repository → Hive erişimi; ekran doğrudan veri depolama kodu çalıştırmasın. Gerçek backend sonraki aşamada repository değişimiyle eklenebilir.
- Fotoğraflar `image_picker` üzerinden seçilir; uygulamanın kalıcı dizinine kopyalanır (`path_provider`). `assets/...` ve yerel dosya yollarını ayrı ele al. Görsel bulunamazsa fallback göster.
- Asgari paketler: `hive`, `hive_flutter`, `image_picker`, `path_provider`, `url_launcher` (sürümleri Flutter ortamına göre doğrula).

### Sabit rota sözleşmesi

| Route | Public widget | Sahibi |
|---|---|---|
| `/marketplace` | `MarketplaceScreen` | Ayberk |
| `/product-detail` (+ `productId`) | `ProductDetailScreen` | Ayberk |
| `/add-product` | `AddProductScreen` | Ayberk |
| `/farm` | `FarmDashboardScreen` | Emirhan |
| `/services` | `ServiceProvidersScreen` | Emirhan |
| `/offers` | `OffersScreen` | Emirhan |
| `/offer-form` (+ `productId`) | `OfferFormScreen` | Emirhan |
| `/profile` | `ProfileScreen` | Emirhan |

Sen `lib/app/app_router.dart` içinde rotaları bağlarsın. Emirhan mevcut `RoleController`'ı kullanır. `RoleController` rolü `settings` kutusuna kaydeder ve UI'ı günceller. İleride ihtiyaç duyulan bağımlılıkları ekranlara constructor/provider üzerinden **tek tutarlı yöntemle** sağla.

---

## 4. Tasarım vizyonu: gerçekçi çiftlik + incelikli fantastik atmosfer

Bu bir **tarım/hayvancılık/ticaret uygulaması**, çizgi film veya RPG arayüzü değil. Gerçek hasat manzaraları, meralar, sera camları, ahır dokuları, tarla yolları, traktörler ve ürün tezgâhları; ince altın ışık, bitkisel bezemeler, zarif çerçeveler ve hafif fantastik atmosferle birleşsin. **Özgün, bol dekorlu, işlevsel ve premium.**

| Tasarım token'ı | HEX | Kullanım |
|---|---|---|
| Deep Forest | `#214A3D` | Ana CTA/nav |
| Harvest Gold | `#B88422` | Altın hasat vurgu |
| Field Olive | `#566D36` | Tarla/kategori |
| Earth Brown | `#75503B` | Toprak/dekor |
| Cream Canvas | `#F7F1E5` | Açık arka plan |
| Milk Surface | `#FFFDF8` | Kart/form zeminleri |
| Ink | `#1F2721` | Ana metin |
| Alert | `#A34422` | Hata/uyarı |

- Metinlerde **WCAG AA: normal 4.5:1, büyük 3:1 kontrast** hedefle. Özellikle altın arka plan üstüne beyaz metni ölçmeden kullanma.
- Arka plan fotoğrafına doğrudan küçük metin yazma: belirgin opak kart veya gradyan/karartma katmanı kullan.
- Sadece renk değil metin + ikonla durum belirt. Buton ve form alanları etkileşimli olduğu anlaşılacak biçimde olsun.
- Görselliğe rağmen **360 px mobil**, SafeArea, klavye açılması, uzun Türkçe metin, büyük font, ekran okuyucu ve yaklaşık 48 px dokunma alanını düşün.
- SVG/PNG/WebP assetleri gerçekten mevcut olmalı; **olmayan dosyayı referans gösterme**. Özgün/izinli fotoğraf ya da çizim kullan, boyutları optimize et; gereksiz animasyon ve filtreler performansı bozmasın.
- Hero: pazar ana sayfasında hasat ve ticaret temalı güçlü arka plan; ürün listelerinde dikkatli fotoğraf-kart dengesi; minimal fantastik çizgiler/ikon motifleri.
- Ana tema `ThemeData` ve ortak widgetlar bir kez kurulsun. Emirhan `Theme.of(context)` ve ortak bileşenleri kullanacak; bağımsız ikinci tema yaratmayacak.

---

## 5. A1–A4: Senin altyapı teslimlerin

- [ ] Tek Flutter uygulaması `flutter run` ile açılıyor; Android odaklı, iOS platform yapısı bozulmamış.
- [ ] `lib/main.dart` başlangıcı, Hive kutuları ve seed yükleme tek merkezden çalışıyor.
- [ ] Ortak modeller, yerel repository altyapısı, error/result örnekleri ve testler hazır.
- [ ] `RoleController` `producer`/`consumer` modu değişimini kalıcı tutuyor; bu **gerçek kimlik doğrulaması değil**.
- [ ] Ortak tasarım sistemi: AppBar, bottom navigation, ürün/özet kartı, buton, form alanı, chip, boş/yükleniyor/hata halleri.
- [ ] Emirhan ekranları henüz eklenmeden rotalar placeholder ile derleniyor; bağlantılar geldiğinde gerçek ekranlar takılacak.
- [ ] Temel `main`'e girdikten sonra Emirhan'ın kendi branch'ini oluşturmasına izin verecek stabil sözleşme paylaşılmış.

## 6. A5: Pazar yeri, ilan ve ürün detayı

**Klasör:** `lib/features/marketplace/**` · Public ekranlar: `MarketplaceScreen`, `ProductDetailScreen`, `AddProductScreen`.

- [ ] Ana sayfada kaliteli hasat hero görseli, öne çıkan ürünler, kategori alanı, son ilanlar; gerçek var olan seed/Hive içeriğinden beslenir.
- [ ] Ürün kartları: fotoğraf, ürün adı, fiyat, miktar/birim, şehir/ilçe; uygun para ve birim biçimlendirmesi.
- [ ] Kategori/şehir filtreleri **birlikte** çalışır. Sonuç yoksa okunaklı boş durum ve sıfırlama seçeneği.
- [ ] Ürün detayı: görsel, satıcı bilgisi, açıklama, miktar, fiyat, konum; iletişim butonu `url_launcher tel:` ile telefon niyetini açar. Telefon yoksa pasif.
- [ ] Üretici modunda ilan ekleme: başlık, kategori, miktar, birim (`kg`, `litre`, `adet` vb.), birim fiyat, il, ilçe, telefon, açıklama, seçilebilir fotoğraf.
- [ ] Zorunlu alan, pozitif miktar/fiyat, il-ilçe uyumu, makul telefon girişi ve görsel erişim hataları doğrulanır. Kalıcı Hive kaydı sonrası vitrin anında güncellenir.
- [ ] Tüketici modunda **Teklif Ver** aksiyonu Emirhan'ın `/offer-form` ekranına `productId` ile gider. Formu tekrar yazma.
- [ ] Yeni ürün `sellerId=demo_producer_001` ile kaydedilir; Emirhan'ın teklif sorgusuyla eşleşir.
- [ ] Demo duyurusu/son haber alanı yalnızca mevcut örnek veriye dayanır; var olmayan veri/özellik sunma.
- [ ] Widget/repository testleri: liste yükleme, ilan doğrulaması, fotoğraf fallback, filtre kombinasyonu ve yeniden açılışta kalıcılık.

## 7. A6: Bütünleme, test, yayın hazırlığı

- [ ] Emirhan'ın `FarmDashboardScreen`, `ServiceProvidersScreen`, `OffersScreen`, `OfferFormScreen`, `ProfileScreen` ekranlarını router'a bağla; bunların kodunu baştan yazma.
- [ ] Profil rol değişimi menüyü anlık güncelliyor; ilan→teklif→gelen teklifler→durum akışı aynı cihazda uçtan uca çalışıyor.
- [ ] Hayvanlar, sera simülasyonu ve hizmet filtreleri entegrasyonda kırılmıyor.
- [ ] Türkçe etiketlerin, contrast, çok küçük ekran ve form klavyesinin tüm modüllerde tutarlı olduğunu birlikte kontrol edin.
- [ ] `dart format .`, `flutter analyze`, `flutter test` ve gerçek cihaz/emülatör üzerinde demo kontrolü çalıştır; başarısızlık varsa düzeltmeden tamamlandı deme.
- [ ] Gerçek yayına geçmek için **daha sonra** backend, kullanıcı hesabı, cihazlar arası senkronizasyon, yetki kontrolü, sunucu tarafı doğrulama, medya depolama, KVKK/gizlilik metinleri, kötüye kullanım önlemleri ve mağaza paketleme gerekir. **Bugünkü MVP yalnızca tek cihazda çalışır**; canlı pazar yeri olduğunu söyleme.

### Ortak zorunlu demo senaryosu

1. Offline başlat: örnek ürünler ve hizmetler görünür.
2. Üretici modunda 500 kg elma ilanı ekle.
3. Tüketici moduna geç, kategori/şehir filtresiyle ürünü bul, 200 kg teklif gönder.
4. Üretici moduna geç, `pending` teklifi gör.
5. Hayvan ekle, aynı küpe no tekrarını reddet; sera değerlerinin **simülasyon** etiketli değiştiğini gör.
6. Hizmet kategorisi/şehir filtrele; telefon yoksa arama pasif.
7. Uygulamayı kapat/aç; ilan, hayvan, teklif ve seçili rol korunur.

---

## 8. Antigravity'ye tek başlangıç komutu (kopyala)

> `AYBERK_GOREV_PLANI.md` belgesini baştan sona oku. **Sadece `feature/ayberk` branch'inde** çalış, ek branch oluşturma. Tek Flutter repository var. Önce modeller, Hive, mock JSON seed, `RoleController`, router ve tema dahil **çalışan ortak temel** üret; test et ve değişen dosyaları raporla. İlk aşama `main`'e Pull Request ile alınmadan Emirhan'ın modüllerini takmaya kalkma. Ardından **aynı branch içinde** marketplace/ilan özelliklerini uygula. Emirhan'ın `features/farm_management`, `services`, `offers`, `profile` klasörlerine dokunma. Tarım/hayvancılık/ticaret atmosferli gerçekçi, zengin bezemeli, hafif fantastik, güçlü kontrastlı premium UI uygula; olmayan asset'i varmış gibi yazma. SOLID, DRY, KISS, YAGNI, SRP ve katman ayrımına uy. Dosyaları tercihen 200–300 satır sınırında mantıklı bileşenlere ayır. `dart format`, `flutter analyze`, `flutter test` ve demo senaryolarını çalıştır; başarısızlığı dürüstçe raporla. Git push/merge/force push işlemlerini otomatik yapma; benden onay bekle. Gerçek backend, ödeme veya canlı IoT ekleme.
