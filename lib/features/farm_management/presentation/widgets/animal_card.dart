import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
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

  (String, Color, Color, IconData) _getPregnancyBadge(
    String status,
    AppTranslations tr,
    bool isDark,
  ) {
    switch (status) {
      case 'pregnant':
        return (
          tr.pregnancyBadgeLabel(status),
          isDark ? const Color(0xFFFBD38D) : const Color(0xFFC05621),
          isDark
              ? const Color(0xFFC05621).withAlpha(55)
              : const Color(0xFFFEEBC8),
          Icons.favorite_rounded
        );
      case 'not_pregnant':
        return (
          tr.pregnancyBadgeLabel(status),
          isDark ? const Color(0xFF90CDF4) : const Color(0xFF2C5282),
          isDark
              ? const Color(0xFF2C5282).withAlpha(55)
              : const Color(0xFFBEE3F8),
          Icons.remove_circle_outline_rounded
        );
      case 'unknown':
      default:
        return (
          tr.pregnancyBadgeLabel(status),
          isDark ? FarmDarkColors.inkMuted : const Color(0xFF4A5568),
          isDark ? FarmDarkColors.surfaceElevated : const Color(0xFFE2E8F0),
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
        lower.contains('büyükbaş') ||
        lower.contains('cow') ||
        lower.contains('kuh') ||
        lower.contains('bull') ||
        lower.contains('stier')) {
      return Icons.pets_rounded;
    } else if (lower.contains('koyun') ||
        lower.contains('kuzu') ||
        lower.contains('keçi') ||
        lower.contains('küçükbaş') ||
        lower.contains('sheep') ||
        lower.contains('schaf') ||
        lower.contains('goat') ||
        lower.contains('ziege')) {
      return Icons.cruelty_free_rounded;
    } else if (lower.contains('tavuk') ||
        lower.contains('horoz') ||
        lower.contains('kanatlı') ||
        lower.contains('chicken') ||
        lower.contains('huhn')) {
      return Icons.egg_rounded;
    }
    return Icons.pets_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (label, textColor, bgColor, icon) =
        _getPregnancyBadge(animal.pregnancyStatus, tr, isDark);

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
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isDark ? FarmDarkColors.forest : FarmColors.forest).withAlpha(isDark ? 40 : 25),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: (isDark ? FarmDarkColors.forest : FarmColors.forest).withAlpha(60),
                          ),
                        ),
                        child: Icon(
                          _getSpeciesIcon(animal.species),
                          color: isDark ? FarmDarkColors.forest : FarmColors.forest,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              animal.earTag,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tr.translateSpecies(animal.species),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? FarmDarkColors.inkMuted : FarmColors.earth,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
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
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? FarmDarkColors.surfaceElevated : const Color(0xFFF0EBE0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event_available_rounded,
                    size: 16,
                    color: isDark ? FarmDarkColors.gold : FarmColors.olive,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    tr.lastVaccineLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      animal.lastVaccinationDate.isEmpty ||
                              animal.lastVaccinationDate == '-'
                          ? tr.noVaccineRecord
                          : animal.lastVaccinationDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: animal.lastVaccinationDate.isEmpty ||
                                animal.lastVaccinationDate == '-'
                            ? FarmColors.alert
                            : (isDark ? FarmDarkColors.forest : FarmColors.forest),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: isDark ? FarmDarkColors.inkMuted : const Color(0xFF888577),
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
