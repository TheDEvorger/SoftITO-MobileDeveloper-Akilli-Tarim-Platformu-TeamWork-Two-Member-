import 'package:flutter/material.dart';

/// Tüm alt widget'ların (Home, Profil, Pazar vb.) alttaki kalıcı navigasyon
/// çubuğundaki sekmeler arasında doğrudan geçiş yapabilmesini sağlayan Scope.
class MainTabScope extends InheritedWidget {
  const MainTabScope({
    super.key,
    required this.currentIndex,
    required this.switchTab,
    required super.child,
  });

  final int currentIndex;
  final void Function(int index) switchTab;

  static MainTabScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MainTabScope>();

  @override
  bool updateShouldNotify(MainTabScope oldWidget) =>
      currentIndex != oldWidget.currentIndex;
}
