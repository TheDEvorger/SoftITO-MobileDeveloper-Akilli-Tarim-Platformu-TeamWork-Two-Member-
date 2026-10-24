# 🌾 AKILLI TARIM PLATFORMU — KOD VE MİMARİ STANDARTLARI

Bu dosya, projede çalışan tüm AI agent'lar ve geliştiriciler için bağlayıcıdır.

---

## 1. 📏 İstisnasız Dosya Boyut Sınırı (Max 200–300 Satır)
* **Kural:** Herhangi bir `.dart` veya `.md` dosyası **asla 300 satırı aşamaz**. Tercih edilen üst sınır **200 satırdır**.
* **Uygulama:**
  - Bir ekran (Screen) büyüyorsa; AppBar, FilterBar, Card, List, Dialog, Form bileşenleri ayrı dosyalara (`presentation/widgets/**`) bölünür.
  - İş mantığı ekran içine gömülmez; `controllers/` veya `services/` altına taşınır.
  - Spagetti kod, iç içe 50 satırlık widget ağaçları kesinlikle yasaktır.

---

## 2. 🔀 Branch ve Dosya Sahipliği
* **Aktif Branch:** Yalnızca `feature/ayberk` üzerinde geliştirme yapılır.
* **Ayberk Dosya Yetki Alanı:**
  - `lib/main.dart`, `lib/app/**`
  - `lib/core/**`
  - `lib/features/marketplace/**`
  - `pubspec.yaml`, `assets/**`
* **Dokunulmayacak Emirhan Yolları (YASAK):**
  - `lib/features/farm_management/**`
  - `lib/features/services/**`
  - `lib/features/offers/**`
  - `lib/features/profile/**`

---

## 3. 🏛️ Senior Mimari İlkeleri
* **SOLID:**
  - Single Responsibility (Her sınıf/dosya tek bir amaca hizmet eder).
  - Open/Closed (Generic repository ve model yapısı genişletmeye açık).
  - Dependency Inversion (UI doğrudan Hive çağırmaz; `AppScope` & `AppStorage` repo üzerinden erişir).
* **DRY (Don't Repeat Yourself):** Ortak renkler (`FarmColors`), ortak kartlar (`FarmCard`), görsel bileşenleri (`ProductArtwork`) tekrar yazılmaz, kütüphaneden kullanılır.
* **KISS (Keep It Simple, Silly):** Harici devasa paketler yerine Flutter'ın yerel `ValueNotifier`, `ChangeNotifier` ve `InheritedWidget` mimarisi kullanılır.
* **YAGNI (You Aren't Gonna Need It):** Gerçek backend, ödeme sistemi veya canlı IoT sunucusu eklenmez; mock JSON + Hive depolama esastır.

---

## 4. 🎨 Tasarım & Erişilebilirlik (WCAG AA)
* Koyu orman yeşili (`#214A3D`), Altın hasat (`#B88422`), Keten zemin (`#F7F1E5`), Süt kartları (`#FFFDF8`).
* Tüm metinler yüksek kontrastlı (`#1F2721`) ve Türkçe olacaktır.
* Min 48px dokunma alanları ve 360px ekran genişliğinde responsive uyumluluk.
