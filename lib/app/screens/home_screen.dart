import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../features/farm_management/farm_management.dart';
import '../../features/marketplace/presentation/screens/marketplace_screen.dart';
import '../../features/offers/offers.dart';
import '../../features/profile/profile.dart';
import '../../features/services/services.dart';
import '../app_scope.dart';
import '../app_theme.dart';
import '../app_translations.dart';
import '../widgets/farm_card.dart';
import '../widgets/harvest_hero.dart';
import '../widgets/home_feature_grid.dart';
import '../widgets/main_tab_scope.dart';
import '../widgets/product_preview_card.dart';

/// Kalıcı (persistent) alt navigasyon çubuğu barındıran ana ekran kabuğu.
/// Sekmeler arası geçişlerde alt menü asla kaybolmaz ve sayfaların durumu (IndexedStack) korunur.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 4);
  }

  void _switchTab(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index.clamp(0, 4));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final listenables = <Listenable>[
      scope.roleController,
      if (scope.languageController != null) scope.languageController!,
      if (scope.themeController != null) scope.themeController!,
    ];

    return AnimatedBuilder(
      animation: Listenable.merge(listenables),
      builder: (context, _) {
        final isProducer = scope.roleController.isProducer;
        final tr = AppTranslations.of(context);

        // Üretici: Ana Sayfa (0), İlanlarım (1), Çiftlik (2), Teklifler (3), Profil (4)
        // Tüketici: Ana Sayfa (0), Pazar (1), Tekliflerim (2), Hizmetler (3), Profil (4)
        final pages = isProducer
            ? const [
                HomeFeedView(),
                MarketplaceScreen(),
                FarmDashboardScreen(),
                OffersScreen(),
                ProfileScreen(),
              ]
            : const [
                HomeFeedView(),
                MarketplaceScreen(),
                OffersScreen(),
                ServiceProvidersScreen(),
                ProfileScreen(),
              ];

        final destinations = isProducer
            ? [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                  label: tr.navHome,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.inventory_2_outlined),
                  selectedIcon: const Icon(Icons.inventory_2_rounded),
                  label: tr.navMyListings,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.agriculture_outlined),
                  selectedIcon: const Icon(Icons.agriculture_rounded),
                  label: tr.navFarm,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.markunread_mailbox_outlined),
                  selectedIcon: const Icon(Icons.markunread_mailbox_rounded),
                  label: tr.navOffers,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person_rounded),
                  label: tr.navProfile,
                ),
              ]
            : [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                  label: tr.navHome,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.storefront_outlined),
                  selectedIcon: const Icon(Icons.storefront_rounded),
                  label: tr.navMarket,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.receipt_long_outlined),
                  selectedIcon: const Icon(Icons.receipt_long_rounded),
                  label: tr.navMyOffers,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.local_shipping_outlined),
                  selectedIcon: const Icon(Icons.local_shipping_rounded),
                  label: tr.navServices,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person_rounded),
                  label: tr.navProfile,
                ),
              ];

        return MainTabScope(
          currentIndex: _currentIndex,
          switchTab: _switchTab,
          child: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: pages,
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _switchTab,
              destinations: destinations,
            ),
          ),
        );
      },
    );
  }
}

