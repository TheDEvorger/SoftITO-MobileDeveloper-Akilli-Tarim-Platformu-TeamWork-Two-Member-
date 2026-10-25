import 'dart:async';
import 'package:flutter/material.dart';

import '../app_router.dart';
import '../app_theme.dart';
import '../app_translations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, this.durationSeconds = 3});

  final int durationSeconds;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _animController.forward();

    _navigationTimer = Timer(Duration(seconds: widget.durationSeconds), () {
      _goToLogin();
    });
  }

  void _goToLogin() {
    if (!mounted) return;
    _navigationTimer?.cancel();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              FarmColors.forest,
              Color(0xFF16352B),
              Color(0xFF0F261E),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Sağ üstte hızlı geçiş butonu
              Positioned(
                top: 12,
                right: 16,
                child: TextButton.icon(
                  onPressed: _goToLogin,
                  icon: const Icon(Icons.arrow_forward_rounded,
                      size: 16, color: FarmColors.gold),
                  label: Text(
                    tr.skipBtn,
                    style: const TextStyle(
                      color: FarmColors.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Merkez logo ve metinler
              Center(
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, _) => FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const RadialGradient(
                                colors: [
                                  FarmColors.gold,
                                  FarmColors.olive,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: FarmColors.gold.withAlpha(120),
                                  blurRadius: 32,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.spa_rounded,
                              size: 56,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            tr.appName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            tr.splashSubtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withAlpha(220),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 36),
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FarmColors.gold.withAlpha(230),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            tr.splashLoading,
                            style: TextStyle(
                              color: Colors.white.withAlpha(160),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Alt bilgi
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    tr.splashEcosystemTag,
                    style: TextStyle(
                      color: Colors.white.withAlpha(130),
                      fontSize: 11,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
