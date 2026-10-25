import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../app_translations.dart';
import 'farm_card.dart';

class HomeFeatureGrid extends StatelessWidget {
  const HomeFeatureGrid({
    super.key,
    required this.onOpen,
    this.isProducer = true,
  });

  final ValueChanged<String> onOpen;
  final bool isProducer;

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);

    final List<(IconData, String, String, Color)> items = isProducer
        ? [
            (
              Icons.inventory_2_outlined,
              tr.moduleMyListings,
              '/marketplace',
              FarmColors.forest
            ),
            (Icons.pets_outlined, tr.moduleAnimalsGreenhouse, '/farm', FarmColors.olive),
            (
              Icons.markunread_mailbox_outlined,
              tr.moduleIncomingOffers,
              '/offers',
              FarmColors.gold
            ),
            (
              Icons.local_shipping_outlined,
              tr.moduleServicesGuide,
              '/services',
              FarmColors.earth
            ),
          ]
        : [
            (
              Icons.storefront,
              tr.moduleFreshMarket,
              '/marketplace',
              FarmColors.forest
            ),
            (
              Icons.markunread_mailbox_outlined,
              tr.moduleSentOffers,
              '/offers',
              FarmColors.gold
            ),
            (
              Icons.local_shipping_outlined,
              tr.moduleLogisticsService,
              '/services',
              FarmColors.earth
            ),
            (
              Icons.person_outline,
              tr.moduleBuyerProfile,
              '/profile',
              FarmColors.olive
            ),
          ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTile(context, items[0])),
            const SizedBox(width: 12),
            Expanded(child: _buildTile(context, items[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTile(context, items[2])),
            const SizedBox(width: 12),
            Expanded(child: _buildTile(context, items[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context,
    (IconData, String, String, Color) item,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? _adaptColor(item.$4) : item.$4;

    return Semantics(
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => onOpen(item.$3),
        child: FarmCard(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(item.$1, color: iconColor, size: 32),
              const SizedBox(height: 11),
              Text(
                item.$2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 5),
              Icon(
                Icons.arrow_forward,
                size: 16,
                color: isDark ? FarmDarkColors.inkMuted : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _adaptColor(Color c) {
    if (c == FarmColors.forest) return FarmDarkColors.forest;
    if (c == FarmColors.gold) return FarmDarkColors.gold;
    if (c == FarmColors.olive) return FarmDarkColors.olive;
    if (c == FarmColors.earth) return FarmDarkColors.earth;
    return c;
  }
}
