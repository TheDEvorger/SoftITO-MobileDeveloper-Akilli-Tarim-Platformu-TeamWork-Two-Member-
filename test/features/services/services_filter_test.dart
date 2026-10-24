import 'package:akilli_tarim_platformu/core/models/service_provider.dart';
import 'package:akilli_tarim_platformu/features/services/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_json_box_repository.dart';

void main() {
  group('ServicesController Unit Tests', () {
    late ServicesController controller;

    setUp(() {
      final repo = createFakeRepository<ServiceProvider>(
        decoder: ServiceProvider.fromJson,
        encoder: (s) => s.toJson(),
        idOf: (s) => s.id,
        initialData: const [
          ServiceProvider(
            id: 's1',
            name: 'Ova Veteriner Kliniği',
            type: 'veterinary',
            city: 'Konya',
            district: 'Meram',
            phone: '05551112233',
            description: 'Büyükbaş ve küçükbaş uzmanı',
          ),
          ServiceProvider(
            id: 's2',
            name: 'Bereket Traktör Filosu',
            type: 'tractor',
            city: 'Konya',
            district: 'Çumra',
            phone: '05552223344',
            description: 'Günlük traktör kiralama',
          ),
          ServiceProvider(
            id: 's3',
            name: 'Akdeniz Soğuk Hava Lojistik',
            type: 'logistics',
            city: 'Antalya',
            district: 'Kumluca',
            phone: '',
            description: 'Taze meyve sebze nakliyesi',
          ),
        ],
      );
      controller = ServicesController(repository: repo);
    });

    tearDown(() {
      controller.dispose();
    });

    test('Tüm sağlayıcılar ve mevcut şehirler doğru listelenir', () {
      expect(controller.allProviders.length, 3);
      expect(controller.availableCities, containsAll(['Antalya', 'Konya']));
    });

    test('Kategori filtresi yalnızca ilgili sağlayıcıları getirir', () {
      controller.setSelectedType('veterinary');
      expect(controller.filteredProviders.length, 1);
      expect(controller.filteredProviders.first.id, 's1');
    });

    test('Şehir filtresi yalnızca ilgili ili getirir', () {
      controller.setSelectedCity('Antalya');
      expect(controller.filteredProviders.length, 1);
      expect(controller.filteredProviders.first.id, 's3');
    });

    test('Kategori ve Şehir filtreleri birlikte çalışır', () {
      controller.setSelectedCity('Konya');
      controller.setSelectedType('tractor');
      expect(controller.filteredProviders.length, 1);
      expect(controller.filteredProviders.first.id, 's2');

      // Eşleşmeyen kombinasyon boş liste döner
      controller.setSelectedType('logistics');
      expect(controller.filteredProviders, isEmpty);
    });

    test('Arama kelimesiyle filtreleme çalışır', () {
      controller.setSearchQuery('küçükbaş');
      expect(controller.filteredProviders.length, 1);
      expect(controller.filteredProviders.first.id, 's1');
    });

    test('Filtreleri sıfırla tüm filtreleri temizler', () {
      controller.setSelectedType('veterinary');
      controller.setSelectedCity('Konya');
      controller.setSearchQuery('Ova');
      expect(controller.filteredProviders.length, 1);

      controller.resetFilters();
      expect(controller.selectedType, 'all');
      expect(controller.selectedCity, 'all');
      expect(controller.searchQuery, isEmpty);
      expect(controller.filteredProviders.length, 3);
    });
  });
}
