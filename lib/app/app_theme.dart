import 'package:flutter/material.dart';

/// Bereket Ovası renk sistemi: Doğa, tarım ve bereket temalı renk paleti.
abstract final class FarmColors {
  // Açık Tema Renkleri
  static const forest = Color(0xFF214A3D);
  static const gold = Color(0xFFB88422);
  static const olive = Color(0xFF566D36);
  static const earth = Color(0xFF75503B);
  static const canvas = Color(0xFFF7F1E5);
  static const milk = Color(0xFFFFFDF8);
  static const ink = Color(0xFF1F2721);
  static const alert = Color(0xFFA34422);

  // Tema duyarlı dinamik erişimciler
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color forestOf(BuildContext context) =>
      isDark(context) ? FarmDarkColors.forest : forest;

  static Color goldOf(BuildContext context) =>
      isDark(context) ? FarmDarkColors.gold : gold;

  static Color oliveOf(BuildContext context) =>
      isDark(context) ? FarmDarkColors.olive : olive;

  static Color earthOf(BuildContext context) =>
      isDark(context) ? FarmDarkColors.earth : earth;

  static Color canvasOf(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  static Color surfaceOf(BuildContext context) =>
      isDark(context) ? FarmDarkColors.surface : milk;

  static Color inkOf(BuildContext context) =>
      isDark(context) ? FarmDarkColors.ink : ink;

  static Color inkMutedOf(BuildContext context) =>
      isDark(context) ? FarmDarkColors.inkMuted : const Color(0xFF6B7280);

  static Color borderOf(BuildContext context) =>
      isDark(context) ? FarmDarkColors.border : const Color(0xFFD9D6C8);

  static Color alertOf(BuildContext context) =>
      isDark(context) ? FarmDarkColors.alert : alert;
}

/// Karanlık Tema Renkleri:
/// - Saf siyah (#000000) ve standart Material grileri KESİNLİKLE YOK.
/// - Arka planlarda koyu yeşil-gri tonları (#121614).
/// - Kart ve form zeminlerinde elementi belirginleştiren antrasit yüzeyler (#1E2420).
/// - Açık temadaki 'Harvest Gold' ve 'Deep Forest'ın WCAG AA kontrastlı aydınlık/pastel varyasyonları.
abstract final class FarmDarkColors {
  // Doğa ve tarım konseptli derin yeşil-gri zemin
  static const canvas = Color(0xFF121614);

  // Kart, form ve bileşen zeminleri için antrasit yüzey
  static const surface = Color(0xFF1E2420);

  // Modal, sheet ve açılır menüler için hafif yükseltilmiş antrasit yüzey
  static const surfaceElevated = Color(0xFF262E29);

  // Antrasit-yeşil belirginleştirici kenarlıklar
  static const border = Color(0xFF2E3A31);
  static const borderSubtle = Color(0xFF232D26);

  // 'Deep Forest' pastel / aydınlık uyarlaması (WCAG AA metin ve ikon kontrastı)
  static const forest = Color(0xFF5DB88E);
  static const forestContainer = Color(0xFF1B3829);

  // 'Harvest Gold' pastel / aydınlık uyarlaması (WCAG AA kontrast oranı > 9.5:1)
  static const gold = Color(0xFFF3C766);
  static const goldContainer = Color(0xFF382E14);

  // Aydınlık Zeytin ve Toprak varyasyonları
  static const olive = Color(0xFF9EBA75);
  static const earth = Color(0xFFB5876B);

  // Yumuşak yeşilimsi açık beyaz birincil metin (WCAG AAA kontrast > 13:1)
  static const ink = Color(0xFFE5EDE7);

  // İkincil yumuşak metin ve açıklama tonu (WCAG AA kontrast > 7:1)
  static const inkMuted = Color(0xFFA5B7AA);

  // Terracotta mercan uyarı rengi (WCAG AA kontrast > 5:1)
  static const alert = Color(0xFFE57352);
}

abstract final class FarmTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
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
      cardColor: FarmColors.milk,
      canvasColor: FarmColors.canvas,
    );

    return base.copyWith(
      cardTheme: CardThemeData(
        color: FarmColors.milk,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFD9D6C8)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: FarmColors.canvas,
        foregroundColor: FarmColors.ink,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: FarmColors.milk,
        surfaceTintColor: Colors.transparent,
        indicatorColor: FarmColors.forest.withAlpha(25),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: FarmColors.forest,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          );
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        modalBackgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: FarmColors.milk,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE5E0D4),
        thickness: 1,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: FarmColors.ink,
        displayColor: FarmColors.ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FarmColors.milk,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FarmColors.forest,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: FarmColors.forest),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: const BorderSide(color: Color(0xFFAFB8A8)),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: FarmDarkColors.forest,
        brightness: Brightness.dark,
      ).copyWith(
        primary: FarmDarkColors.forest,
        onPrimary: const Color(0xFF0C2419),
        primaryContainer: FarmDarkColors.forestContainer,
        onPrimaryContainer: FarmDarkColors.forest,
        secondary: FarmDarkColors.gold,
        onSecondary: const Color(0xFF281E05),
        secondaryContainer: FarmDarkColors.goldContainer,
        onSecondaryContainer: FarmDarkColors.gold,
        tertiary: FarmDarkColors.olive,
        surface: FarmDarkColors.surface,
        onSurface: FarmDarkColors.ink,
        surfaceContainer: FarmDarkColors.surface,
        surfaceContainerHigh: FarmDarkColors.surfaceElevated,
        surfaceContainerHighest: const Color(0xFF2D3830),
        outline: FarmDarkColors.border,
        outlineVariant: FarmDarkColors.borderSubtle,
        error: FarmDarkColors.alert,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: FarmDarkColors.canvas,
      cardColor: FarmDarkColors.surface,
      canvasColor: FarmDarkColors.canvas,
    );

    return base.copyWith(
      cardTheme: CardThemeData(
        color: FarmDarkColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: FarmDarkColors.border),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: FarmDarkColors.canvas,
        foregroundColor: FarmDarkColors.ink,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: FarmDarkColors.ink),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: FarmDarkColors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: FarmDarkColors.forest.withAlpha(45),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: FarmDarkColors.forest,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: FarmDarkColors.inkMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: FarmDarkColors.forest);
          }
          return const IconThemeData(color: FarmDarkColors.inkMuted);
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: FarmDarkColors.surfaceElevated,
        modalBackgroundColor: FarmDarkColors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: FarmDarkColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: FarmDarkColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: FarmDarkColors.border,
        thickness: 1,
      ),
      listTileTheme: const ListTileThemeData(
        textColor: FarmDarkColors.ink,
        iconColor: FarmDarkColors.forest,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: FarmDarkColors.ink,
        displayColor: FarmDarkColors.ink,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FarmDarkColors.surface,
        hintStyle: const TextStyle(color: FarmDarkColors.inkMuted),
        labelStyle: const TextStyle(color: FarmDarkColors.inkMuted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: FarmDarkColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: FarmDarkColors.forest, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: FarmDarkColors.alert),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: FarmDarkColors.alert, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: FarmDarkColors.forest,
          foregroundColor: const Color(0xFF0C2419),
          minimumSize: const Size(48, 48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: FarmDarkColors.forest,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: FarmDarkColors.forest),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: FarmDarkColors.surface,
        selectedColor: FarmDarkColors.forest.withAlpha(50),
        side: const BorderSide(color: FarmDarkColors.border),
      ),
    );
  }
}
