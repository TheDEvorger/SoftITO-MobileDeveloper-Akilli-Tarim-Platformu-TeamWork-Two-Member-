import 'package:flutter/material.dart';

import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/app_translations.dart';
import 'package:akilli_tarim_platformu/app/widgets/farm_card.dart';
import 'package:akilli_tarim_platformu/app/widgets/product_artwork.dart';
import 'package:akilli_tarim_platformu/core/models/product.dart';

class MarketplaceProductCard extends StatelessWidget {
  const MarketplaceProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.isProducer = false,
  });

  final Product product;
  final VoidCallback onTap;
  final bool isProducer;

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeForest = isDark ? FarmDarkColors.forest : FarmColors.forest;
    final activeGold = isDark ? FarmDarkColors.gold : FarmColors.gold;

    return Semantics(
      button: true,
      label: '${product.title}, ${product.unitPrice.toStringAsFixed(2)} TL',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: FarmCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(19),
                    ),
                    child: ProductArtwork(
                      imagePath: product.imagePath,
                      height: 140,
                    ),
                  ),
                  if (isProducer)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: FarmColors.forest,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded,
                                size: 13, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              tr.badgeYourListing,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.storefront_rounded,
                                size: 13, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              tr.badgeLocalProducer,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xDE1F2721),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFD9D6C8),
                        ),
                      ),
                      child: Text(
                        tr.translateCategory(product.category),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFF7F1E5),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? FarmDarkColors.ink
                                      : FarmColors.ink,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${product.unitPrice.toStringAsFixed(2)} ₺',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: activeForest,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: isDark
                              ? FarmDarkColors.earth
                              : FarmColors.earth,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${tr.translateCity(product.city)}, ${product.district}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark
                                          ? FarmDarkColors.inkMuted
                                          : const Color(0xFF4B5563),
                                      fontWeight: FontWeight.w500,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${tr.stock}: ${product.quantity.toStringAsFixed(0)} ${tr.translateUnit(product.unit)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? FarmDarkColors.olive
                                  : FarmColors.olive,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Rol bazlı aksiyon şeridi
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isProducer
                            ? (isDark
                                ? activeForest.withAlpha(35)
                                : const Color(0xFFEDF5EF))
                            : (isDark
                                ? activeGold.withAlpha(35)
                                : const Color(0xFFFFF7E8)),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isProducer
                              ? activeForest.withAlpha(isDark ? 80 : 60)
                              : activeGold.withAlpha(isDark ? 100 : 90),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isProducer
                                ? Icons.edit_note_rounded
                                : Icons.handshake_outlined,
                            size: 16,
                            color: isProducer ? activeForest : activeGold,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              isProducer
                                  ? tr.marketEditListing
                                  : tr.marketMakeOffer,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isProducer
                                    ? activeForest
                                    : (isDark
                                        ? activeGold
                                        : const Color(0xFF8A5A00)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13,
                            color: isProducer ? activeForest : activeGold,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
