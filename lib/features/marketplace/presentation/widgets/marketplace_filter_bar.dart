import 'package:flutter/material.dart';

import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/app_translations.dart';
import '../../domain/marketplace_filter.dart';

class MarketplaceFilterBar extends StatefulWidget {
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
  State<MarketplaceFilterBar> createState() => _MarketplaceFilterBarState();
}

class _MarketplaceFilterBarState extends State<MarketplaceFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.filter.searchQuery);
  }

  @override
  void didUpdateWidget(covariant MarketplaceFilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filter.searchQuery != _searchController.text) {
      _searchController.text = widget.filter.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleReset() {
    _searchController.clear();
    widget.onReset();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final hasActiveFilter = widget.filter.category != 'Tümü' ||
        widget.filter.city != 'Tümü' ||
        widget.filter.searchQuery.isNotEmpty;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeForest = isDark ? FarmDarkColors.forest : FarmColors.forest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() {});
            widget.onSearchChanged(val);
          },
          decoration: InputDecoration(
            hintText: tr.searchHint,
            prefixIcon: Icon(Icons.search, color: activeForest),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                      widget.onSearchChanged('');
                    },
                  )
                : null,
            filled: true,
            fillColor: isDark ? FarmDarkColors.surface : FarmColors.milk,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final cat in widget.categories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tr.translateCategory(cat)),
                    selected: widget.filter.category == cat,
                    onSelected: (_) => widget.onCategorySelected(cat),
                    selectedColor: isDark
                        ? FarmDarkColors.forest.withAlpha(50)
                        : const Color(0xFFD3E2CF),
                    labelStyle: TextStyle(
                      color: widget.filter.category == cat
                          ? activeForest
                          : (isDark ? FarmDarkColors.ink : FarmColors.ink),
                      fontWeight: widget.filter.category == cat
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
            Icon(Icons.location_on_outlined,
                size: 20,
                color: isDark ? FarmDarkColors.earth : FarmColors.earth),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? FarmDarkColors.surface : FarmColors.milk,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? FarmDarkColors.border
                        : const Color(0xFFD9D6C8),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: isDark
                        ? FarmDarkColors.surfaceElevated
                        : FarmColors.milk,
                    value: widget.cities.contains(widget.filter.city)
                        ? widget.filter.city
                        : 'Tümü',
                    isExpanded: true,
                    items: [
                      for (final city in widget.cities)
                        DropdownMenuItem(
                          value: city,
                          child: Text(
                            city == 'Tümü' ? tr.allCitiesLabel : tr.translateCity(city),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                    ],
                    onChanged: (val) {
                      if (val != null) widget.onCitySelected(val);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (hasActiveFilter)
              TextButton.icon(
                onPressed: _handleReset,
                icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                label: Text(tr.filterResetBtn),
                style: TextButton.styleFrom(
                  foregroundColor: FarmColors.alert,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tr.productsListed(widget.resultCount),
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
