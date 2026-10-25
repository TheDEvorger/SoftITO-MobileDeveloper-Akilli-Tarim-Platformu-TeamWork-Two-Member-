import 'package:flutter/material.dart';

import '../../../../app/app_translations.dart';
import '../../../../app/app_theme.dart';

class OfferStatusBadge extends StatelessWidget {
  const OfferStatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  (String, Color, Color, IconData) _getInfo(
      String status, AppTranslations tr, bool isDark) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return (
          tr.offerStatusAccepted,
          isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
          isDark ? const Color(0xFF2E7D32).withAlpha(50) : const Color(0xFFE8F5E9),
          Icons.check_circle_outline_rounded
        );
      case 'rejected':
        return (
          tr.offerStatusRejected,
          isDark ? const Color(0xFFEF9A9A) : FarmColors.alert,
          isDark ? FarmColors.alert.withAlpha(50) : const Color(0xFFFFEBEE),
          Icons.cancel_outlined
        );
      case 'pending':
      default:
        return (
          tr.offerStatusPending,
          isDark ? FarmDarkColors.gold : const Color(0xFF7A4F01),
          isDark ? FarmDarkColors.gold.withAlpha(45) : const Color(0xFFFFF6DF),
          Icons.hourglass_empty_rounded
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (label, textColor, bgColor, icon) = _getInfo(status, tr, isDark);

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
