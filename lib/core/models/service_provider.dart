import 'json_fields.dart';

class ServiceProvider {
  final String id;
  final String name;
  final String type;
  final String city;
  final String district;
  final String phone;
  final String description;

  const ServiceProvider({
    required this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.district,
    required this.phone,
    required this.description,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) => ServiceProvider(
    id: jsonText(json, 'id'),
    name: jsonText(json, 'name'),
    type: jsonText(json, 'type'),
    city: jsonText(json, 'city'),
    district: jsonText(json, 'district'),
    phone: jsonText(json, 'phone'),
    description: jsonText(json, 'description'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'city': city,
    'district': district,
    'phone': phone,
    'description': description,
  };
}
