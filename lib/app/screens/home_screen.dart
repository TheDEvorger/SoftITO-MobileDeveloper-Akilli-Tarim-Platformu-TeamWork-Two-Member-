import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../core/models/product.dart';
import '../app_scope.dart';
import '../app_theme.dart';
import '../widgets/farm_card.dart';
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
            Flexible(child: Text('Bereket Ovası', overflow: TextOverflow.ellipsis)),
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
            _HarvestHero(onExplore: () => Navigator.pushNamed(context, '/marketplace')),
            const SizedBox(height: 22),
            Text('Toprağın bereketi, cebinde.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800)),
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
            _FeatureGrid(onOpen: (route) => Navigator.pushNamed(context, route)),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(child: Text('Pazardan seçmeler',
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
                  return const FarmCard(child: Text('Henüz örnek ürün bulunmuyor.'));
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
                  Expanded(child: Text('Canlı sunucu ve fiziksel sensör bağlı değil. '
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
          const routes = ['/marketplace', '/farm', '/services', '/offers', '/profile'];
          Navigator.pushNamed(context, routes[index]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront_outlined), label: 'Pazar'),
          NavigationDestination(icon: Icon(Icons.agriculture_outlined), label: 'Çiftlik'),
          NavigationDestination(icon: Icon(Icons.support_agent), label: 'Hizmet'),
          NavigationDestination(icon: Icon(Icons.mail_outline), label: 'Talep'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}

class _HarvestHero extends StatelessWidget {
  const _HarvestHero({required this.onExplore});
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: SizedBox(
          height: 234,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset('assets/images/harvest_hero.png', fit: BoxFit.cover),
              const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xED17392E), Color(0xB7214334), Color(0x0017392E)],
              ))),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 265),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🌾 BEREKETİN YOLCULUĞU',
                            style: TextStyle(color: Color(0xFFF6D78F),
                                fontWeight: FontWeight.w700, fontSize: 12)),
                        const SizedBox(height: 8),
                        Text('Tarladan sofraya',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 6),
                        const Text('Üretici ve alıcıyı aynı ovada buluşturan yeni deneyim.',
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 12),
                        FilledButton.tonalIcon(
                          onPressed: onExplore,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Pazarı keşfet'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFF7E8BD),
                            foregroundColor: FarmColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({required this.onOpen});
  final ValueChanged<String> onOpen;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final itemWidth = (width - 44) / 2;
    const items = [
      (Icons.storefront, 'Pazar', '/marketplace', FarmColors.forest),
      (Icons.pets_outlined, 'Hayvan ve sera', '/farm', FarmColors.olive),
      (Icons.local_shipping_outlined, 'Hizmet rehberi', '/services', FarmColors.earth),
      (Icons.markunread_mailbox_outlined, 'Talepler', '/offers', FarmColors.gold),
    ];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final item in items)
          SizedBox(
            width: itemWidth,
            child: Semantics(
              button: true,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => onOpen(item.$3),
                child: FarmCard(
                  padding: const EdgeInsets.all(13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(item.$1, color: item.$4, size: 32),
                      const SizedBox(height: 11),
                      Text(item.$2,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 5),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
