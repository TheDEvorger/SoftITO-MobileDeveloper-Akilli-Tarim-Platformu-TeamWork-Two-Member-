import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../app_scope.dart';
import '../app_theme.dart';
import '../widgets/farm_card.dart';
import '../widgets/harvest_hero.dart';
import '../widgets/home_feature_grid.dart';
import '../widgets/product_preview_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.spa_outlined, color: FarmColors.olive),
            SizedBox(width: 8),
            Flexible(
                child: Text('Bereket Ovası', overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          AnimatedBuilder(
            animation: scope.roleController,
            builder: (context, _) => TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              icon: const Icon(Icons.person_outline),
              label: Text(scope.roleController.role.label),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            HarvestHero(
                onExplore: () => Navigator.pushNamed(context, '/marketplace')),
            const SizedBox(height: 22),
            Text('Toprağın bereketi, cebinde.',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Üretimi yönet, ürün keşfet, yerel ticarete katıl. '
                'Şimdilik tek cihaz üzerinde çalışan demo.'),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.apps, color: FarmColors.olive),
                const SizedBox(width: 8),
                Text('Modüller', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            HomeFeatureGrid(
                onOpen: (route) => Navigator.pushNamed(context, route)),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                    child: Text('Pazardan seçmeler',
                        style: Theme.of(context).textTheme.titleLarge)),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/marketplace'),
                  child: const Text('Tümünü gör'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<Box<String>>(
              valueListenable: scope.storage.products.changes,
              builder: (context, _, __) {
                final products = scope.storage.products.all().take(5).toList();
                if (products.isEmpty) {
                  return const FarmCard(
                      child: Text('Henüz örnek ürün bulunmuyor.'));
                }
                return SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => SizedBox(
                      width: 215,
                      child: ProductPreviewCard(product: products[index]),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 22),
            const FarmCard(
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: FarmColors.earth),
                  SizedBox(width: 12),
                  Expanded(
                      child: Text(
                          'Canlı sunucu ve fiziksel sensör bağlı değil. '
                          'Çiftlik, teklif ve rehber ekranları iki feature dalında geliştirilecek.')),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          const routes = [
            '/marketplace',
            '/farm',
            '/services',
            '/offers',
            '/profile'
          ];
          Navigator.pushNamed(context, routes[index]);
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.storefront_outlined), label: 'Pazar'),
          NavigationDestination(
              icon: Icon(Icons.agriculture_outlined), label: 'Çiftlik'),
          NavigationDestination(
              icon: Icon(Icons.support_agent), label: 'Hizmet'),
          NavigationDestination(icon: Icon(Icons.mail_outline), label: 'Talep'),
          NavigationDestination(
              icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
