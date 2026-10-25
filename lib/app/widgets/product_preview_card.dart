import 'package:flutter/material.dart';

import '../../core/models/product.dart';
import '../app_theme.dart';
import '../app_translations.dart';
import 'farm_card.dart';
import 'product_artwork.dart';

class ProductPreviewCard extends StatelessWidget {
  const ProductPreviewCard({
    super.key,
    required this.product,
    this.isProducer = false,
  });

  final Product product;
  final bool isProducer;

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);

    return Semantics(
        button: true,
        label: '${product.title}, ${product.unitPrice.toStringAsFixed(2)} TL',
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            '/product-detail',
            arguments: product.id,
          ),
          borderRadius: BorderRadius.circular(20),
          child: FarmCard(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ProductArtwork(imagePath: product.imagePath, height: 105),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isProducer
                                ? FarmColors.forest
                                : const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x33000000),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isProducer
                                    ? Icons.verified_rounded
                                    : Icons.storefront_rounded,
                                size: 11,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isProducer ? tr.badgeYourListing : tr.badgeLocalProducer,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${product.quantity.toStringAsFixed(0)} ${tr.translateUnit(product.unit)} · '
                          '${tr.translateCity(product.city)}',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Builder(
                          builder: (context) {
                            final isDark =
                                Theme.of(context).brightness == Brightness.dark;
                            final activeForest = isDark
                                ? FarmDarkColors.forest
                                : FarmColors.forest;
                            final activeGold = isDark
                                ? FarmDarkColors.gold
                                : const Color(0xFFB88422);
                            final color = isProducer ? activeForest : activeGold;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${product.unitPrice.toStringAsFixed(2)} ₺ / ${tr.translateUnit(product.unit)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isProducer
                                      ? tr.actionEdit
                                      : tr.actionMakeOffer,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
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
}
