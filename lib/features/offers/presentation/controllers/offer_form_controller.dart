import 'package:flutter/foundation.dart';

import '../../../../core/models/offer.dart';
import '../../../../core/models/product.dart';
import '../../../../core/storage/json_box_repository.dart';

class OfferSubmissionResult {
  const OfferSubmissionResult(
      {required this.isSuccess, this.errorMessage, this.createdOffer});

  final bool isSuccess;
  final String? errorMessage;
  final Offer? createdOffer;

  factory OfferSubmissionResult.success(Offer offer) =>
      OfferSubmissionResult(isSuccess: true, createdOffer: offer);

  factory OfferSubmissionResult.failure(String error) =>
      OfferSubmissionResult(isSuccess: false, errorMessage: error);
}

class OfferFormController extends ChangeNotifier {
  OfferFormController({
    required String productId,
    required JsonBoxRepository<Product> productRepository,
    required JsonBoxRepository<Offer> offerRepository,
  })  : _productId = productId,
        _productRepository = productRepository,
        _offerRepository = offerRepository;

  final String _productId;
  final JsonBoxRepository<Product> _productRepository;
  final JsonBoxRepository<Offer> _offerRepository;

  Product? get product => _productRepository.find(_productId);

  OfferSubmissionResult validateInputs({
    required String buyerName,
    required String buyerPhone,
    required String rawQuantity,
  }) {
    final targetProduct = product;
    if (targetProduct == null) {
      return OfferSubmissionResult.failure(
        'Teklif verilmek istenen ürün bulunamadı veya ilandan kaldırılmış.',
      );
    }

    final cleanName = buyerName.trim();
    if (cleanName.isEmpty) {
      return OfferSubmissionResult.failure(
          'Lütfen adınızı veya ticari unvanınızı giriniz.');
    }

    final cleanQty = rawQuantity.replaceAll(',', '.').trim();
    final parsedQty = double.tryParse(cleanQty);
    if (parsedQty == null || parsedQty <= 0) {
      return OfferSubmissionResult.failure(
          'Lütfen geçerli ve 0\'dan büyük bir talep miktarı giriniz.');
    }

    if (parsedQty > targetProduct.quantity) {
      return OfferSubmissionResult.failure(
        'Talep edilen miktar (${parsedQty.toStringAsFixed(1)} ${targetProduct.unit}), ilandaki toplam mevcut stoktan (${targetProduct.quantity.toStringAsFixed(1)} ${targetProduct.unit}) fazla olamaz.',
      );
    }

    return OfferSubmissionResult.success(
      Offer(
        id: '',
        productId: _productId,
        buyerName: cleanName,
        buyerPhone: buyerPhone.trim(),
        requestedQuantity: parsedQty,
        note: '',
        status: 'pending',
        createdAt: '',
      ),
    );
  }

  Future<OfferSubmissionResult> submitOffer({
    required String buyerName,
    required String buyerPhone,
    required String rawQuantity,
    required String note,
  }) async {
    final validation = validateInputs(
      buyerName: buyerName,
      buyerPhone: buyerPhone,
      rawQuantity: rawQuantity,
    );

    if (!validation.isSuccess) return validation;

    final parsedQty = double.parse(rawQuantity.replaceAll(',', '.').trim());
    final newId =
        'offer_${DateTime.now().millisecondsSinceEpoch}_${buyerName.hashCode.abs()}';

    final offer = Offer(
      id: newId,
      productId: _productId,
      buyerName: buyerName.trim(),
      buyerPhone: buyerPhone.trim(),
      requestedQuantity: parsedQty,
      note: note.trim(),
      status: 'pending',
      createdAt: DateTime.now().toIso8601String(),
    );

    await _offerRepository.put(offer);
    notifyListeners();
    return OfferSubmissionResult.success(offer);
  }
}
