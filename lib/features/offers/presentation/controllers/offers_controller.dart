import 'package:flutter/foundation.dart';

import '../../../../app/role_controller.dart';
import '../../../../core/models/offer.dart';
import '../../../../core/models/product.dart';
import '../../../../core/storage/json_box_repository.dart';

class OffersController extends ChangeNotifier {
  OffersController({
    required JsonBoxRepository<Offer> offerRepository,
    required JsonBoxRepository<Product> productRepository,
    required RoleController roleController,
  })  : _offerRepository = offerRepository,
        _productRepository = productRepository,
        _roleController = roleController {
    _offersListenable = _offerRepository.changes;
    _offersListenable.addListener(_onStorageChanged);
    _roleController.addListener(_onStorageChanged);

    // Teklif kutusu boş ise kullanıcıya asla boş sayfa gösterme; demo teklifleri hemen yükle
    if (_offerRepository.all().isEmpty) {
      _seedDefaultOffers();
    }
  }

  static const String demoProducerId = 'demo_producer_001';

  final JsonBoxRepository<Offer> _offerRepository;
  final JsonBoxRepository<Product> _productRepository;
  final RoleController _roleController;

  late final ValueListenable<dynamic> _offersListenable;
  String _selectedStatusFilter = 'all'; // all, pending, accepted, rejected

  String get selectedStatusFilter => _selectedStatusFilter;
  bool get isProducer => _roleController.isProducer;

  void _onStorageChanged() {
    notifyListeners();
  }

  List<Offer> get allOffers => _offerRepository.all();

  Product? findProduct(String productId) => _productRepository.find(productId);

  /// Üretici modunda sadece demo_producer_001 satıcısının ürünlerine dış alıcılardan gelen talepler
  /// Tüketici modunda ise kullanıcının (Hüsnü Çoban) üreticilere ilettiği ürün alım talepleri
  List<Offer> get roleSpecificOffers {
    final offers = allOffers;
    if (isProducer) {
      return offers.where((offer) {
        final prod = findProduct(offer.productId);
        final isOurProduct = prod != null && prod.sellerId == demoProducerId;
        final isSelfOffer = offer.id.startsWith('offer_c') ||
            offer.buyerName.contains('Hüsnü Çoban');
        return isOurProduct && !isSelfOffer;
      }).toList();
    } else {
      return offers.where((offer) {
        final prod = findProduct(offer.productId);
        final isOurOffer = offer.id.startsWith('offer_c') ||
            offer.buyerName.contains('Hüsnü Çoban') ||
            offer.buyerPhone.contains('05550123456') ||
            offer.buyerPhone.contains('012 34 56') ||
            (prod != null && prod.sellerId != demoProducerId);
        return isOurOffer;
      }).toList();
    }
  }

