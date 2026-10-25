import 'package:flutter/material.dart';

import '../features/marketplace/presentation/screens/add_product_screen.dart';
import '../features/marketplace/presentation/screens/product_detail_screen.dart';
import '../features/offers/offers.dart';
import '../features/services/services.dart';
import 'screens/feature_coming_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/splash_screen.dart';

/// Tek rota merkezi. Gerçek feature ekranları bu switch'e bağlandı.
abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const marketplace = '/marketplace';
  static const productDetail = '/product-detail';
  static const addProduct = '/add-product';
  static const farm = '/farm';
  static const services = '/services';
  static const offers = '/offers';
  static const offerForm = '/offer-form';
  static const profile = '/profile';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case splash:
        page = const SplashScreen();
      case login:
        page = const LoginScreen();
      case home:
        final initialIndex =
            settings.arguments is int ? settings.arguments! as int : 0;
        page = HomeScreen(initialIndex: initialIndex);
      case marketplace:
        page = const HomeScreen(initialIndex: 1);
      case productDetail:
        page = ProductDetailScreen(
            productId: settings.arguments is String
                ? settings.arguments! as String
                : '');
      case addProduct:
        page = const AddProductScreen();
      case farm:
        page = const HomeScreen(initialIndex: 2);
      case services:
        page = const ServiceProvidersScreen();
      case offers:
        page = const HomeScreen(initialIndex: 3);
      case offerForm:
        page = OfferFormScreen(
            productId: settings.arguments is String
                ? settings.arguments! as String
                : '');
      case profile:
        page = const HomeScreen(initialIndex: 4);
      default:
        page = const FeatureComingScreen(
            title: '404',
            owner: 'Bereket Ovası',
            icon: Icons.search_off);
    }
    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}
