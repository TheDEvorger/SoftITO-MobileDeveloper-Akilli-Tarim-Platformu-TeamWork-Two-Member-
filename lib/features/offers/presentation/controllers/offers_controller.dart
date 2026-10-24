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

  /// Üretici modunda sadece demo_producer_001 satıcısının ürünlerine gelen teklifler
  List<Offer> get roleSpecificOffers {
    final offers = allOffers;
    if (isProducer) {
      return offers.where((offer) {
        final prod = findProduct(offer.productId);
        return prod != null && prod.sellerId == demoProducerId;
      }).toList();
    }
    // Tüketici modunda oluşturulan teklifler
    return offers;
  }

  List<Offer> get filteredOffers {
    return roleSpecificOffers.where((o) {
      if (_selectedStatusFilter == 'all') return true;
      return o.status.toLowerCase() == _selectedStatusFilter.toLowerCase();
    }).toList();
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

  @override
  void dispose() {
    _offersListenable.removeListener(_onStorageChanged);
    _roleController.removeListener(_onStorageChanged);
    super.dispose();
  }
}
