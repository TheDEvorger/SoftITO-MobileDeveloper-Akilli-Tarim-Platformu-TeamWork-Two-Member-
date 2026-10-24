import 'package:flutter/material.dart';

import '../app_theme.dart';

class FarmCard extends StatelessWidget {
  const FarmCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: FarmColors.milk,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFD9D6C8)),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0F214A3D), blurRadius: 16, offset: Offset(0, 5)),
          ],
        ),
        child: child,
      );
}
