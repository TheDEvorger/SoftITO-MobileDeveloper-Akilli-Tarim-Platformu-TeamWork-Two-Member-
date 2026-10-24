import 'package:flutter/material.dart';

import '../app_scope.dart';
import '../app_theme.dart';
import '../widgets/farm_card.dart';
import '../widgets/product_artwork.dart';

class ProductDetailPreviewScreen extends StatelessWidget {
  const ProductDetailPreviewScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = AppScope.of(context).storage.products.find(productId);
    return Scaffold(
      appBar: AppBar(title: const Text('Ürün detayı · Önizleme')),
      body: SafeArea(
        child: product == null
            ? const Center(child: Text('Ürün bulunamadı.'))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ProductArtwork(imagePath: product.imagePath, height: 230),
                  ),
                  const SizedBox(height: 18),
                  Text(product.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('${product.unitPrice.toStringAsFixed(2)} ₺ / ${product.unit}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: FarmColors.forest, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  FarmCard(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${product.quantity.toStringAsFixed(0)} ${product.unit} · '
                          '${product.city} / ${product.district}'),
                      const Divider(height: 24),
                      Text(product.description),
                    ],
                  )),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () => Navigator.pushNamed(
                        context, '/offer-form', arguments: product.id),
                    icon: const Icon(Icons.send_outlined),
                    label: const Text('Teklif oluştur (demo ekranı)'),
                  ),
                ],
              ),
      ),
    );
  }
}
