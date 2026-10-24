import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../app_scope.dart';
import '../app_theme.dart';
import '../widgets/farm_card.dart';
import '../widgets/product_preview_card.dart';

/// Sadece ortak iskeleti göstermek için. Gerçek MarketplaceScreen Ayberk'te.
class MarketplacePreviewScreen extends StatefulWidget {
  const MarketplacePreviewScreen({super.key});

  @override
  State<MarketplacePreviewScreen> createState() => _MarketplacePreviewScreenState();
}

class _MarketplacePreviewScreenState extends State<MarketplacePreviewScreen> {
  String category = 'Tümü';
  String city = 'Tümü';

  @override
  Widget build(BuildContext context) {
    final storage = AppScope.of(context).storage;
    return Scaffold(
      appBar: AppBar(title: const Text('Üretici pazarı')),
      body: SafeArea(
        child: ValueListenableBuilder<Box<String>>(
          valueListenable: storage.products.changes,
          builder: (context, _, __) {
            final all = storage.products.all();
            final categories = {'Tümü', ...all.map((p) => p.category)}.toList();
            final cities = {'Tümü', ...all.map((p) => p.city)}.toList();
            final selectedCategory = categories.contains(category) ? category : 'Tümü';
            final selectedCity = cities.contains(city) ? city : 'Tümü';
            final visible = all.where((p) =>
                (selectedCategory == 'Tümü' || p.category == selectedCategory) &&
                (selectedCity == 'Tümü' || p.city == selectedCity)).toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const FarmCard(
                  child: Row(
                    children: [
                      Icon(Icons.eco_outlined, color: FarmColors.olive),
                      SizedBox(width: 12),
                      Expanded(child: Text('Bu ekran seed/Hive ürün önizlemesidir. '
                          'Gerçek ilan ekleme ve pazar akışı feature/ayberk dalında geliştirilecek.')),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text('Kategori', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final candidate in categories)
                        Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: ChoiceChip(
                            label: Text(candidate),
                            selected: selectedCategory == candidate,
                            onSelected: (_) => setState(() => category = candidate),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 10),
                  Expanded(child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedCity,
                    items: [
                      for (final candidate in cities)
                        DropdownMenuItem(value: candidate, child: Text(candidate)),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => city = value);
                    },
                  )),
                ]),
                const SizedBox(height: 10),
                Text('${visible.length} ürün',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                if (visible.isEmpty)
                  FarmCard(child: Column(
                    children: [
                      const Text('Bu filtrelerle eşleşen ürün bulunamadı.'),
                      TextButton(
                        onPressed: () => setState(() {
                          category = 'Tümü'; city = 'Tümü';
                        }),
                        child: const Text('Filtreleri temizle'),
                      ),
                    ],
                  ))
                else
                  for (final product in visible) ...[
                    ProductPreviewCard(product: product),
                    const SizedBox(height: 12),
                  ],
                const SizedBox(height: 80),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-product'),
        icon: const Icon(Icons.add),
        label: const Text('İlan ekle'),
      ),
    );
  }
}