  List<Offer> get filteredOffers {
    final list = roleSpecificOffers.where((o) {
      if (_selectedStatusFilter == 'all') return true;
      return o.status.toLowerCase() == _selectedStatusFilter.toLowerCase();
    }).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  int get pendingCount =>
      roleSpecificOffers.where((o) => o.status == 'pending').length;

  int get acceptedCount =>
      roleSpecificOffers.where((o) => o.status == 'accepted').length;

  int get rejectedCount =>
      roleSpecificOffers.where((o) => o.status == 'rejected').length;

  void setStatusFilter(String filter) {
    if (_selectedStatusFilter == filter) return;
    _selectedStatusFilter = filter;
    notifyListeners();
  }

  Future<void> updateOfferStatus(String offerId, String newStatus) async {
    final existing = _offerRepository.find(offerId);
    if (existing == null) return;

    final updated = Offer(
      id: existing.id,
      productId: existing.productId,
      buyerName: existing.buyerName,
      buyerPhone: existing.buyerPhone,
      requestedQuantity: existing.requestedQuantity,
      note: existing.note,
      status: newStatus,
      createdAt: existing.createdAt,
    );

    await _offerRepository.put(updated);
    notifyListeners();
  }

  Future<void> reloadDemoOffers() async {
    await _seedDefaultOffers();
  }

  Future<void> _seedDefaultOffers() async {
    final demoOffers = [
      const Offer(
        id: 'offer_001',
        productId: 'product_001',
        buyerName: 'Ahmet Yılmaz (Konya Değirmen A.Ş.)',
        buyerPhone: '+90 532 555 12 34',
        requestedQuantity: 200.0,
        note:
            'Fırınlık un üretimi için ilk parti alımı. Analiz raporu olumlu gelirse sezonluk sözleşme yapabiliriz.',
        status: 'pending',
        createdAt: '2026-10-24T14:30:00',
      ),
      const Offer(
        id: 'offer_002',
        productId: 'product_002',
        buyerName: 'Selin Aksoy (Organik Meyve Suları)',
        buyerPhone: '+90 533 888 99 00',
        requestedQuantity: 350.0,
        note:
            'Soğuk sıkım meyve sularımız için haftalık düzenli sevkiyat planlıyoruz. Kasalı teslimat uygundur.',
        status: 'pending',
        createdAt: '2026-10-24T15:10:00',
      ),
      const Offer(
        id: 'offer_003',
        productId: 'product_003',
        buyerName: 'Mahalle Şarküterisi (Emre Güneş)',
        buyerPhone: '+90 535 333 22 11',
        requestedQuantity: 50.0,
        note:
            'Günlük taze çiğ süt satışı ve deneme peynir üretimi için alım yapmak istiyoruz.',
        status: 'pending',
        createdAt: '2026-10-24T16:00:00',
      ),
      const Offer(
        id: 'offer_004',
        productId: 'product_001',
        buyerName: 'Bursa Bereket Taş Fırınları',
        buyerPhone: '+90 544 222 33 44',
        requestedQuantity: 150.0,
        note:
            'Özel ekşi mayalı köy ekmeklerimiz için 150 kg sert buğday siparişi. İletişime geçilerek nakliye koordine edildi.',
        status: 'accepted',
        createdAt: '2026-10-23T11:00:00',
      ),
      const Offer(
        id: 'offer_005',
        productId: 'product_003',
        buyerName: 'Ege Mandırası & Geleneksel Peynircilik',
        buyerPhone: '+90 530 444 55 66',
        requestedQuantity: 250.0,
        note:
            'Soğutmalı araçla çiftlikten teslim alındı, ödeme ve kantar fişi tamamlandı.',
        status: 'accepted',
        createdAt: '2026-10-22T09:30:00',
      ),
      const Offer(
        id: 'offer_006',
        productId: 'product_002',
        buyerName: 'Halil Manav & Toptan Ticaret',
        buyerPhone: '+90 551 777 66 55',
        requestedQuantity: 700.0,
        note:
            'Birim fiyat 20 TL/kg olursa tüm partiyi yarın alabiliriz. (Maliyetin altında teklif verildiği için reddedildi).',
        status: 'rejected',
        createdAt: '2026-10-21T17:45:00',
      ),
      const Offer(
        id: 'offer_c01',
        productId: 'product_006',
        buyerName: 'Hüsnü Çoban',
        buyerPhone: '+90 555 012 34 56',
        requestedQuantity: 15.0,
        note:
            'Marmaris çam balı için 15 kg numune alımı yapmak istiyoruz. Analiz ve kaliteden memnun kalırsak düzenli sipariş vereceğiz.',
        status: 'pending',
        createdAt: '2026-10-24T17:15:00',
      ),
      const Offer(
        id: 'offer_c02',
        productId: 'product_005',
        buyerName: 'Hüsnü Çoban',
        buyerPhone: '+90 555 012 34 56',
        requestedQuantity: 30.0,
        note:
            'Köy bakkalımız ve yerel aile tüketimi için kaliteli kuru kayısı siparişi.',
        status: 'accepted',
        createdAt: '2026-10-23T14:00:00',
      ),
      const Offer(
        id: 'offer_c03',
        productId: 'product_004',
        buyerName: 'Hüsnü Çoban',
        buyerPhone: '+90 555 012 34 56',
        requestedQuantity: 150.0,
        note: 'Birim fiyat 20 TL/kg olursa 150 kg alabiliriz.',
        status: 'rejected',
        createdAt: '2026-10-22T16:20:00',
      ),
    ];

    for (final offer in demoOffers) {
      await _offerRepository.put(offer);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _offersListenable.removeListener(_onStorageChanged);
    _roleController.removeListener(_onStorageChanged);
    super.dispose();
  }
}
