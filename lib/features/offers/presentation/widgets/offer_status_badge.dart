import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';

class OfferStatusBadge extends StatelessWidget {
  const OfferStatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  (String, Color, Color, IconData) _getInfo(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return (
          'Kabul Edildi',
          const Color(0xFF2E7D32),
          const Color(0xFFE8F5E9),
          Icons.check_circle_outline_rounded
        );
      case 'rejected':
        return (
          'Reddedildi',
          FarmColors.alert,
          const Color(0xFFFFEBEE),
          Icons.cancel_outlined
        );
      case 'pending':
      default:
        return (
          'Cevap Bekliyor',
          const Color(0xFFB88422),
          const Color(0xFFFFF8E1),
          Icons.hourglass_empty_rounded
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (label, textColor, bgColor, icon) = _getInfo(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withAlpha(90)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
