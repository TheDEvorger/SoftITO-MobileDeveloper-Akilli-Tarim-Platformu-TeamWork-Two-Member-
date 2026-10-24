import 'package:flutter/material.dart';

import 'package:akilli_tarim_platformu/app/app_theme.dart';
import '../../domain/marketplace_filter.dart';

class MarketplaceFilterBar extends StatelessWidget {
  const MarketplaceFilterBar({
    super.key,
    required this.filter,
    required this.categories,
    required this.cities,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onCitySelected,
    required this.onReset,
    required this.resultCount,
  });

  final MarketplaceFilter filter;
  final List<String> categories;
  final List<String> cities;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<String> onCitySelected;
  final VoidCallback onReset;
  final int resultCount;

  @override
  Widget build(BuildContext context) {
    final hasActiveFilter = filter.category != 'Tümü' ||
        filter.city != 'Tümü' ||
        filter.searchQuery.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Ürün, ilçe veya açıklama ara...',
            prefixIcon: const Icon(Icons.search, color: FarmColors.forest),
            suffixIcon: filter.searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () => onSearchChanged(''),
                  )
                : null,
            filled: true,
            fillColor: FarmColors.milk,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final cat in categories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: filter.category == cat,
                    onSelected: (_) => onCategorySelected(cat),
                    selectedColor: const Color(0xFFD3E2CF),
                    labelStyle: TextStyle(
                      color: filter.category == cat
                          ? FarmColors.forest
                          : FarmColors.ink,
                      fontWeight: filter.category == cat
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 20, color: FarmColors.earth),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: FarmColors.milk,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD9D6C8)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: cities.contains(filter.city) ? filter.city : 'Tümü',
                    isExpanded: true,
                    items: [
                      for (final city in cities)
                        DropdownMenuItem(
                          value: city,
                          child: Text(
                            city == 'Tümü' ? 'Tüm Şehirler' : city,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                    ],
                    onChanged: (val) {
                      if (val != null) onCitySelected(val);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (hasActiveFilter)
              TextButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.filter_alt_off_outlined, size: 18),
                label: const Text('Sıfırla'),
                style: TextButton.styleFrom(
                  foregroundColor: FarmColors.alert,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$resultCount ürün listelendi',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: FarmColors.earth,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
