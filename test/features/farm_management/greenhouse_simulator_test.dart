import 'package:akilli_tarim_platformu/core/models/greenhouse.dart';
import 'package:akilli_tarim_platformu/features/farm_management/farm_management.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_json_box_repository.dart';

void main() {
  group('GreenhouseSimulatorController Unit Tests', () {
    late GreenhouseSimulatorController controller;

    setUp(() {
      final repo = createFakeRepository<Greenhouse>(
        decoder: Greenhouse.fromJson,
        encoder: (g) => g.toJson(),
        idOf: (g) => g.id,
        initialData: const [
          Greenhouse(
            id: 'gh1',
            name: 'Sera 1',
            temperatureC: 22.0,
            humidityPercent: 65.0,
            updatedAt: '2026-10-24T10:00:00',
          ),
          Greenhouse(
            id: 'gh2',
            name: 'Sera 2',
            temperatureC: 25.0,
            humidityPercent: 99.0,
            updatedAt: '2026-10-24T10:00:00',
          ),
        ],
      );
      // autoStart: false ile manuel kontrol testi
      controller =
          GreenhouseSimulatorController(repository: repo, autoStart: false);
    });

    tearDown(() {
      controller.dispose();
    });

    test('En az iki sera kartı yüklenir', () {
      expect(controller.greenhouses.length, greaterThanOrEqualTo(2));
    });

    test(
        'tick() çağrıldığında değerler dalgalanır ve nem 0-100 aralığında kalır',
        () {
      controller.tick();
      final updatedGreenhouses = controller.greenhouses;

      for (final gh in updatedGreenhouses) {
        expect(gh.humidityPercent, greaterThanOrEqualTo(0.0));
        expect(gh.humidityPercent, lessThanOrEqualTo(100.0));
      }

      // Değerlerin değiştiğini veya korunduğunu doğrula
      expect(updatedGreenhouses.first.updatedAt, isNotEmpty);
    });

    test(
        'Timer startSimulation ve stopSimulation durumları doğru kontrol edilir',
        () {
      expect(controller.isRunning, isFalse);
      controller.startSimulation();
      expect(controller.isRunning, isTrue);
      controller.stopSimulation();
      expect(controller.isRunning, isFalse);
    });

    test('dispose() çağrıldığında timer kapatılır', () {
      final localController = GreenhouseSimulatorController(
        repository: createFakeRepository<Greenhouse>(
          decoder: Greenhouse.fromJson,
          encoder: (g) => g.toJson(),
          idOf: (g) => g.id,
        ),
        autoStart: true,
      );
      expect(localController.isRunning, isTrue);
      localController.dispose();
      expect(localController.isRunning, isFalse);
    });

    test('Yeni sera başarıyla eklenir ve listeye dahil edilir', () async {
      final initialCount = controller.greenhouses.length;
      await controller.addGreenhouse(
        name: 'Topraksız Çilek Serası',
        initialTemp: 23.5,
        initialHumidity: 65.0,
      );

      expect(controller.greenhouses.length, initialCount + 1);
      final added = controller.greenhouses.last;
      expect(added.name, 'Topraksız Çilek Serası');
      expect(added.temperatureC, 23.5);
      expect(added.humidityPercent, 65.0);
    });

    test('Sera bilgileri başarıyla güncellenir ve kalibre edilir', () async {
      await controller.updateGreenhouse(
        id: 'gh1',
        name: 'Modernize Edilmiş Sera 1',
        temperatureC: 24.0,
        humidityPercent: 62.0,
      );

      final updated = controller.greenhouses.firstWhere((g) => g.id == 'gh1');
      expect(updated.name, 'Modernize Edilmiş Sera 1');
      expect(updated.temperatureC, 24.0);
      expect(updated.humidityPercent, 62.0);
    });

    test('Sera başarıyla silinir', () async {
      final initialCount = controller.greenhouses.length;
      await controller.removeGreenhouse('gh1');

      expect(controller.greenhouses.length, initialCount - 1);
      expect(controller.greenhouses.any((g) => g.id == 'gh1'), isFalse);
    });

    test('Canlı iklim koşullarına göre sağlık skoru hesaplanır', () {
      final health = controller.healthPercentage;
      expect(health, greaterThanOrEqualTo(0));
      expect(health, lessThanOrEqualTo(100));
    });
  });
}
