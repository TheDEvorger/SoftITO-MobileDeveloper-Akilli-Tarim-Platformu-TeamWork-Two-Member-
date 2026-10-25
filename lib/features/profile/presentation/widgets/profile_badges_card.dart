import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';

class ProfileBadgesCard extends StatelessWidget {
  const ProfileBadgesCard({super.key, this.isProducer = true});

  final bool isProducer;

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final badges = isProducer
        ? [
            (
              Icons.auto_awesome_rounded,
              tr.badgeHarvestTitle,
              FarmColors.gold,
              tr.badgeHarvestDesc,
            ),
            (
              Icons.biotech_rounded,
              tr.badgeGreenhouseTitle,
              FarmColors.forest,
              tr.badgeGreenhouseDesc,
            ),
            (
              Icons.water_drop_rounded,
              tr.badgeDripTitle,
              const Color(0xFF0288D1),
              tr.badgeDripDesc,
            ),
            (
              Icons.verified_rounded,
              tr.badgeOrganicTitle,
              const Color(0xFF388E3C),
              tr.badgeOrganicDesc,
            ),
          ]
        : [
            (
              Icons.workspace_premium_rounded,
              tr.badgeFieldToTableTitle,
              FarmColors.gold,
              tr.badgeFieldToTableDesc,
            ),
            (
              Icons.verified_user_rounded,
              tr.badgeReliableBuyerTitle,
              FarmColors.forest,
              tr.badgeReliableBuyerDesc,
            ),
            (
              Icons.eco_rounded,
              tr.badgeZeroWasteTitle,
              const Color(0xFF388E3C),
              tr.badgeZeroWasteDesc,
            ),
            (
              Icons.favorite_rounded,
              tr.badgeRegionalSupportTitle,
              const Color(0xFFD81B60),
              tr.badgeRegionalSupportDesc,
            ),
          ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeGold = isDark ? FarmDarkColors.gold : FarmColors.gold;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? FarmDarkColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? FarmDarkColors.border : FarmColors.gold.withAlpha(50),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0x33000000)
                : FarmColors.gold.withAlpha(15),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.military_tech_rounded,
                  color: activeGold, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isProducer
                      ? tr.producerBadgesTitle
                      : tr.consumerBadgesTitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final (icon, title, color, desc) in badges)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _buildBadge(
                      icon: icon,
                      title: title,
                      color: isDark ? _adaptBadgeColor(color) : color,
                      description: desc,
                      isDark: isDark,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String title,
    required Color color,
    required String description,
    required bool isDark,
  }) {
    return Tooltip(
      message: description,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(isDark ? 40 : 20),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(isDark ? 120 : 80), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _adaptBadgeColor(Color c) {
    if (c == FarmColors.gold) return FarmDarkColors.gold;
    if (c == FarmColors.forest) return FarmDarkColors.forest;
    if (c == const Color(0xFF2E7D32)) return const Color(0xFF66BB6A);
    if (c == const Color(0xFFD81B60)) return const Color(0xFFF06292);
    return c;
  }
}
