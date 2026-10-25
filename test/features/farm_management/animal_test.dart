import 'package:akilli_tarim_platformu/core/models/animal.dart';
import 'package:akilli_tarim_platformu/features/farm_management/farm_management.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_json_box_repository.dart';

void main() {
  group('AnimalController Unit Tests', () {
    late AnimalController controller;

    setUp(() {
      final repo = createFakeRepository<Animal>(
        decoder: Animal.fromJson,
        encoder: (a) => a.toJson(),
        idOf: (a) => a.id,
        initialData: const [
          Animal(
            id: 'a1',
            earTag: 'TR-06-001',
            species: 'İnek',
            lastVaccinationDate: '2026-01-10',
            pregnancyStatus: 'pregnant',
          ),
          Animal(
            id: 'a2',
            earTag: 'TR-06-002',
            species: 'Koyun',
            lastVaccinationDate: '-',
            pregnancyStatus: 'unknown',
          ),
        ],
      );
      controller = AnimalController(repository: repo);
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıç hayvan sayısı ve istatistikleri doğru hesaplanır', () {
      expect(controller.totalCount, 2);
      expect(controller.vaccinatedCount, 1);
      expect(controller.pregnantCount, 1);
    });

    test('Boş küpe numarası ile kayıt reddedilir', () async {
      final result = await controller.addAnimal(
        earTag: '   ',
        species: 'İnek',
        lastVaccinationDate: '',
        pregnancyStatus: 'unknown',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('boş bırakılamaz'));
      expect(controller.totalCount, 2);
    });

    test('Aynı küpe numarası tekrar kaydedilemez', () async {
      final result = await controller.addAnimal(
        earTag: 'tr-06-001', // küçük harf olsa dahi benzersizlik korunur
        species: 'İnek',
        lastVaccinationDate: '',
        pregnancyStatus: 'unknown',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('zaten mevcut'));
      expect(controller.totalCount, 2);
    });

    test('Geçersiz tarih formatı reddedilir', () async {
      final result = await controller.addAnimal(
        earTag: 'TR-06-003',
        species: 'İnek',
        lastVaccinationDate: '12/05/2026', // Hatalı format, YYYY-MM-DD beklenir
        pregnancyStatus: 'not_pregnant',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('Geçersiz tarih biçimi'));
    });

    test('Geçerli bilgilerle hayvan başarıyla eklenir', () async {
      final result = await controller.addAnimal(
        earTag: 'TR-42-8801',
        species: 'Düve',
        lastVaccinationDate: '2026-03-15',
        pregnancyStatus: 'unknown',
      );
      expect(result.isValid, isTrue);
      expect(controller.totalCount, 3);
      expect(controller.animals.any((a) => a.earTag == 'TR-42-8801'), isTrue);
    });

    test('Hayvan kaydı silinebilir', () async {
      await controller.removeAnimal('a1');
      expect(controller.totalCount, 1);
      expect(controller.animals.any((a) => a.id == 'a1'), isFalse);
    });

    test('Hayvan bilgileri başarıyla güncellenebilir', () async {
      final result = await controller.updateAnimal(
        id: 'a2',
        earTag: 'TR-06-002',
        species: 'Koyun (Küçükbaş)',
        lastVaccinationDate: '2026-05-20',
        pregnancyStatus: 'pregnant',
      );
      expect(result.isValid, isTrue);
      final updated = controller.animals.firstWhere((a) => a.id == 'a2');
      expect(updated.species, 'Koyun (Küçükbaş)');
      expect(updated.lastVaccinationDate, '2026-05-20');
      expect(updated.pregnancyStatus, 'pregnant');
      expect(controller.pregnantCount, 2);
    });

    test('Hayvan güncellenirken başka bir hayvanın küpe numarası ile çakışamaz',
        () async {
      final result = await controller.updateAnimal(
        id: 'a2',
        earTag: 'TR-06-001', // a1'in küpe numarası
        species: 'Koyun',
        lastVaccinationDate: '-',
        pregnancyStatus: 'unknown',
      );
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('zaten mevcut'));
    });
  });
}
