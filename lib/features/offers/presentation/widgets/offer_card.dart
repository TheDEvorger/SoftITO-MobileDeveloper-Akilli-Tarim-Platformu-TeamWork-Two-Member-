import 'package:flutter/material.dart';

import '../../../../app/app_translations.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/widgets/farm_card.dart';
import '../../../../core/models/offer.dart';
import '../../../../core/models/product.dart';
import 'offer_status_badge.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({
    super.key,
    required this.offer,
    this.product,
    required this.isProducer,
    this.onAccept,
    this.onReject,
  });

  final Offer offer;
  final Product? product;
  final bool isProducer;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final targetProduct = product;
    final unit = targetProduct?.unit ?? 'Birim';
    final price = targetProduct?.unitPrice;
    final totalEstimated =
        price != null ? (offer.requestedQuantity * price) : null;

    return FarmCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product != null)
                      InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product-detail',
                          arguments: offer.productId,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                product!.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? FarmDarkColors.forest
                                      : FarmColors.forest,
                                  decoration: TextDecoration.underline,
                                  decorationColor: isDark
                                      ? FarmDarkColors.forest
                                      : FarmColors.forest,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_outward_rounded,
                              size: 15,
                              color: isDark
                                  ? FarmDarkColors.forest
                                  : FarmColors.forest,
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        tr.offerRemovedProduct(offer.productId),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                        ),
                      ),
                    const SizedBox(height: 2),
                    Text(
                      '${tr.offerDatePrefix} ${_formatDate(offer.createdAt)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? FarmDarkColors.inkMuted
                            : FarmColors.ink.withAlpha(160),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              OfferStatusBadge(status: offer.status),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? FarmDarkColors.surfaceElevated
                  : const Color(0xFFF7F4EC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? FarmDarkColors.border : const Color(0xFFE2DDD1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr.offerRequestedQty,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? FarmDarkColors.inkMuted
                              : FarmColors.ink.withAlpha(160),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${offer.requestedQuantity.toStringAsFixed(1)} $unit',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: isDark
                                ? FarmDarkColors.forest
                                : FarmColors.forest,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (totalEstimated != null) ...[
                  const SizedBox(width: 8),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          tr.offerEstimatedAmount,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? FarmDarkColors.inkMuted
                                : FarmColors.ink.withAlpha(160),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            '₺${totalEstimated.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? FarmDarkColors.gold
                                  : FarmColors.gold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 6,
            children: [
              if (isProducer) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_outline_rounded,
                        size: 16,
                        color: isDark
                            ? FarmDarkColors.forest
                            : FarmColors.forest),
                    const SizedBox(width: 6),
                    Text(
                      '${tr.offerBuyerPrefix} ${offer.buyerName}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                      ),
                    ),
                  ],
                ),
                if (offer.buyerPhone.trim().isNotEmpty)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone_outlined,
                          size: 14,
                          color: isDark
                              ? FarmDarkColors.inkMuted
                              : FarmColors.earth),
                      const SizedBox(width: 4),
                      Text(
                        offer.buyerPhone,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? FarmDarkColors.inkMuted
                              : FarmColors.earth,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ] else ...[
                if (targetProduct != null) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.storefront_outlined,
                          size: 15,
                          color: isDark
                              ? FarmDarkColors.forest
                              : FarmColors.forest),
                      const SizedBox(width: 5),
                      Text(
                        '${tr.offerProducerPrefix} ${targetProduct.city} / ${targetProduct.district}',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                        ),
                      ),
                    ],
                  ),
                  if (targetProduct.sellerPhone.trim().isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone_outlined,
                            size: 14,
                            color: isDark
                                ? FarmDarkColors.inkMuted
                                : FarmColors.earth),
                        const SizedBox(width: 4),
                        Text(
                          targetProduct.sellerPhone,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? FarmDarkColors.inkMuted
                                : FarmColors.earth,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_circle_outlined,
                        size: 15,
                        color: isDark
                            ? FarmDarkColors.inkMuted
                            : const Color(0xFF6B7280)),
                    const SizedBox(width: 4),
                    Text(
                      tr.offerBuyerYou(offer.buyerName),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? FarmDarkColors.inkMuted
                            : const Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          if (offer.note.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? FarmDarkColors.surfaceElevated
                    : const Color(0xFFF9F7F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote_rounded,
                      size: 16,
                      color: isDark
                          ? FarmDarkColors.gold
                          : FarmColors.gold),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      offer.note,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? FarmDarkColors.ink
                            : FarmColors.ink.withAlpha(190),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (isProducer &&
              offer.status == 'pending' &&
              onAccept != null &&
              onReject != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: FarmColors.alert,
                      side: const BorderSide(color: FarmColors.alert),
                      minimumSize: const Size(40, 40),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.close_rounded, size: 16),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(tr.offerActionReject,
                          style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onAccept,
                    style: FilledButton.styleFrom(
                      backgroundColor: FarmColors.forest,
                      minimumSize: const Size(40, 40),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    icon: const Icon(Icons.check_rounded, size: 16),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(tr.offerActionAccept,
                          style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
