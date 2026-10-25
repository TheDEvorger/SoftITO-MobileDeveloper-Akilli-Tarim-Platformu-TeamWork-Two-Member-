import 'package:flutter/material.dart';

import '../../../../app/app_translations.dart';
import '../../../../app/app_theme.dart';
import '../controllers/services_controller.dart';

class ServiceCityFilter extends StatelessWidget {
  const ServiceCityFilter({
    super.key,
    required this.controller,
  });

  final ServicesController controller;

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final cities = controller.availableCities;
        final selectedCity = controller.selectedCity;

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final activeForest = isDark ? FarmDarkColors.forest : FarmColors.forest;
        final activeEarth = isDark ? FarmDarkColors.earth : FarmColors.earth;
        final activeInk = isDark ? FarmDarkColors.ink : FarmColors.ink;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isDark ? FarmDarkColors.surface : FarmColors.milk,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark
                          ? FarmDarkColors.border
                          : const Color(0xFFD4CEC1),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      dropdownColor: isDark
                          ? FarmDarkColors.surfaceElevated
                          : FarmColors.milk,
                      style: TextStyle(
                        color: activeInk,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      value: (selectedCity == 'all' || cities.contains(selectedCity))
                          ? selectedCity
                          : 'all',
                      icon: Icon(Icons.arrow_drop_down_rounded,
                          color: activeForest),
                      items: [
                        DropdownMenuItem(
                          value: 'all',
                          child: Row(
                            children: [
                              Icon(Icons.map_outlined,
                                  size: 18, color: activeForest),
                              const SizedBox(width: 8),
                              Text(
                                tr.servicesAllCities,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: activeInk,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ...cities.map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Row(
                              children: [
                                Icon(Icons.location_on_outlined,
                                    size: 18, color: activeEarth),
                                const SizedBox(width: 8),
                                Text(
                                  c,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: activeInk,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) controller.setSelectedCity(val);
                      },
                    ),
                  ),
                ),
              ),
              if (selectedCity != 'all' ||
                  controller.selectedType != 'all' ||
                  controller.searchQuery.isNotEmpty) ...[
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: tr.filterResetBtn,
                  style: IconButton.styleFrom(
                    backgroundColor: isDark
                        ? FarmDarkColors.surfaceElevated
                        : const Color(0xFFECE7DA),
                    foregroundColor:
                        isDark ? FarmDarkColors.ink : FarmColors.ink,
                  ),
                  onPressed: () => controller.resetFilters(),
                  icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
