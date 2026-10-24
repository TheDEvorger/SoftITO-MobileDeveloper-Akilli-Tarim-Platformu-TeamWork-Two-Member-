import 'dart:io';

import 'package:flutter/material.dart';

import '../app_theme.dart';

class ProductArtwork extends StatelessWidget {
  const ProductArtwork({super.key, required this.imagePath, this.height = 134});

  final String imagePath;
  final double height;

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (imagePath.startsWith('assets/')) {
      image = Image.asset(imagePath, fit: BoxFit.cover, errorBuilder: fallback);
    } else if (imagePath.isNotEmpty) {
      image = Image.file(File(imagePath), fit: BoxFit.cover, errorBuilder: fallback);
    } else {
      image = fallback(context, Object(), null);
    }
    return SizedBox(width: double.infinity, height: height, child: image);
  }

  Widget fallback(BuildContext context, Object error, StackTrace? stack) =>
      Container(
        color: const Color(0xFFE5EBD8),
        child: const Center(child: Icon(Icons.eco_outlined, size: 50, color: FarmColors.olive)),
      );
}
