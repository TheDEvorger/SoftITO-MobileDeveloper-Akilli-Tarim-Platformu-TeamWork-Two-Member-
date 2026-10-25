import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../app/language_controller.dart';
import '../../../../core/storage/app_storage.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({
    super.key,
    this.isProducer = true,
    this.storage,
  });

  final bool isProducer;
  final AppStorage? storage;

  @override
  Widget build(BuildContext context) {
    AppStorage? activeStorage = storage;
    if (activeStorage == null) {
      try {
        activeStorage = AppScope.of(context).storage;
      } catch (_) {
        activeStorage = null;
      }
    }

    if (activeStorage == null) {
      return _buildContent(context, null);
    }

    AppLanguageController? langController;
    try {
      langController = AppScope.of(context).languageController;
    } catch (_) {
      langController = null;
    }

    return ListenableBuilder(
      listenable: Listenable.merge([
        activeStorage.animals.changes,
        activeStorage.products.changes,
        activeStorage.offers.changes,
        activeStorage.greenhouses.changes,
        activeStorage.serviceProviders.changes,
        if (langController != null) langController,
      ]),
      builder: (context, _) => _buildContent(context, activeStorage),
    );
  }

  Widget _buildContent(BuildContext context, AppStorage? activeStorage) {
    final int animalCount = activeStorage != null
        ? activeStorage.animals.all().length
        : 7;
    final int producerProductsCount = activeStorage != null
        ? activeStorage.products
            .all()
            .where((p) => p.sellerId == 'demo_producer_001')
            .length
        : 5;

    // Gerçek sera iklim sensör sağlığı hesaplama (%18-28 C, %55-80 nem)
    final greenhouses = activeStorage?.greenhouses.all() ?? [];
    int greenhouseHealth = 100;
    if (greenhouses.isNotEmpty) {
      int score = 0;
      for (final gh in greenhouses) {
        final isTempOk = gh.temperatureC >= 18.0 && gh.temperatureC <= 28.0;
        final isHumOk =
            gh.humidityPercent >= 55.0 && gh.humidityPercent <= 80.0;
        if (isTempOk && isHumOk) {
          score += 100;
        } else if (isTempOk || isHumOk) {
          score += 75;
        } else {
          score += 45;
        }
      }
      greenhouseHealth = (score / greenhouses.length).round();
    } else if (activeStorage == null) {
      greenhouseHealth = 95;
    }

    final int greenhouseCount =
        activeStorage != null ? greenhouses.length : 3;

    // Üreticiye gelen gerçek teklif sayısı
    final int incomingOffersCount = activeStorage != null
        ? activeStorage.offers.all().where((o) {
            final prod = activeStorage.products.find(o.productId);
            return prod != null &&
                prod.sellerId == 'demo_producer_001' &&
                !o.id.startsWith('offer_c');
          }).length
        : 6;

    // Tüketici modunda verilen ve onaylanan teklifler
    final myOffers = activeStorage?.offers.all().where((o) {
          return o.id.startsWith('offer_c') ||
              o.buyerName.contains('Hüsnü Çoban') ||
              o.buyerPhone.contains('05550123456');
        }).toList() ??
        [];
    final int givenOffersCount =
        activeStorage != null ? myOffers.length : 3;
    final int acceptedOffersCount = activeStorage != null
        ? myOffers.where((o) => o.status == 'accepted').length
        : 1;

    final tr = AppTranslations.of(context);

    // Tüketici (Alıcı) modunda pazarda satın alınabilir mahsul sayısı (Marketplace ile birebir uyumlu)
    final int buyerAvailableProductsCount = activeStorage != null
        ? activeStorage.products
            .all()
            .where((p) => p.sellerId != 'demo_producer_001')
            .length
        : 6;
    final int totalServicesCount = activeStorage != null
        ? activeStorage.serviceProviders.all().length
        : 4;

    final stats = isProducer
        ? [
            (
              Icons.pets_rounded,
              '$animalCount ${tr.unitHead}',
              tr.statRegisteredHerd,
              FarmColors.earth,
            ),
            (
              Icons.inventory_2_outlined,
              '$producerProductsCount ${tr.unitAd}',
              tr.statCropsForSale,
              FarmColors.forest,
            ),
            (
              Icons.eco_rounded,
              '%$greenhouseHealth',
              '${tr.statGreenhouseHealth} ($greenhouseCount ${tr.unitUnit})',
              const Color(0xFF2E7D32),
            ),
            (
              Icons.inbox_rounded,
              '$incomingOffersCount ${tr.unitRequest}',
              tr.statIncomingOffers,
              FarmColors.gold,
            ),
          ]
        : [
            (
              Icons.receipt_long_rounded,
              '$givenOffersCount ${tr.unitOffer}',
              tr.statSentOffers,
              FarmColors.forest,
            ),
            (
              Icons.check_circle_outline_rounded,
              '$acceptedOffersCount ${tr.unitPurchase}',
              tr.statApprovedPurchases,
              const Color(0xFF2E7D32),
            ),
            (
              Icons.storefront_rounded,
              '$buyerAvailableProductsCount ${tr.unitVariety}',
              tr.statMarketCrops,
              FarmColors.gold,
            ),
            (
              Icons.build_circle_outlined,
              '$totalServicesCount ${tr.unitFirm}',
              tr.statAgriServices,
              const Color(0xFFD81B60),
            ),
          ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: stats[0].$1,
                  value: stats[0].$2,
                  label: stats[0].$3,
                  color: stats[0].$4,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: stats[1].$1,
                  value: stats[1].$2,
                  label: stats[1].$3,
                  color: stats[1].$4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: stats[2].$1,
                  value: stats[2].$2,
                  label: stats[2].$3,
                  color: stats[2].$4,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: stats[3].$1,
                  value: stats[3].$2,
                  label: stats[3].$3,
                  color: stats[3].$4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(45), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
