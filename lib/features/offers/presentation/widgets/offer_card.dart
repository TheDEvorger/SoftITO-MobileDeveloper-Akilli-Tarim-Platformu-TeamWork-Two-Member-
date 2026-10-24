import 'package:flutter/material.dart';

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
    final unit = product?.unit ?? 'Birim';
    final price = product?.unitPrice;
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
                    Text(
                      product != null
                          ? product!.title
                          : 'Kaldırılmış Ürün (#${offer.productId})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: FarmColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Teklif Tarihi: ${_formatDate(offer.createdAt)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: FarmColors.ink.withAlpha(160),
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
              color: const Color(0xFFF7F4EC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2DDD1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Talep Edilen Miktar',
                      style: TextStyle(
                        fontSize: 11,
                        color: FarmColors.ink.withAlpha(160),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${offer.requestedQuantity.toStringAsFixed(1)} $unit',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: FarmColors.forest,
                      ),
                    ),
                  ],
                ),
                if (totalEstimated != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Tahmini Tutar',
                        style: TextStyle(
                          fontSize: 11,
                          color: FarmColors.ink.withAlpha(160),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₺${totalEstimated.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: FarmColors.gold,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded,
                  size: 16, color: FarmColors.forest),
              const SizedBox(width: 6),
              Text(
                offer.buyerName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: FarmColors.ink,
                ),
              ),
              if (offer.buyerPhone.trim().isNotEmpty) ...[
                const SizedBox(width: 12),
                const Icon(Icons.phone_outlined,
                    size: 14, color: FarmColors.earth),
                const SizedBox(width: 4),
                Text(
                  offer.buyerPhone,
                  style: const TextStyle(
                      fontSize: 12,
                      color: FarmColors.earth,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
          if (offer.note.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F7F1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.format_quote_rounded,
                      size: 16, color: FarmColors.gold),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      offer.note,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: FarmColors.ink.withAlpha(190),
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
                    label: const Text('Reddet', style: TextStyle(fontSize: 12)),
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
                    label:
                        const Text('Kabul Et', style: TextStyle(fontSize: 12)),
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
