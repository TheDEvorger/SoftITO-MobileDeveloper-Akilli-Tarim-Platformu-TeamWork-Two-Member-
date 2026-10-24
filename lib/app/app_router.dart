import 'package:flutter/material.dart';

import '../features/farm_management/farm_management.dart';
import '../features/marketplace/presentation/screens/add_product_screen.dart';
import '../features/marketplace/presentation/screens/marketplace_screen.dart';
import '../features/marketplace/presentation/screens/product_detail_screen.dart';
import '../features/offers/offers.dart';
import '../features/profile/profile.dart';
import '../features/services/services.dart';
import 'screens/feature_coming_screen.dart';

/// Tek rota merkezi. Gerçek feature ekranları bu switch'e bağlandı.
abstract final class AppRoutes {
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
      case marketplace:
        page = const MarketplaceScreen();
      case productDetail:
        page = ProductDetailScreen(
            productId: settings.arguments is String
                ? settings.arguments! as String
                : '');
      case addProduct:
        page = const AddProductScreen();
      case farm:
        page = const FarmDashboardScreen();
      case services:
        page = const ServiceProvidersScreen();
      case offers:
        page = const OffersScreen();
      case offerForm:
        page = OfferFormScreen(
            productId: settings.arguments is String
                ? settings.arguments! as String
                : '');
      case profile:
        page = const ProfileScreen();
      default:
        page = const FeatureComingScreen(
            title: 'Sayfa bulunamadı',
            owner: 'Ortak ekip',
            icon: Icons.search_off);
    }
    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}
