import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../core/storage/app_storage.dart';
import 'controllers/services_controller.dart';
import 'widgets/service_category_filter.dart';
import 'widgets/service_city_filter.dart';
import 'widgets/service_provider_card.dart';

class ServiceProvidersScreen extends StatefulWidget {
  const ServiceProvidersScreen({
    super.key,
    this.storage,
  });

  final AppStorage? storage;

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  ServicesController? _controller;
  final _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      final storage = widget.storage ?? AppScope.of(context).storage;
      _controller = ServicesController(repository: storage.serviceProviders);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tarımsal Hizmet Rehberi',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Arama Kutusu
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => _controller!.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Hizmet, veteriner veya makine ara...',
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: FarmColors.forest),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            _controller!.setSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
            ),
            // Kategori Çipleri
            ServiceCategoryFilter(controller: _controller!),
            const SizedBox(height: 10),
            // Şehir Filtresi
            ServiceCityFilter(controller: _controller!),
            const SizedBox(height: 12),
            // Liste
            Expanded(
              child: ListenableBuilder(
                listenable: _controller!,
                builder: (context, _) {
                  final providers = _controller!.filteredProviders;

                  if (providers.isEmpty) {
                    return Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: FarmColors.forest.withAlpha(20),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: FarmColors.forest,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Eşleşen Hizmet Bulunamadı',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: FarmColors.ink,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Seçilen kategori veya şehirde kayıtlı hizmet sağlayıcı bulunmuyor. Farklı arama terimleri deneyebilirsiniz.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: FarmColors.ink.withAlpha(170),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            OutlinedButton.icon(
                              onPressed: () {
                                _searchController.clear();
                                _controller!.resetFilters();
                              },
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Filtreleri Temizle'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: providers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return ServiceProviderCard(provider: providers[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
