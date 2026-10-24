import 'package:flutter/material.dart';

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
                      value: selectedCity,
                      icon: const Icon(Icons.arrow_drop_down_rounded,
                          color: FarmColors.forest),
                      items: [
                        const DropdownMenuItem(
                          value: 'all',
                          child: Row(
                            children: [
                              Icon(Icons.map_outlined,
                                  size: 18, color: FarmColors.forest),
                              SizedBox(width: 8),
                              Text('Tüm Şehirler / Bölgeler',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
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
                  tooltip: 'Filtreleri Sıfırla',
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
