import 'package:flutter/material.dart';

import 'package:akilli_tarim_platformu/app/app_scope.dart';
import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/widgets/farm_card.dart';
import '../widgets/product_detail_action_bar.dart';
import '../widgets/product_detail_hero.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final product = scope.storage.products.find(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ürün Detayı')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 50, color: FarmColors.alert),
              const SizedBox(height: 12),
              const Text('Ürün bulunamadı veya yayından kaldırılmış.'),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Geri Dön'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ProductDetailHero(
                  product: product,
                  onBack: () => Navigator.pop(context),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: FarmColors.ink,
                                ),
                      ),
                      const SizedBox(height: 12),
                      FarmCard(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Birim Fiyat',
                                  style: TextStyle(
                                      fontSize: 12, color: FarmColors.earth),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${product.unitPrice.toStringAsFixed(2)} ₺ / ${product.unit}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: FarmColors.forest,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Mevcut Miktar',
                                  style: TextStyle(
                                      fontSize: 12, color: FarmColors.earth),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${product.quantity.toStringAsFixed(0)} ${product.unit}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: FarmColors.olive,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Konum ve Satıcı Bilgileri',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 8),
                      FarmCard(
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFE8EFE5),
                                child: Icon(Icons.location_on,
                                    color: FarmColors.forest),
                              ),
                              title: const Text('Ürün Konumu'),
                              subtitle:
                                  Text('${product.city} / ${product.district}'),
                            ),
                            const Divider(height: 16),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFF7EBD3),
                                child: Icon(Icons.badge_outlined,
                                    color: FarmColors.gold),
                              ),
                              title: const Text('Üretici Kodu'),
                              subtitle: Text(product.sellerId),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Açıklama',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 8),
                      FarmCard(
                        child: Text(
                          product.description.isEmpty
                              ? 'Üretici tarafından ek bir açıklama girilmedi.'
                              : product.description,
                          style: const TextStyle(height: 1.5),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedBuilder(
            animation: scope.roleController,
            builder: (context, _) => ProductDetailActionBar(
              product: product,
              role: scope.roleController.role,
              onMakeOffer: () => Navigator.pushNamed(
                context,
                '/offer-form',
                arguments: product.id,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
