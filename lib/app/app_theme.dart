import 'package:flutter/material.dart';

abstract final class FarmColors {
  static const forest = Color(0xFF214A3D);
  static const gold = Color(0xFFB88422);
  static const olive = Color(0xFF566D36);
  static const earth = Color(0xFF75503B);
  static const canvas = Color(0xFFF7F1E5);
  static const milk = Color(0xFFFFFDF8);
  static const ink = Color(0xFF1F2721);
  static const alert = Color(0xFFA34422);
}

abstract final class FarmTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: FarmColors.forest,
        brightness: Brightness.light,
      ).copyWith(
        primary: FarmColors.forest,
        onPrimary: Colors.white,
        secondary: FarmColors.olive,
        onSecondary: Colors.white,
        surface: FarmColors.milk,
        onSurface: FarmColors.ink,
        error: FarmColors.alert,
      ),
      scaffoldBackgroundColor: FarmColors.canvas,
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: FarmColors.canvas,
        foregroundColor: FarmColors.ink,
        centerTitle: false,
        elevation: 0,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: FarmColors.ink,
        displayColor: FarmColors.ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FarmColors.milk,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF9FAE9D)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: FarmColors.forest, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: FarmColors.forest,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FarmColors.forest,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: FarmColors.forest),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: const BorderSide(color: Color(0xFFAFB8A8)),
        labelStyle: const TextStyle(color: FarmColors.ink),
      ),
    );
  }
}
