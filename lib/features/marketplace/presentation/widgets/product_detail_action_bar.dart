import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/core/models/product.dart';
import 'package:akilli_tarim_platformu/core/models/user_role.dart';

class ProductDetailActionBar extends StatelessWidget {
  const ProductDetailActionBar({
    super.key,
    required this.product,
    required this.role,
    required this.onMakeOffer,
  });

  final Product product;
  final UserRole role;
  final VoidCallback onMakeOffer;

  Future<void> _makePhoneCall(BuildContext context) async {
    final phone = product.sellerPhone.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Satıcı telefon numarası belirtmemiş.')),
      );
      return;
    }
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Arama başlatılamadı.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPhone = product.sellerPhone.trim().isNotEmpty;

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
          OutlinedButton.icon(
            onPressed: hasPhone ? () => _makePhoneCall(context) : null,
            icon: const Icon(Icons.phone_outlined),
            label: const Text('Ara'),
            style: OutlinedButton.styleFrom(
              foregroundColor: FarmColors.forest,
              side: const BorderSide(color: FarmColors.forest, width: 1.5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: role == UserRole.consumer
                ? FilledButton.icon(
                    onPressed: onMakeOffer,
                    icon: const Icon(Icons.handshake_outlined),
                    label: const Text('Teklif Ver'),
                    style: FilledButton.styleFrom(
                      backgroundColor: FarmColors.forest,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  )
                : FilledButton.tonalIcon(
                    onPressed: null,
                    icon: const Icon(Icons.storefront_outlined),
                    label: const Text('Üretici Görünümü'),
                  ),
          ),
        ],
      ),
    );
  }
}
