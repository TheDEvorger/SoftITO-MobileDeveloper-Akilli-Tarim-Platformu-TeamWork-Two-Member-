import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';

/// Ekranlarda zarif çiftlik & fantastik kırsal atmosferi sağlayan
/// harici asset gerektirmeyen vektörel bezeme bileşenleri.
class RusticFarmBadge extends StatelessWidget {
  const RusticFarmBadge({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.eco_rounded,
    this.badgeColor = FarmColors.forest,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color badgeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: FarmColors.milk,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FarmColors.gold.withAlpha(90), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F214A3D),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: badgeColor.withAlpha(35),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: badgeColor),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: FarmColors.ink,
                  letterSpacing: 0.2,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: FarmColors.ink.withAlpha(160),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Altın yaldızlı hasat başağı ve kırsal korniş süslemesi (CustomPainter)
class WheatCornicePainter extends CustomPainter {
  WheatCornicePainter({this.color = FarmColors.gold});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withAlpha(140)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withAlpha(70)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.cubicTo(
      size.width * 0.25,
      size.height * 0.1,
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.5,
    );
    canvas.drawPath(path, paint);

    // Başak taneleri
    for (int i = 1; i <= 5; i++) {
      final t = i / 6.0;
      final x = size.width * t;
      final y = size.height * 0.5 + math.sin(t * math.pi) * 2;
      canvas.drawCircle(Offset(x, y - 5), 2.2, fillPaint);
      canvas.drawCircle(Offset(x, y + 5), 2.2, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant WheatCornicePainter oldDelegate) =>
      oldDelegate.color != color;
}
