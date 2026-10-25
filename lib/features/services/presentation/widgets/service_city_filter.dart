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

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: FarmColors.milk,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFD4CEC1)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: (selectedCity == 'all' || cities.contains(selectedCity))
                          ? selectedCity
                          : 'all',
                      icon: const Icon(Icons.arrow_drop_down_rounded,
                          color: FarmColors.forest),
                      items: [
                        DropdownMenuItem(
                          value: 'all',
                          child: Row(
                            children: [
                              const Icon(Icons.map_outlined,
                                  size: 18, color: FarmColors.forest),
                              const SizedBox(width: 8),
                              Text(tr.servicesAllCities,
                                  style:
                                      const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        ...cities.map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 18, color: FarmColors.earth),
                                const SizedBox(width: 8),
                                Text(c,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
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
                    backgroundColor: const Color(0xFFECE7DA),
                    foregroundColor: FarmColors.ink,
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
