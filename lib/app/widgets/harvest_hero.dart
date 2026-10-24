import 'package:flutter/material.dart';

import '../app_theme.dart';

class HarvestHero extends StatelessWidget {
  const HarvestHero({super.key, required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: SizedBox(
          height: 234,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/harvest_hero.png', fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xED17392E),
                      Color(0xB7214334),
                      Color(0x0017392E),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 265),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '🌾 BEREKETİN YOLCULUĞU',
                          style: TextStyle(
                            color: Color(0xFFF6D78F),
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tarladan sofraya',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Üretici ve alıcıyı aynı ovada buluşturan yeni deneyim.',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.tonalIcon(
                          onPressed: onExplore,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Pazarı keşfet'),
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
            ],
          ),
        ),
      );
}
