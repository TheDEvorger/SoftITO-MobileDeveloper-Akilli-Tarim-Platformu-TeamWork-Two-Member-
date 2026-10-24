import 'json_fields.dart';

class Offer {
  final String id;
  final String productId;
  final String buyerName;
  final String buyerPhone;
  final double requestedQuantity;
  final String note;
  final String status;
  final String createdAt;

  const Offer({
    required this.id,
    required this.productId,
    required this.buyerName,
    required this.buyerPhone,
    required this.requestedQuantity,
    required this.note,
    required this.status,
    required this.createdAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: jsonText(json, 'id'),
        productId: jsonText(json, 'productId'),
        buyerName: jsonText(json, 'buyerName'),
        buyerPhone: jsonText(json, 'buyerPhone'),
        requestedQuantity: jsonNumber(json, 'requestedQuantity'),
        note: jsonText(json, 'note'),
        status: jsonText(json, 'status'),
        createdAt: jsonText(json, 'createdAt'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'productId': productId,
        'buyerName': buyerName,
        'buyerPhone': buyerPhone,
        'requestedQuantity': requestedQuantity,
        'note': note,
        'status': status,
        'createdAt': createdAt,
      };
}
