import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/app_translations.dart';
import 'package:akilli_tarim_platformu/core/models/product.dart';
import 'package:akilli_tarim_platformu/core/models/user_role.dart';

class ProductDetailActionBar extends StatelessWidget {
  const ProductDetailActionBar({
    super.key,
    required this.product,
    required this.role,
    required this.onMakeOffer,
    this.onViewOffers,
    this.onManageStock,
  });

  final Product product;
  final UserRole role;
  final VoidCallback onMakeOffer;
  final VoidCallback? onViewOffers;
  final VoidCallback? onManageStock;

  Future<void> _makePhoneCall(BuildContext context, AppTranslations tr) async {
    final phone = product.sellerPhone.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr.noPhoneProvided)),
      );
      return;
    }
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr.callFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final hasPhone = product.sellerPhone.trim().isNotEmpty;
    final isOwnProduct = product.sellerId == 'demo_producer_001';
    final isProducer = role == UserRole.producer;

    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: const BoxDecoration(
        color: FarmColors.milk,
        border: Border(top: BorderSide(color: Color(0xFFD9D6C8))),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F214A3D),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (isProducer && isOwnProduct)
            OutlinedButton.icon(
              onPressed: onManageStock,
              icon: const Icon(Icons.inventory_2_outlined, size: 18),
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(tr.stock),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: FarmColors.forest,
                side: const BorderSide(color: FarmColors.forest, width: 1.5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: hasPhone ? () => _makePhoneCall(context, tr) : null,
              icon: const Icon(Icons.phone_outlined, size: 18),
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(tr.call),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: FarmColors.forest,
                side: const BorderSide(color: FarmColors.forest, width: 1.5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: (isProducer && isOwnProduct)
                ? FilledButton.icon(
                    onPressed: onViewOffers,
                    icon: const Icon(Icons.mark_email_unread_outlined, size: 18),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(tr.btnViewIncomingOffers),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: FarmColors.forest,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 13),
                    ),
                  )
                : FilledButton.icon(
                    onPressed: onMakeOffer,
                    icon: const Icon(Icons.handshake_outlined, size: 18),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(tr.marketMakeOffer),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFB88422),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 13),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
