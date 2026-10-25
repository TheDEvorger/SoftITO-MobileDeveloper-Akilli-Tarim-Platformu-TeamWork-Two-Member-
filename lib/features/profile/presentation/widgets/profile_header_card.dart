import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key, this.isProducer = true});

  final bool isProducer;

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: FarmColors.forest.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Fantastik Banner Arka Planı
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 140,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/fantasy_farm_banner.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [FarmColors.forest, Color(0xFF2C5E4E)],
                      ),
                    ),
                  ),
                ),
              ),
              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withAlpha(60),
                        Colors.transparent,
                        Colors.black.withAlpha(120),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              // Sağ üst rozet (Efsanevi Üretici)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(140),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isProducer
                          ? FarmColors.gold.withAlpha(200)
                          : const Color(0xFF66BB6A),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isProducer
                            ? Icons.workspace_premium_rounded
                            : Icons.shopping_basket_rounded,
                        size: 15,
                        color: isProducer
                            ? FarmColors.gold
                            : const Color(0xFFA5D6A7),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isProducer ? tr.legendaryFarmer : tr.naturalProduceExplorer,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Yuvarlak Fantastik Çiftçi Avatarı
              Positioned(
                bottom: -46,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [FarmColors.gold, FarmColors.forest],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: FarmColors.forest.withAlpha(90),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      const CircleAvatar(
                        radius: 44,
                        backgroundImage:
                            AssetImage('assets/images/fantastic_farmer.jpg'),
                        backgroundColor: FarmColors.forest,
                      ),
                      // Aktif Çevrim İçi Rozeti
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2ECC71),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 54),

          // Profil Bilgileri
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const Text(
                  'Hüsnü Çoban',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: FarmColors.ink,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: isProducer
                        ? FarmColors.forest.withAlpha(20)
                        : FarmColors.gold.withAlpha(25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isProducer
                          ? FarmColors.forest.withAlpha(60)
                          : FarmColors.gold.withAlpha(90),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isProducer
                            ? Icons.shield_rounded
                            : Icons.shopping_bag_outlined,
                        size: 14,
                        color: isProducer
                            ? FarmColors.forest
                            : const Color(0xFF8A6216),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          isProducer
                              ? tr.producerRoleTitleBadge
                              : tr.consumerRoleTitleBadge,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isProducer
                                ? FarmColors.forest
                                : const Color(0xFF8A6216),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'admin@bereketovasi.com  •  +90 (555) 012 34 56',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 15, color: FarmColors.earth),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        isProducer
                            ? tr.producerLocation
                            : tr.consumerLocation,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: FarmColors.earth,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
