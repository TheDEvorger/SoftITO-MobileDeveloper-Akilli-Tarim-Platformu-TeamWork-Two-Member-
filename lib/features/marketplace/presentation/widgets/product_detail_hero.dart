import 'package:flutter/material.dart';

import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/app_translations.dart';
import 'package:akilli_tarim_platformu/app/widgets/product_artwork.dart';
import 'package:akilli_tarim_platformu/core/models/product.dart';

class ProductDetailHero extends StatelessWidget {
  const ProductDetailHero({
    super.key,
    required this.product,
    required this.onBack,
  });

  final Product product;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: ProductArtwork(
            imagePath: product.imagePath,
            height: 280,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          child: CircleAvatar(
            backgroundColor: (isDark ? FarmDarkColors.surfaceElevated : FarmColors.milk)
                .withValues(alpha: 0.9),
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: isDark ? FarmDarkColors.ink : FarmColors.ink),
              onPressed: onBack,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? FarmDarkColors.forest : FarmColors.forest,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              tr.translateCategory(product.category),
              style: TextStyle(
                color: isDark ? const Color(0xFF0C2419) : Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
