import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/widgets/farm_card.dart';
import '../../../../core/models/service_provider.dart';
import 'service_call_helper.dart';

class ServiceProviderCard extends StatelessWidget {
  const ServiceProviderCard({
    super.key,
    required this.provider,
  });

  final ServiceProvider provider;

  (String, IconData, Color) _getTypeInfo(String type) {
    switch (type.toLowerCase()) {
      case 'veterinary':
        return (
          'Veteriner Hekim',
          Icons.medical_services_rounded,
          const Color(0xFF2E7D32)
        );
      case 'tractor':
        return (
          'Traktör Kiralama',
          Icons.agriculture_rounded,
          const Color(0xFFB88422)
        );
      case 'harvester':
        return (
          'Biçerdöver',
          Icons.precision_manufacturing_rounded,
          const Color(0xFF75503B)
        );
      case 'logistics':
        return (
          'Ürün Nakliyesi',
          Icons.local_shipping_rounded,
          const Color(0xFF1565C0)
        );
      default:
        return ('Tarım Desteği', Icons.build_circle_rounded, FarmColors.forest);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (typeLabel, typeIcon, typeColor) = _getTypeInfo(provider.type);
    final hasPhone = provider.phone.trim().isNotEmpty;

    return FarmCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: typeColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: typeColor.withAlpha(80)),
                      ),
                      child: Icon(typeIcon, color: typeColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: FarmColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 14, color: FarmColors.earth),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${provider.city} / ${provider.district}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: FarmColors.earth,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: typeColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: typeColor.withAlpha(70)),
                ),
                child: Text(
                  typeLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: typeColor,
                  ),
                ),
              ),
            ],
          ),
          if (provider.description.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              provider.description,
              style: TextStyle(
                fontSize: 13,
                color: FarmColors.ink.withAlpha(200),
                height: 1.35,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.phone_outlined,
                    size: 15,
                    color: hasPhone
                        ? FarmColors.forest
                        : FarmColors.ink.withAlpha(120),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    hasPhone ? provider.phone : 'Telefon belirtilmemiş',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: hasPhone
                          ? FarmColors.ink
                          : FarmColors.ink.withAlpha(120),
                    ),
                  ),
                ],
              ),
              FilledButton.icon(
                onPressed: hasPhone
                    ? () => ServiceCallHelper.callPhone(context, provider.phone)
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: FarmColors.forest,
                  disabledBackgroundColor: const Color(0xFFD4CEC1),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: const Size(40, 38),
                ),
                icon: const Icon(Icons.call_rounded, size: 16),
                label: const Text(
                  'Hemen Ara',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
