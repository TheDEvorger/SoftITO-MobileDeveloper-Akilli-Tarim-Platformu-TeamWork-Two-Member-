import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../farm_management/presentation/widgets/rustic_ornament.dart';

class RoleExplanationCard extends StatelessWidget {
  const RoleExplanationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: FarmColors.milk,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FarmColors.gold.withAlpha(90)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: FarmColors.gold.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.info_outline_rounded,
                    color: Color(0xFF8A6216), size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Yerel Demo & Veri Kapsamı',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: FarmColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Bu mobil uygulama MVP aşamasında tek cihaz üzerinde Hive veritabanı ile çalışır. İnternet bağlantısı olmadan da verileriniz cihazınızda güvenle saklanır.',
            style: TextStyle(
              fontSize: 12,
              color: FarmColors.ink.withAlpha(190),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '• Üretici kimliği demo_producer_001 olarak temsil edilir.\n• Rol değişimi simülasyon amaçlıdır, anında aktif görünüm filtrelerini uyarlar.',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: FarmColors.ink.withAlpha(170),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 10,
            width: double.infinity,
            child: CustomPaint(
              painter: WheatCornicePainter(color: FarmColors.gold),
            ),
          ),
        ],
      ),
    );
  }
}
