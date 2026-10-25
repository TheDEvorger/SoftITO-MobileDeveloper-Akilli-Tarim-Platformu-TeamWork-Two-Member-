import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:akilli_tarim_platformu/app/app_scope.dart';
import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/app_translations.dart';
import 'package:akilli_tarim_platformu/app/widgets/farm_card.dart';
import '../controllers/marketplace_filter_controller.dart';
import '../widgets/marketplace_filter_bar.dart';
import '../widgets/marketplace_product_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  late final MarketplaceFilterController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MarketplaceFilterController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final storage = scope.storage;
    final roleController = scope.roleController;
    final langController = scope.languageController;

    return AnimatedBuilder(
      animation: Listenable.merge([
        roleController,
        if (langController != null) langController,
      ]),
      builder: (context, _) {
        final isProducer = roleController.isProducer;
        final tr = AppTranslations.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isProducer ? tr.marketProducerTitle : tr.marketConsumerTitle,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: tr.refresh,
                onPressed: () => setState(() {}),
              ),
            ],
          ),
          body: SafeArea(
            child: ValueListenableBuilder<Box<String>>(
              valueListenable: storage.products.changes,
              builder: (context, _, __) {
                final allProducts = storage.products.all();

                // ÜRETİCİ MODUNDA: Sadece kendi satış ilanların (demo_producer_001).
                // TÜKETİCİ MODUNDA: Sadece diğer yerel üreticilerin ilanları (demo_producer_001 hariç).
                final roleProducts = isProducer
                    ? allProducts
                        .where((p) => p.sellerId == 'demo_producer_001')
                        .toList()
                    : allProducts
                        .where((p) => p.sellerId != 'demo_producer_001')
                        .toList();

                final categories = [
                  'Tümü',
                  ...{...roleProducts.map((p) => p.category)}
                ];
                final cities = [
                  'Tümü',
                  ...{...roleProducts.map((p) => p.city)}
                ];

                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    final filtered = _controller.apply(roleProducts);

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                      children: [
                        _buildRoleBanner(
                          isProducer: isProducer,
                          count: roleProducts.length,
                          tr: tr,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        MarketplaceFilterBar(
                          filter: _controller.filter,
                          categories: categories,
                          cities: cities,
                          onSearchChanged: _controller.setSearchQuery,
                          onCategorySelected: _controller.setCategory,
                          onCitySelected: _controller.setCity,
                          onReset: _controller.reset,
                          resultCount: filtered.length,
                        ),
                        const SizedBox(height: 14),
                        if (filtered.isEmpty)
                          FarmCard(
                            child: Column(
                              children: [
                                Icon(Icons.search_off,
                                    size: 48,
                                    color: isDark
                                        ? FarmDarkColors.gold
                                        : FarmColors.earth),
                                const SizedBox(height: 12),
                                Text(
                                  isProducer
                                      ? tr.noProducerProducts
                                      : tr.marketNoResults,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? FarmDarkColors.ink
                                        : FarmColors.ink,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isProducer
                                      ? tr.marketProducerBannerDesc
                                      : tr.marketConsumerBannerDesc,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isDark
                                        ? FarmDarkColors.inkMuted
                                        : const Color(0xFF4B5563),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                if (isProducer)
                                  FilledButton.icon(
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/add-product'),
                                    icon: const Icon(Icons.add),
                                    label: Text(tr.postNewAd),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: FarmColors.forest,
                                    ),
                                  )
                                else
                                  OutlinedButton(
                                    onPressed: _controller.reset,
                                    child: Text(tr.resetFilters),
                                  ),
                              ],
                            ),
                          )
                        else
                          for (final product in filtered) ...[
                            MarketplaceProductCard(
                              product: product,
                              isProducer: isProducer,
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/product-detail',
                                arguments: product.id,
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                      ],
                    );
                  },
                );
              },
            ),
          ),
          floatingActionButton: isProducer
              ? FloatingActionButton.extended(
                  onPressed: () => Navigator.pushNamed(context, '/add-product'),
                  backgroundColor: FarmColors.forest,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.add),
                  label: Text(tr.postNewAd,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                )
              : FloatingActionButton.extended(
                  onPressed: () => Navigator.pushNamed(context, '/offers'),
                  backgroundColor: const Color(0xFFB88422),
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: Text(tr.myGivenOffers,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
        );
      },
    );
  }

  Widget _buildRoleBanner({
    required bool isProducer,
    required int count,
    required AppTranslations tr,
    required bool isDark,
  }) {
    if (isProducer) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? FarmDarkColors.surfaceElevated : const Color(0xFFEDF5EE),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? FarmDarkColors.border : FarmColors.forest.withAlpha(50),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.storefront_rounded,
                  color: isDark ? FarmDarkColors.forest : FarmColors.forest,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tr.marketProducerBannerTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: isDark ? FarmDarkColors.forest : FarmColors.forest,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? FarmDarkColors.forest : FarmColors.forest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count ${tr.unitAd}',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF0C2419) : Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              tr.marketProducerBannerDesc,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? FarmDarkColors.inkMuted : const Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? FarmDarkColors.surfaceElevated : const Color(0xFFFFF9ED),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? FarmDarkColors.border : FarmColors.gold.withAlpha(80),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.shopping_basket_rounded,
                color: isDark ? FarmDarkColors.gold : const Color(0xFFB88422),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.marketConsumerBannerTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tr.marketConsumerBannerDesc,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? FarmDarkColors.inkMuted : const Color(0xFF4B5563),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark
                      ? FarmDarkColors.gold.withAlpha(50)
                      : const Color(0xFFB88422),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count ${tr.unitFirm}',
                  style: TextStyle(
                    color: isDark ? FarmDarkColors.gold : Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
