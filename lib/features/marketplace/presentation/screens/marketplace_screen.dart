import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:akilli_tarim_platformu/app/app_scope.dart';
import 'package:akilli_tarim_platformu/app/app_theme.dart';
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
    final storage = AppScope.of(context).storage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Üretici Pazarı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Yenile',
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<Box<String>>(
          valueListenable: storage.products.changes,
          builder: (context, _, __) {
            final allProducts = storage.products.all();
            final categories = [
              'Tümü',
              ...{...allProducts.map((p) => p.category)}
            ];
            final cities = [
              'Tümü',
              ...{...allProducts.map((p) => p.city)}
            ];

            return AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final filtered = _controller.apply(allProducts);

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  children: [
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
                    const SizedBox(height: 16),
                    if (filtered.isEmpty)
                      FarmCard(
                        child: Column(
                          children: [
                            const Icon(Icons.search_off,
                                size: 48, color: FarmColors.earth),
                            const SizedBox(height: 12),
                            const Text(
                              'Bu kriterlere uygun ürün bulunamadı.',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Filtreleri sıfırlayarak tüm ürünleri görüntüleyebilirsiniz.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: _controller.reset,
                              child: const Text('Filtreleri Temizle'),
                            ),
                          ],
                        ),
                      )
                    else
                      for (final product in filtered) ...[
                        MarketplaceProductCard(
                          product: product,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-product'),
        backgroundColor: FarmColors.forest,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('İlan Ekle',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
