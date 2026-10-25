import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../app_translations.dart';

class HarvestHero extends StatelessWidget {
  const HarvestHero({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);

    return ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: SizedBox(
          height: 234,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/harvest_hero.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF133329), Color(0xFF2C5E4E)],
                    ),
                  ),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xF5133329),
                      Color(0xCC1A3D30),
                      Color(0x4017392E),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr.harvestHeroTag,
                            style: const TextStyle(
                              color: Color(0xFFF6D78F),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tr.harvestHeroTitle,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              shadows: const [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            tr.harvestHeroDesc,
                            style: const TextStyle(
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.tonalIcon(
                            onPressed: onExplore,
                            icon: const Icon(Icons.arrow_forward),
                            label: Text(tr.harvestHeroAction),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFF7E8BD),
                              foregroundColor: FarmColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
