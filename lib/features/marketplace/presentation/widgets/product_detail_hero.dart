import 'package:flutter/material.dart';

import 'package:akilli_tarim_platformu/app/app_theme.dart';
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
            backgroundColor: FarmColors.milk.withValues(alpha: 0.9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: FarmColors.ink),
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
              color: FarmColors.forest,
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
              product.category,
              style: const TextStyle(
                color: Colors.white,
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
