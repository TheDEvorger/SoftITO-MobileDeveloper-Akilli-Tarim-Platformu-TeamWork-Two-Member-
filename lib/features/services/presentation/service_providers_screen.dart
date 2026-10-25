import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../app/language_controller.dart';
import '../../../../core/storage/app_storage.dart';
import 'controllers/services_controller.dart';
import 'widgets/service_category_filter.dart';
import 'widgets/service_city_filter.dart';
import 'widgets/service_provider_card.dart';

class ServiceProvidersScreen extends StatefulWidget {
  const ServiceProvidersScreen({
    super.key,
    this.storage,
    this.languageController,
  });

  final AppStorage? storage;
  final AppLanguageController? languageController;

  @override
  State<ServiceProvidersScreen> createState() => _ServiceProvidersScreenState();
}

class _ServiceProvidersScreenState extends State<ServiceProvidersScreen> {
  ServicesController? _controller;
  AppLanguageController? _languageController;
  final _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appScope = AppScope.of(context);
    _languageController ??=
        widget.languageController ?? appScope.languageController;

    if (_controller == null) {
      final storage = widget.storage ?? appScope.storage;
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

    final listenables = <Listenable>[_controller!];
    if (_languageController != null) {
      listenables.add(_languageController!);
    }

    return ListenableBuilder(
      listenable: Listenable.merge(listenables),
      builder: (context, _) {
        final tr = AppTranslations.of(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              tr.servicesTitle,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
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
                    onChanged: (val) {
                      setState(() {});
                      _controller!.setSearchQuery(val);
                    },
                    decoration: InputDecoration(
                      hintText: tr.servicesSearchHint,
                      prefixIcon: Icon(Icons.search_rounded,
                          color: isDark ? FarmDarkColors.forest : FarmColors.forest),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
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
                  child: Builder(
                    builder: (context) {
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
                                    color: (isDark ? FarmDarkColors.forest : FarmColors.forest).withAlpha(isDark ? 40 : 20),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.search_off_rounded,
                                    size: 48,
                                    color: isDark ? FarmDarkColors.forest : FarmColors.forest,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  tr.servicesEmptyTitle,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tr.servicesEmptyDesc,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDark ? FarmDarkColors.inkMuted : FarmColors.ink.withAlpha(170),
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
                                  label: Text(tr.servicesClearFilters),
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
      },
    );
  }
}
