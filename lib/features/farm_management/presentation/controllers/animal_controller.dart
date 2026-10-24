import 'package:flutter/foundation.dart';

import '../../../../core/models/animal.dart';
import '../../../../core/storage/json_box_repository.dart';

class AnimalValidationResult {
  const AnimalValidationResult({required this.isValid, this.errorMessage});

  final bool isValid;
  final String? errorMessage;

  factory AnimalValidationResult.success() =>
      const AnimalValidationResult(isValid: true);

  factory AnimalValidationResult.failure(String message) =>
      AnimalValidationResult(isValid: false, errorMessage: message);
}

class AnimalController extends ChangeNotifier {
  AnimalController({required JsonBoxRepository<Animal> repository})
      : _repository = repository {
    _listenable = _repository.changes;
    _listenable.addListener(_onStorageChanged);
  }

  final JsonBoxRepository<Animal> _repository;
  late final ValueListenable<dynamic> _listenable;

  List<Animal> get animals => _repository.all();

  int get totalCount => animals.length;

  int get vaccinatedCount => animals
      .where((a) =>
          a.lastVaccinationDate.trim().isNotEmpty &&
          a.lastVaccinationDate != '-')
      .length;

  int get pregnantCount =>
      animals.where((a) => a.pregnancyStatus == 'pregnant').length;

  void _onStorageChanged() {
    notifyListeners();
  }

  AnimalValidationResult validateNewAnimal({
    required String earTag,
    required String species,
    required String vaccinationDate,
  }) {
    final cleanTag = earTag.trim();
    if (cleanTag.isEmpty) {
      return AnimalValidationResult.failure('Küpe numarası boş bırakılamaz.');
    }

    final exists = animals.any(
      (a) => a.earTag.trim().toLowerCase() == cleanTag.toLowerCase(),
    );
    if (exists) {
      return AnimalValidationResult.failure(
        'Bu küpe numarası ($cleanTag) ile kayıtlı hayvan zaten mevcut.',
      );
    }

    if (species.trim().isEmpty) {
      return AnimalValidationResult.failure('Lütfen hayvan türünü seçiniz.');
    }

    final cleanDate = vaccinationDate.trim();
    if (cleanDate.isNotEmpty) {
      // YYYY-MM-DD kontrolü
      final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (!dateRegex.hasMatch(cleanDate)) {
        return AnimalValidationResult.failure(
          'Geçersiz tarih biçimi! Tarih YYYY-AA-GG (örnek: 2026-05-12) olmalıdır.',
        );
      }
      try {
        final parsed = DateTime.parse(cleanDate);
        if (parsed.isAfter(DateTime.now().add(const Duration(days: 1)))) {
          return AnimalValidationResult.failure(
            'Son aşı tarihi gelecekteki bir tarih olamaz.',
          );
        }
      } catch (_) {
        return AnimalValidationResult.failure(
            'Geçerli bir takvim tarihi giriniz.');
      }
    }

    return AnimalValidationResult.success();
  }

  Future<AnimalValidationResult> addAnimal({
    required String earTag,
    required String species,
    required String lastVaccinationDate,
    required String pregnancyStatus,
  }) async {
    final validation = validateNewAnimal(
      earTag: earTag,
      species: species,
      vaccinationDate: lastVaccinationDate,
    );
    if (!validation.isValid) return validation;

    final newId =
        'animal_${DateTime.now().millisecondsSinceEpoch}_${earTag.trim()}';
    final animal = Animal(
      id: newId,
      earTag: earTag.trim().toUpperCase(),
      species: species.trim(),
      lastVaccinationDate:
          lastVaccinationDate.trim().isEmpty ? '-' : lastVaccinationDate.trim(),
      pregnancyStatus: pregnancyStatus,
    );

    await _repository.put(animal);
    notifyListeners();
    return AnimalValidationResult.success();
  }

  Future<void> removeAnimal(String id) async {
    await _repository.delete(id);
    notifyListeners();
  }

  @override
  void dispose() {
    _listenable.removeListener(_onStorageChanged);
    super.dispose();
  }
}
