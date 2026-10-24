import 'json_fields.dart';

class Greenhouse {
  final String id;
  final String name;
  final double temperatureC;
  final double humidityPercent;
  final String updatedAt;

  const Greenhouse({
    required this.id,
    required this.name,
    required this.temperatureC,
    required this.humidityPercent,
    required this.updatedAt,
  });

  factory Greenhouse.fromJson(Map<String, dynamic> json) => Greenhouse(
        id: jsonText(json, 'id'),
        name: jsonText(json, 'name'),
        temperatureC: jsonNumber(json, 'temperatureC'),
        humidityPercent: jsonNumber(json, 'humidityPercent'),
        updatedAt: jsonText(json, 'updatedAt'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'temperatureC': temperatureC,
        'humidityPercent': humidityPercent,
        'updatedAt': updatedAt,
      };
}
