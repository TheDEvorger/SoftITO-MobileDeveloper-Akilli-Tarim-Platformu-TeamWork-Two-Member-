import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/models/animal.dart';

class AnimalDetailSheet extends StatelessWidget {
  const AnimalDetailSheet({
    super.key,
    required this.animal,
    required this.onDelete,
  });

  final Animal animal;
  final VoidCallback onDelete;

  String _formatPregnancy(String status) {
    switch (status) {
      case 'pregnant':
        return 'Gebe (Doğum takibi önerilir)';
      case 'not_pregnant':
        return 'Gebe Değil';
      case 'unknown':
      default:
        return 'Bilinmiyor / Belirtilmemiş';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: FarmColors.milk,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      animal.earTag,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: FarmColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Sürü Kayıt Kartı · ${animal.species}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: FarmColors.earth,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: FarmColors.ink),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow(
              icon: Icons.tag_rounded,
              title: 'Küpe Numarası',
              value: animal.earTag,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.pets_rounded,
              title: 'Hayvan Türü / Irkı',
              value: animal.species,
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.event_note_rounded,
              title: 'Son Kayıtlı Aşı Tarihi',
              value: animal.lastVaccinationDate.isEmpty ||
                      animal.lastVaccinationDate == '-'
                  ? 'Aşı kaydı girilmemiş'
                  : animal.lastVaccinationDate,
              highlight: animal.lastVaccinationDate.isNotEmpty &&
                  animal.lastVaccinationDate != '-',
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              icon: Icons.favorite_border_rounded,
              title: 'Gebelik Durumu',
              value: _formatPregnancy(animal.pregnancyStatus),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: FarmColors.gold.withAlpha(90)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: FarmColors.gold, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Aşı takvimleri hayvan türüne, mevsime ve ilçe tarım müdürlüğü talimatlarına göre veteriner hekim tarafından belirlenmelidir.',
                      style: TextStyle(
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
                    label: const Text('Kaydı Sil'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Tamam'),
                  ),
                ),
              ],
            ),
          ],
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: FarmColors.ink,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: highlight ? FarmColors.forest : FarmColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
