import 'package:flutter/material.dart';

import '../../../../app/app_translations.dart';
import '../../../../app/app_theme.dart';
import '../controllers/services_controller.dart';

class ServiceCategoryFilter extends StatelessWidget {
  const ServiceCategoryFilter({
    super.key,
    required this.controller,
  });

  final ServicesController controller;

  static const List<(String, IconData)> _categories = [
    ('all', Icons.apps_rounded),
    ('veterinary', Icons.medical_services_rounded),
    ('tractor', Icons.agriculture_rounded),
    ('harvester', Icons.precision_manufacturing_rounded),
    ('logistics', Icons.local_shipping_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final tr = AppTranslations.of(context);
        final currentType = controller.selectedType;

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final activeForest = isDark ? FarmDarkColors.forest : FarmColors.forest;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: _categories.map((cat) {
              final (typeKey, icon) = cat;
              final label = tr.serviceCategoryLabel(typeKey);
              final isSelected =
                  currentType.toLowerCase() == typeKey.toLowerCase();

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  selected: isSelected,
                  avatar: Icon(
                    icon,
                    size: 16,
                    color: isSelected
                        ? (isDark ? const Color(0xFF0C2419) : Colors.white)
                        : activeForest,
                  ),
                  label: Text(label),
                  selectedColor: activeForest,
                  backgroundColor:
                      isDark ? FarmDarkColors.surface : FarmColors.milk,
                  labelStyle: TextStyle(
                    inherit: false,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? (isDark ? const Color(0xFF0C2419) : Colors.white)
                        : (isDark ? FarmDarkColors.ink : FarmColors.ink),
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? activeForest
                        : (isDark ? FarmDarkColors.border : const Color(0xFFD4CEC1)),
                  ),
                  onSelected: (_) => controller.setSelectedType(typeKey),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
