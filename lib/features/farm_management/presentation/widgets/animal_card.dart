import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/widgets/farm_card.dart';
import '../../../../core/models/animal.dart';

class AnimalCard extends StatelessWidget {
  const AnimalCard({
    super.key,
    required this.animal,
    required this.onTap,
  });

  final Animal animal;
  final VoidCallback onTap;

  (String, Color, Color, IconData) _getPregnancyBadge(String status) {
    switch (status) {
      case 'pregnant':
        return (
          'Gebe',
          const Color(0xFFC05621),
          const Color(0xFFFEEBC8),
          Icons.favorite_rounded
        );
      case 'not_pregnant':
        return (
          'Gebe Değil',
          const Color(0xFF2C5282),
          const Color(0xFFBEE3F8),
          Icons.remove_circle_outline_rounded
        );
      case 'unknown':
      default:
        return (
          'Bilinmiyor',
          const Color(0xFF4A5568),
          const Color(0xFFE2E8F0),
          Icons.help_outline_rounded
        );
    }
  }

  IconData _getSpeciesIcon(String species) {
    final lower = species.toLowerCase();
    if (lower.contains('inek') ||
        lower.contains('tosun') ||
        lower.contains('düve') ||
        lower.contains('boğa') ||
        lower.contains('büyükbaş')) {
      return Icons.pets_rounded;
    } else if (lower.contains('koyun') ||
        lower.contains('kuzu') ||
        lower.contains('keçi') ||
        lower.contains('küçükbaş')) {
      return Icons.cruelty_free_rounded;
    } else if (lower.contains('tavuk') ||
        lower.contains('horoz') ||
        lower.contains('kanatlı')) {
      return Icons.egg_rounded;
    }
    return Icons.pets_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final (label, textColor, bgColor, icon) =
        _getPregnancyBadge(animal.pregnancyStatus);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: FarmCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: FarmColors.forest.withAlpha(25),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: FarmColors.forest.withAlpha(60),
                        ),
                      ),
                      child: Icon(
                        _getSpeciesIcon(animal.species),
                        color: FarmColors.forest,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.earTag,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: FarmColors.ink,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          animal.species,
                          style: const TextStyle(
                            fontSize: 13,
                            color: FarmColors.earth,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0EBE0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_available_rounded,
                    size: 16,
                    color: FarmColors.olive,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Son Aşı:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: FarmColors.ink,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    animal.lastVaccinationDate.isEmpty ||
                            animal.lastVaccinationDate == '-'
                        ? 'Kayıtlı Aşı Yok'
                        : animal.lastVaccinationDate,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: animal.lastVaccinationDate.isEmpty ||
                              animal.lastVaccinationDate == '-'
                          ? FarmColors.alert
                          : FarmColors.forest,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Color(0xFF888577),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