/// Ana sayfa akış içeriği (Feed)
class HomeFeedView extends StatelessWidget {
  const HomeFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final tabScope = MainTabScope.of(context);
    final tr = AppTranslations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.spa_outlined, color: FarmColors.olive),
            const SizedBox(width: 8),
            Flexible(
                child: Text(tr.appName, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: Listenable.merge([
              if (scope.themeController != null) scope.themeController!,
            ]),
            builder: (context, _) {
              final isDark = scope.themeController?.isDark ??
                  Theme.of(context).brightness == Brightness.dark;
              return IconButton(
                tooltip: tr.themeToggleTooltip,
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
                  color: isDark ? FarmDarkColors.gold : FarmColors.forest,
                ),
                onPressed: () => scope.themeController?.toggleTheme(),
              );
            },
          ),
          AnimatedBuilder(
            animation: Listenable.merge([
              scope.roleController,
              if (scope.languageController != null) scope.languageController!,
              if (scope.themeController != null) scope.themeController!,
            ]),
            builder: (context, _) {
              final activeTr = AppTranslations.of(context);
              return TextButton.icon(
                onPressed: () {
                  if (tabScope != null) {
                    tabScope.switchTab(4);
                  } else {
                    Navigator.pushNamed(context, '/profile');
                  }
                },
                icon: const Icon(Icons.person_outline),
                label: Text(scope.roleController.isProducer
                    ? activeTr.roleProducer
                    : activeTr.roleConsumer),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([
            scope.roleController,
            if (scope.languageController != null) scope.languageController!,
            if (scope.themeController != null) scope.themeController!,
          ]),
          builder: (context, _) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final isProducer = scope.roleController.isProducer;
            final activeTr = AppTranslations.of(context);
            final activeForest =
                isDark ? FarmDarkColors.forest : FarmColors.forest;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                HarvestHero(
                  onExplore: () {
                    if (tabScope != null) {
                      tabScope.switchTab(1);
                    } else {
                      Navigator.pushNamed(context, '/marketplace');
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Rol durum şeridi ve hızlı aksiyonlar
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark
                        ? FarmDarkColors.surfaceElevated
                        : (isProducer
                            ? const Color(0xFFEDF5EE)
                            : const Color(0xFFFFF9ED)),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? FarmDarkColors.border
                          : (isProducer
                              ? FarmColors.forest.withAlpha(50)
                              : FarmColors.gold.withAlpha(90)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isProducer
                                ? Icons.grass_rounded
                                : Icons.shopping_bag_rounded,
                            color: isProducer
                                ? (isDark ? FarmDarkColors.forest : FarmColors.forest)
                                : (isDark ? FarmDarkColors.gold : const Color(0xFFB88422)),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isProducer
                                  ? activeTr.producerPanelBanner
                                  : activeTr.consumerPanelBanner,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isProducer
                                    ? (isDark ? FarmDarkColors.forest : FarmColors.forest)
                                    : (isDark ? FarmDarkColors.ink : FarmColors.ink),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isProducer
                            ? activeTr.producerHomeDesc
                            : activeTr.consumerHomeDesc,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? FarmDarkColors.inkMuted : const Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: isProducer
                              ? [
                                  ActionChip(
                                    avatar: Icon(Icons.add_circle_outline,
                                        size: 16, color: activeForest),
                                    label: Text(activeTr.quickNewAd),
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/add-product'),
                                  ),
                                  const SizedBox(width: 8),
                                  ActionChip(
                                    avatar: Icon(
                                        Icons.markunread_mailbox_outlined,
                                        size: 16,
                                        color: activeForest),
                                    label: Text(activeTr.quickIncomingOffers),
                                    onPressed: () {
                                      if (tabScope != null) {
                                        tabScope.switchTab(3);
                                      } else {
                                        Navigator.pushNamed(context, '/offers');
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  ActionChip(
                                    avatar: Icon(Icons.pets_outlined,
                                        size: 16, color: activeForest),
                                    label: Text(activeTr.quickHerdGreenhouse),
                                    onPressed: () {
                                      if (tabScope != null) {
                                        tabScope.switchTab(2);
                                      } else {
                                        Navigator.pushNamed(context, '/farm');
                                      }
                                    },
                                  ),
                                ]
                              : [
                                  ActionChip(
                                    avatar: Icon(Icons.storefront,
                                        size: 16, color: activeForest),
                                    label: Text(activeTr.quickExploreMarket),
                                    onPressed: () {
                                      if (tabScope != null) {
                                        tabScope.switchTab(1);
                                      } else {
                                        Navigator.pushNamed(
                                            context, '/marketplace');
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  ActionChip(
                                    avatar: Icon(Icons.receipt_long,
                                        size: 16, color: activeForest),
                                    label: Text(activeTr.quickSentOffers),
                                    onPressed: () {
                                      if (tabScope != null) {
                                        tabScope.switchTab(2);
                                      } else {
                                        Navigator.pushNamed(context, '/offers');
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  ActionChip(
                                    avatar: Icon(
                                        Icons.local_shipping_outlined,
                                        size: 16,
                                        color: activeForest),
                                    label: Text(activeTr.quickLogistics),
                                    onPressed: () {
                                      if (tabScope != null) {
                                        tabScope.switchTab(3);
                                      } else {
                                        Navigator.pushNamed(
                                            context, '/services');
                                      }
                                    },
                                  ),
                                ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    const Icon(Icons.apps, color: FarmColors.olive),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isProducer ? activeTr.producerModules : activeTr.consumerModules,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                HomeFeatureGrid(
                  isProducer: isProducer,
                  onOpen: (route) {
                    if (tabScope != null) {
                      if (route == '/marketplace') {
                        tabScope.switchTab(1);
                        return;
                      }
                      if (route == '/farm') {
                        tabScope.switchTab(2);
                        return;
                      }
                      if (route == '/offers') {
                        tabScope.switchTab(isProducer ? 3 : 2);
                        return;
                      }
                      if (route == '/services') {
                        if (!isProducer) {
                          tabScope.switchTab(3);
                          return;
                        }
                      }
                      if (route == '/profile') {
                        tabScope.switchTab(4);
                        return;
                      }
                    }
                    Navigator.pushNamed(context, route);
                  },
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        isProducer
                            ? activeTr.yourListingsHeader
                            : activeTr.freshFromFieldHeader,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (tabScope != null) {
                          tabScope.switchTab(1);
                        } else {
                          Navigator.pushNamed(context, '/marketplace');
                        }
                      },
                      child: Text(isProducer ? activeTr.manageListings : activeTr.seeAll),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<Box<String>>(
                  valueListenable: scope.storage.products.changes,
                  builder: (context, _, __) {
                    final allProducts = scope.storage.products.all();
                    final products = isProducer
                        ? allProducts
                            .where((p) => p.sellerId == 'demo_producer_001')
                            .take(5)
                            .toList()
                        : allProducts
                            .where((p) => p.sellerId != 'demo_producer_001')
                            .take(5)
                            .toList();

                    if (products.isEmpty) {
                      return FarmCard(
                        child: Text(
                          isProducer
                              ? activeTr.noProducerProducts
                              : activeTr.noConsumerProducts,
                          style: TextStyle(
                            color: isDark ? FarmDarkColors.inkMuted : const Color(0xFF4B5563),
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: 245,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) => SizedBox(
                          width: 215,
                          child: ProductPreviewCard(
                            product: products[index],
                            isProducer: isProducer,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 22),
                FarmCard(
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: isDark ? FarmDarkColors.forest : FarmColors.earth,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isProducer
                              ? activeTr.producerHiveNote
                              : activeTr.consumerHiveNote,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isDark ? FarmDarkColors.inkMuted : const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
