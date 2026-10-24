import 'package:flutter/material.dart';

import '../features/marketplace/presentation/screens/add_product_screen.dart';
import '../features/marketplace/presentation/screens/marketplace_screen.dart';
import '../features/marketplace/presentation/screens/product_detail_screen.dart';
import 'screens/feature_coming_screen.dart';
import 'screens/profile_mode_preview.dart';

/// Tek rota merkezi. Gerçek feature ekranları bu switch'e bağlanacak.
/// Emirhan kendi feature dosyalarını yazacak; router'ı Ayberk güncelleyecek.
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
        page = const FeatureComingScreen(
            title: 'Hayvan ve sera takibi',
            owner: 'Emirhan',
            icon: Icons.pets_outlined);
      case services:
        page = const FeatureComingScreen(
            title: 'Hizmet rehberi',
            owner: 'Emirhan',
            icon: Icons.local_shipping_outlined);
      case offers:
        page = const FeatureComingScreen(
            title: 'Gelen teklifler',
            owner: 'Emirhan',
            icon: Icons.mail_outline);
      case offerForm:
        page = const FeatureComingScreen(
            title: 'Teklif gönderme',
            owner: 'Emirhan',
            icon: Icons.send_outlined);
      case profile:
        page = const ProfileModePreview();
      default:
        page = const FeatureComingScreen(
            title: 'Sayfa bulunamadı',
            owner: 'Ortak ekip',
            icon: Icons.search_off);
    }
    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}
