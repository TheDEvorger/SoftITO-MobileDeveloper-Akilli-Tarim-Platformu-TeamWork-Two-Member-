import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';

import '../../../../core/models/greenhouse.dart';
import '../../../../core/storage/json_box_repository.dart';

class GreenhouseSimulatorController extends ChangeNotifier {
  GreenhouseSimulatorController({
    required JsonBoxRepository<Greenhouse> repository,
    bool autoStart = true,
  }) : _repository = repository {
    _initGreenhouses();
    if (autoStart) {
      startSimulation();
    }
  }

  final JsonBoxRepository<Greenhouse> _repository;
  final math.Random _random = math.Random();
  Timer? _timer;
  List<Greenhouse> _liveGreenhouses = [];
  bool _isDisposed = false;

  List<Greenhouse> get greenhouses => List.unmodifiable(_liveGreenhouses);
  bool get isRunning => _timer != null && _timer!.isActive;

  void _initGreenhouses() {
    final stored = _repository.all();
    if (stored.isNotEmpty) {
      _liveGreenhouses = List.from(stored);
    } else {
      // Varsayılan en az iki sera kartı
      _liveGreenhouses = [
        Greenhouse(
          id: 'gh_demo_01',
          name: 'Domates & Biber Serası A-1',
          temperatureC: 24.5,
          humidityPercent: 68.0,
          updatedAt: DateTime.now().toIso8601String(),
        ),
        Greenhouse(
          id: 'gh_demo_02',
          name: 'Topraksız Çilek Serası B-2',
          temperatureC: 21.0,
          humidityPercent: 74.0,
          updatedAt: DateTime.now().toIso8601String(),
        ),
      ];
      for (final g in _liveGreenhouses) {
        _repository.put(g);
      }
    }
  }

  void startSimulation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => tick());
  }

  void stopSimulation() {
    _timer?.cancel();
    _timer = null;
  }

  /// 5 saniyede bir sıcaklık ±0.5 °C, nem ±2 puan dalgalanması. Nem 0-100 aralığında.
  void tick() {
    if (_isDisposed) return;

    _liveGreenhouses = _liveGreenhouses.map((gh) {
      // -0.5 ile +0.5 °C arası dalgalanma
      final tempDelta = (_random.nextDouble() * 1.0) - 0.5;
      final rawTemp = gh.temperatureC + tempDelta;
      final newTemp = double.parse(rawTemp.toStringAsFixed(1));

      // -2 ile +2 puan arası nem dalgalanması
      final humDelta = (_random.nextDouble() * 4.0) - 2.0;
      final rawHum = gh.humidityPercent + humDelta;
      // 0 ile 100 aralığına sabitle
      final clampedHum = rawHum.clamp(0.0, 100.0);
      final newHum = double.parse(clampedHum.toStringAsFixed(1));

      return Greenhouse(
        id: gh.id,
        name: gh.name,
        temperatureC: newTemp,
        humidityPercent: newHum,
        updatedAt: DateTime.now().toIso8601String(),
      );
    }).toList();

    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
