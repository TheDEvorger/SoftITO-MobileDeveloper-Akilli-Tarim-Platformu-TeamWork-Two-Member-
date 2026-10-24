import 'package:flutter/foundation.dart';

import '../../../../core/models/service_provider.dart';
import '../../../../core/storage/json_box_repository.dart';

class ServicesController extends ChangeNotifier {
  ServicesController({required JsonBoxRepository<ServiceProvider> repository})
      : _repository = repository {
    _listenable = _repository.changes;
    _listenable.addListener(_onStorageChanged);
  }

  final JsonBoxRepository<ServiceProvider> _repository;
  late final ValueListenable<dynamic> _listenable;

  String _searchQuery = '';
  String _selectedType =
      'all'; // all, veterinary, tractor, harvester, logistics
  String _selectedCity = 'all';

  String get searchQuery => _searchQuery;
  String get selectedType => _selectedType;
  String get selectedCity => _selectedCity;

  void _onStorageChanged() {
    notifyListeners();
  }

  List<ServiceProvider> get allProviders => _repository.all();

  List<String> get availableCities {
    final cities = allProviders
        .map((p) => p.city.trim())
        .where((c) => c.isNotEmpty)
        .toSet()
        .toList();
    cities.sort();
    return cities;
  }

  List<ServiceProvider> get filteredProviders {
    return allProviders.where((p) {
      // Tür filtresi
      if (_selectedType != 'all' &&
          p.type.trim().toLowerCase() != _selectedType.toLowerCase()) {
        return false;
      }
      // Şehir filtresi
      if (_selectedCity != 'all' &&
          p.city.trim().toLowerCase() != _selectedCity.toLowerCase()) {
        return false;
      }
      // Arama sorgusu (isim, ilçe, açıklama)
      if (_searchQuery.trim().isNotEmpty) {
        final q = _searchQuery.trim().toLowerCase();
        final matchName = p.name.toLowerCase().contains(q);
        final matchDistrict = p.district.toLowerCase().contains(q);
        final matchCity = p.city.toLowerCase().contains(q);
        final matchDesc = p.description.toLowerCase().contains(q);
        if (!matchName && !matchDistrict && !matchCity && !matchDesc) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedType(String type) {
    if (_selectedType == type) return;
    _selectedType = type;
    notifyListeners();
  }

  void setSelectedCity(String city) {
    if (_selectedCity == city) return;
    _selectedCity = city;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedType = 'all';
    _selectedCity = 'all';
    notifyListeners();
  }

  @override
  void dispose() {
    _listenable.removeListener(_onStorageChanged);
    super.dispose();
  }
}
