---
name: ayberk-marketplace
description: Workflows, patterns and best practices for developing the Marketplace feature, product details, image persistence, and filter controllers in the Akıllı Tarım Platformu.
---

# 🌾 Ayberk Marketplace Skill

Bu skill, Akıllı Tarım Platformu'nda pazar yeri modülünün (`lib/features/marketplace/**`) geliştirilmesinde izlenecek adımları ve kuralları içerir.

## Mimari Kurallar
1. **Dosya Sınırı:** Her dosya kesinlikle max 200–300 satır arasında kalır.
2. **Katman Ayrımı:**
   - `domain/`: Filtre ve arama modelleri.
   - `presentation/controllers/`: `ChangeNotifier` veya `ValueNotifier` tabanlı durum yönetimi.
   - `presentation/widgets/`: Küçük, yeniden kullanılabilir ve test edilebilir alt bileşenler.
   - `presentation/screens/`: Sadece widget orkestrasyonu yapan ekranlar.
3. **Depolama Sözleşmesi:**
   - Yeni ürünler her zaman `sellerId = 'demo_producer_001'` sabiti ile kaydedilir.
   - Fotoğraflar `image_picker` ile alınır, `path_provider` ile uygulama kalıcı dizinine kopyalanır.
   - Arama ve filtreleme kategori ve şehir bazında kombine çalışır.
