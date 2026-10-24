import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import 'rustic_ornament.dart';

class FarmSummaryHeader extends StatelessWidget {
  const FarmSummaryHeader({
    super.key,
    required this.animalCount,
    required this.vaccinatedCount,
    required this.greenhouseCount,
    required this.onAddAnimalPressed,
  });

  final int animalCount;
  final int vaccinatedCount;
  final int greenhouseCount;
  final VoidCallback onAddAnimalPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B3D32), FarmColors.forest, Color(0xFF2C5E4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x28214A3D),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
        border: Border.all(color: FarmColors.gold.withAlpha(120), width: 1.4),
      ),
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
                      color: FarmColors.gold.withAlpha(45),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: FarmColors.gold.withAlpha(100)),
                    ),
                    child: const Icon(
                      Icons.agriculture_rounded,
                      color: Color(0xFFFFDF9E),
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bereket Çiftliği',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: FarmColors.milk,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        'Sürü & Sera Operasyon Merkezi',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFD4E3D8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              FilledButton.icon(
                onPressed: onAddAnimalPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: FarmColors.gold,
                  foregroundColor: FarmColors.ink,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text(
                  'Hayvan Ekle',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Başak korniş süslemesi
          SizedBox(
            height: 12,
            width: double.infinity,
            child: CustomPaint(
              painter: WheatCornicePainter(color: FarmColors.gold),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.pets_rounded,
                  label: 'Kayıtlı Sürü',
                  value: '$animalCount Baş',
                  color: const Color(0xFFFFE0A3),
                ),
              ),
              Container(
                height: 36,
                width: 1,
                color: Colors.white.withAlpha(40),
              ),
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.medical_services_outlined,
                  label: 'Aşı Kaydı',
                  value: '$vaccinatedCount Hayvan',
                  color: const Color(0xFFA5D6A7),
                ),
              ),
              Container(
                height: 36,
                width: 1,
                color: Colors.white.withAlpha(40),
              ),
              Expanded(
                child: _buildMetricItem(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Aktif Sera',
                  value: '$greenhouseCount Ünite',
                  color: const Color(0xFF80DEEA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(190),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
