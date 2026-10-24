import 'package:akilli_tarim_platformu/core/models/animal.dart';
import 'package:akilli_tarim_platformu/core/models/offer.dart';
import 'package:akilli_tarim_platformu/core/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Ürün alanları JSON dönüşümünden sonra korunur', () {
    const product = Product(
      id: 'p1', sellerId: 'demo_producer_001', title: 'Elma',
      category: 'Meyve', quantity: 500, unit: 'kg', unitPrice: 23.5,
      city: 'Isparta', district: 'Eğirdir', imagePath: 'assets/images/apples.png',
      sellerPhone: '', description: 'Deneme', createdAt: '2026-10-24T09:00:00',
    );
    final decoded = Product.fromJson(product.toJson());
    expect(decoded.quantity, 500.0);
    expect(decoded.unitPrice, 23.5);
    expect(decoded.sellerId, 'demo_producer_001');
  });

  test('Hayvan gebelik durumu unknown korunur', () {
    const animal = Animal(
      id: 'a1', earTag: 'TR-DEMO-1', species: 'İnek',
      lastVaccinationDate: '2026-10-01', pregnancyStatus: 'unknown',
    );
    expect(Animal.fromJson(animal.toJson()).pregnancyStatus, 'unknown');
  });

  test('Teklif ilişkisi için productId alanı korunur', () {
    const offer = Offer(
      id: 'o1', productId: 'p1', buyerName: 'Demo', buyerPhone: '',
      requestedQuantity: 200, note: '', status: 'pending',
      createdAt: '2026-10-24T09:00:00',
    );
    final parsed = Offer.fromJson(offer.toJson());
    expect(parsed.productId, 'p1');
    expect(parsed.status, 'pending');
  });
}
