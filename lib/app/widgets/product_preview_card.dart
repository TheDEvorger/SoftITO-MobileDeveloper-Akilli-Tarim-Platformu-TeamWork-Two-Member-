import 'package:flutter/material.dart';

import '../../core/models/product.dart';
import '../app_theme.dart';
import 'farm_card.dart';
import 'product_artwork.dart';

class ProductPreviewCard extends StatelessWidget {
  const ProductPreviewCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: '${product.title}, ${product.unitPrice.toStringAsFixed(2)} TL',
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context, '/product-detail', arguments: product.id,
          ),
          borderRadius: BorderRadius.circular(20),
          child: FarmCard(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductArtwork(imagePath: product.imagePath, height: 105),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 5),
                        Text('${product.quantity.toStringAsFixed(0)} ${product.unit} · '
                            '${product.city}',
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Text('${product.unitPrice.toStringAsFixed(2)} ₺ / ${product.unit}',
                            style: const TextStyle(
                                color: FarmColors.forest,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
