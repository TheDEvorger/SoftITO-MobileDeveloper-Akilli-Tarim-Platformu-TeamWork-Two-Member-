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
            Expanded(child: _buildTile(items[0])),
            const SizedBox(width: 12),
            Expanded(child: _buildTile(items[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildTile(items[2])),
            const SizedBox(width: 12),
            Expanded(child: _buildTile(items[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildTile((IconData, String, String, Color) item) {
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
              Icon(item.$1, color: item.$4, size: 32),
              const SizedBox(height: 11),
              Text(
                item.$2,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 5),
              const Icon(Icons.arrow_forward, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
