import 'json_fields.dart';

class Animal {
  final String id;
  final String earTag;
  final String species;
  final String lastVaccinationDate;
  final String pregnancyStatus;

  const Animal({
    required this.id,
    required this.earTag,
    required this.species,
    required this.lastVaccinationDate,
    required this.pregnancyStatus,
  });

  factory Animal.fromJson(Map<String, dynamic> json) => Animal(
        id: jsonText(json, 'id'),
        earTag: jsonText(json, 'earTag'),
        species: jsonText(json, 'species'),
        lastVaccinationDate: jsonText(json, 'lastVaccinationDate'),
        pregnancyStatus: jsonText(json, 'pregnancyStatus'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'earTag': earTag,
        'species': species,
        'lastVaccinationDate': lastVaccinationDate,
        'pregnancyStatus': pregnancyStatus,
      };
}
