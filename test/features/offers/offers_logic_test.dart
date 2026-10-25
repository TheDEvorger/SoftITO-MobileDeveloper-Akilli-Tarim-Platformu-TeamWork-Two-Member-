import 'package:akilli_tarim_platformu/app/role_controller.dart';
import 'package:akilli_tarim_platformu/core/models/offer.dart';
import 'package:akilli_tarim_platformu/core/models/product.dart';
import 'package:akilli_tarim_platformu/core/models/user_role.dart';
import 'package:akilli_tarim_platformu/features/offers/offers.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_json_box_repository.dart';

void main() {
  group('Offers Module Unit Tests', () {
    late OfferFormController formController;
    late OffersController offersController;
    late RoleController roleController;
    late FakeBox<String> settingsBox;

    final demoProduct = const Product(
      id: 'p1',
      sellerId: 'demo_producer_001',
      title: 'Amasya Elması',
      category: 'Meyve',
      quantity: 500.0,
      unit: 'kg',
      unitPrice: 20.0,
      city: 'Amasya',
      district: 'Merkez',
      imagePath: 'assets/images/apples.png',
      sellerPhone: '05559998877',
      description: 'Taze hasat',
      createdAt: '2026-10-24T09:00:00',
    );

    final otherProduct = const Product(
      id: 'p2',
      sellerId: 'other_producer_999',
      title: 'Konya Buğdayı',
      category: 'Tahıl',
      quantity: 1000.0,
      unit: 'kg',
      unitPrice: 10.0,
      city: 'Konya',
      district: 'Cihanbeyli',
      imagePath: 'assets/images/wheat.png',
      sellerPhone: '',
      description: 'Ekmeklik buğday',
      createdAt: '2026-10-24T09:00:00',
    );

    setUp(() {
      final productRepo = createFakeRepository<Product>(
        decoder: Product.fromJson,
        encoder: (p) => p.toJson(),
        idOf: (p) => p.id,
        initialData: [demoProduct, otherProduct],
      );

      final offerRepo = createFakeRepository<Offer>(
        decoder: Offer.fromJson,
        encoder: (o) => o.toJson(),
        idOf: (o) => o.id,
        initialData: const [
          Offer(
            id: 'o1',
            productId: 'p1',
            buyerName: 'Ahmet Manav',
            buyerPhone: '05321112233',
            requestedQuantity: 200.0,
            note: 'Hemen alabilirim',
            status: 'pending',
            createdAt: '2026-10-24T10:00:00',
          ),
          Offer(
            id: 'o2',
            productId: 'p2',
            buyerName: 'Mehmet Fırın',
            buyerPhone: '',
            requestedQuantity: 300.0,
            note: '',
            status: 'pending',
            createdAt: '2026-10-24T10:00:00',
          ),
        ],
      );

      settingsBox = FakeBox<String>();
      settingsBox.put('user_role', 'producer');
      roleController = RoleController(settingsBox);

      formController = OfferFormController(
        productId: 'p1',
        productRepository: productRepo,
        offerRepository: offerRepo,
      );

      offersController = OffersController(
        offerRepository: offerRepo,
        productRepository: productRepo,
        roleController: roleController,
      );
    });

    tearDown(() {
      formController.dispose();
      offersController.dispose();
      roleController.dispose();
    });

    test('İlandaki stok miktarından fazla teklif verilemez', () async {
      final result = await formController.submitOffer(
        buyerName: 'Büyük Toptancı',
        buyerPhone: '05553332211',
        rawQuantity: '600', // Stok 500 kg
        note: '',
      );

      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('fazla olamaz'));
    });

    test('0 veya negatif miktarda teklif verilemez', () async {
      final result = await formController.submitOffer(
        buyerName: 'Deneme',
        buyerPhone: '',
        rawQuantity: '0',
        note: '',
      );

      expect(result.isSuccess, isFalse);
      expect(result.errorMessage, contains('0\'dan büyük'));
    });

    test('Geçerli miktar ile pending statüsünde teklif oluşturulur', () async {
      final result = await formController.submitOffer(
        buyerName: 'Organik Market',
        buyerPhone: '05554443322',
        rawQuantity: '150.5',
        note: 'Paketli teslimat',
      );

      expect(result.isSuccess, isTrue);
      expect(result.createdOffer, isNotNull);
      expect(result.createdOffer!.status, 'pending');
      expect(result.createdOffer!.requestedQuantity, 150.5);
    });

    test(
        'Üretici modunda sadece demo_producer_001 ilanlarına ait teklifler filtrelenir',
        () {
      expect(roleController.isProducer, isTrue);
      final producerOffers = offersController.roleSpecificOffers;
      // p1 demo_producer_001'e ait, p2 other_producer_999'a ait
      expect(producerOffers.length, 1);
      expect(producerOffers.first.productId, 'p1');
    });

    test(
        'Tüketici moduna geçilince diğer üreticilere verilen / tüketici teklifleri filtrelenir',
        () async {
      await roleController.setRole(UserRole.consumer);
      final consumerOffers = offersController.roleSpecificOffers;
      expect(consumerOffers.length, 1);
      expect(consumerOffers.first.productId, 'p2');
    });

    test('Teklif durumu accepted veya rejected olarak güncellenebilir',
        () async {
      await offersController.updateOfferStatus('o1', 'accepted');
      final updated = offersController.findProduct('p1');
      expect(updated, isNotNull);
      expect(offersController.acceptedCount, 1);
    });
  });
}
