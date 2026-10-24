import 'json_fields.dart';

class Product {
  final String id;
  final String sellerId;
  final String title;
  final String category;
  final double quantity;
  final String unit;
  final double unitPrice;
  final String city;
  final String district;
  final String imagePath;
  final String sellerPhone;
  final String description;
  final String createdAt;

  const Product({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.city,
    required this.district,
    required this.imagePath,
    required this.sellerPhone,
    required this.description,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: jsonText(json, 'id'),
    sellerId: jsonText(json, 'sellerId'),
    title: jsonText(json, 'title'),
    category: jsonText(json, 'category'),
    quantity: jsonNumber(json, 'quantity'),
    unit: jsonText(json, 'unit'),
    unitPrice: jsonNumber(json, 'unitPrice'),
    city: jsonText(json, 'city'),
    district: jsonText(json, 'district'),
    imagePath: jsonText(json, 'imagePath'),
    sellerPhone: jsonText(json, 'sellerPhone'),
    description: jsonText(json, 'description'),
    createdAt: jsonText(json, 'createdAt'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'sellerId': sellerId,
    'title': title,
    'category': category,
    'quantity': quantity,
    'unit': unit,
    'unitPrice': unitPrice,
    'city': city,
    'district': district,
    'imagePath': imagePath,
    'sellerPhone': sellerPhone,
    'description': description,
    'createdAt': createdAt,
  };
}
