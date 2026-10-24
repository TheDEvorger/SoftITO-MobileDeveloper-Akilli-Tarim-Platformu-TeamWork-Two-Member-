import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'farm_card.dart';

class HomeFeatureGrid extends StatelessWidget {
  const HomeFeatureGrid({super.key, required this.onOpen});

  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final itemWidth = (width - 44) / 2;
    const items = [
      (Icons.storefront, 'Pazar', '/marketplace', FarmColors.forest),
      (Icons.pets_outlined, 'Hayvan ve sera', '/farm', FarmColors.olive),
      (
        Icons.local_shipping_outlined,
        'Hizmet rehberi',
        '/services',
        FarmColors.earth
      ),
      (
        Icons.markunread_mailbox_outlined,
        'Talepler',
        '/offers',
        FarmColors.gold
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final item in items)
          SizedBox(
            width: itemWidth,
            child: Semantics(
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
            ),
          ),
      ],
    );
  }
}
