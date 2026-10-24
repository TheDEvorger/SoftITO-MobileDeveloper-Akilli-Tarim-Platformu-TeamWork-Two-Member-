import 'package:akilli_tarim_platformu/core/models/product.dart';

class MarketplaceFilter {
  const MarketplaceFilter({
    this.searchQuery = '',
    this.category = 'Tümü',
    this.city = 'Tümü',
  });

  final String searchQuery;
  final String category;
  final String city;

  MarketplaceFilter copyWith({
    String? searchQuery,
    String? category,
    String? city,
  }) =>
      MarketplaceFilter(
        searchQuery: searchQuery ?? this.searchQuery,
        category: category ?? this.category,
        city: city ?? this.city,
      );

  bool matches(Product product) {
    if (category != 'Tümü' &&
        product.category.toLowerCase() != category.toLowerCase()) {
      return false;
    }
    if (city != 'Tümü' && product.city.toLowerCase() != city.toLowerCase()) {
      return false;
    }
    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      final titleMatch = product.title.toLowerCase().contains(query);
      final descMatch = product.description.toLowerCase().contains(query);
      final districtMatch = product.district.toLowerCase().contains(query);
      if (!titleMatch && !descMatch && !districtMatch) return false;
    }
    return true;
  }
}
