import 'package:flutter/material.dart';

import '../app_theme.dart';

class FarmCard extends StatelessWidget {
  const FarmCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? FarmDarkColors.surface : FarmColors.milk,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? FarmDarkColors.border : const Color(0xFFD9D6C8),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x33000000) : const Color(0x0F214A3D),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
