import 'package:flutter/foundation.dart';

import 'package:akilli_tarim_platformu/core/models/product.dart';
import '../../domain/marketplace_filter.dart';

class MarketplaceFilterController extends ChangeNotifier {
  MarketplaceFilter _filter = const MarketplaceFilter();

  MarketplaceFilter get filter => _filter;

  void setSearchQuery(String query) {
    if (_filter.searchQuery == query) return;
    _filter = _filter.copyWith(searchQuery: query);
    notifyListeners();
  }

  void setCategory(String category) {
    if (_filter.category == category) return;
    _filter = _filter.copyWith(category: category);
    notifyListeners();
  }

  void setCity(String city) {
    if (_filter.city == city) return;
    _filter = _filter.copyWith(city: city);
    notifyListeners();
  }

  void reset() {
    if (_filter.category == 'Tümü' &&
        _filter.city == 'Tümü' &&
        _filter.searchQuery.isEmpty) {
      return;
    }
    _filter = const MarketplaceFilter();
    notifyListeners();
  }

  List<Product> apply(List<Product> products) =>
      products.where(_filter.matches).toList();
}
