import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../core/models/animal.dart';

class AnimalDetailSheet extends StatelessWidget {
  const AnimalDetailSheet({
    super.key,
    required this.animal,
    required this.onDelete,
    this.onEdit,
  });

  final Animal animal;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: FarmColors.milk,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4CEC1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          animal.earTag,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: FarmColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${tr.animalDetailsTitle} · ${tr.translateSpecies(animal.species)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: FarmColors.earth,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          tooltip: tr.editBtn,
                          onPressed: () {
                            Navigator.of(context).pop();
                            onEdit!();
                          },
                          icon: const Icon(Icons.edit_outlined,
                              color: FarmColors.forest),
                        ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded,
                            color: FarmColors.ink),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 20),
            _buildDetailRow(
              icon: Icons.tag_rounded,
              title: tr.earTagLabel.replaceAll('*', '').trim(),
              value: animal.earTag,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.pets_rounded,
              title: tr.speciesLabel.replaceAll('*', '').trim(),
              value: tr.translateSpecies(animal.species),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.event_note_rounded,
              title: tr.lastVaccineDateLabel,
              value: animal.lastVaccinationDate.isEmpty ||
                      animal.lastVaccinationDate == '-'
                  ? tr.noVaccineRecord
                  : animal.lastVaccinationDate,
              highlight: animal.lastVaccinationDate.isNotEmpty &&
                  animal.lastVaccinationDate != '-',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.favorite_border_rounded,
              title: tr.pregnancyStatusLabel,
              value: tr.pregnancyBadgeLabel(animal.pregnancyStatus),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: FarmColors.gold.withAlpha(90)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: FarmColors.gold, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      tr.vaccineScheduleNotice,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B4E17),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDelete();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: FarmColors.alert,
                      side: const BorderSide(color: FarmColors.alert),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text(tr.deleteBtn),
                  ),
                ),
                if (onEdit != null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onEdit!();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: FarmColors.forest,
                      ),
                      icon: const Icon(Icons.edit_note_rounded, size: 18),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(tr.editBtn),
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(tr.confirm),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F4EC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2DDD1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: FarmColors.forest),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: FarmColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: highlight ? FarmColors.forest : FarmColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
