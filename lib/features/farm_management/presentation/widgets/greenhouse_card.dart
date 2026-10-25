import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../app/widgets/farm_card.dart';
import '../../../../core/models/greenhouse.dart';

class GreenhouseCard extends StatelessWidget {
  const GreenhouseCard({
    super.key,
    required this.greenhouse,
    this.isLiveUpdating = true,
    this.onEdit,
  });

  final Greenhouse greenhouse;
  final bool isLiveUpdating;
  final VoidCallback? onEdit;

  String _formatTime(String isoTime) {
    try {
      final dt = DateTime.parse(isoTime);
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      final s = dt.second.toString().padLeft(2, '0');
      return '$h:$m:$s';
    } catch (_) {
      return isoTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final temp = greenhouse.temperatureC;
    final hum = greenhouse.humidityPercent;

    // Sıcaklık durumu renk kodlaması (erişilebilir ve yüksek kontrastlı)
    final bool isTempOptimal = temp >= 18.0 && temp <= 28.0;
    final Color tempColor =
        isTempOptimal ? const Color(0xFF2E7D32) : const Color(0xFFC62828);

    // Nem durumu (ideal %55 - %80)
    final bool isHumOptimal = hum >= 55.0 && hum <= 80.0;
    final Color humColor =
        isHumOptimal ? const Color(0xFF0277BD) : const Color(0xFFE65100);

    return FarmCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: FarmColors.olive.withAlpha(30),
                        borderRadius: BorderRadius.circular(14),
                        border:
                            Border.all(color: FarmColors.olive.withAlpha(70)),
                      ),
                      child: const Icon(
                        Icons.wb_twilight_rounded,
                        color: FarmColors.olive,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greenhouse.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: FarmColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: isLiveUpdating
                                      ? Colors.green
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  '${tr.lastUpdateLabel} ${_formatTime(greenhouse.updatedAt)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: FarmColors.ink.withAlpha(160),
                                    fontWeight: FontWeight.w500,
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
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      size: 20, color: FarmColors.forest),
                  tooltip: tr.editDeleteGreenhouseTooltip,
                  onPressed: onEdit,
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Zorunlu "Simüle sensör verisi" uyarısı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: FarmColors.gold.withAlpha(120)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.sensors_rounded, size: 14, color: Color(0xFF8C6400)),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    tr.simulatedSensorNotice,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF8C6400),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Sıcaklık Kartı
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F6EE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5DFC9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.thermostat_rounded,
                              size: 18, color: tempColor),
                          const SizedBox(width: 4),
                          Text(
                            tr.temperatureLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: FarmColors.ink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${temp.toStringAsFixed(1)} °C',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: tempColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isTempOptimal ? tr.optimalClimate : tr.outOfRange,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: tempColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Nem Kartı
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F6EE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5DFC9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.water_drop_rounded,
                              size: 18, color: humColor),
                          const SizedBox(width: 4),
                          Text(
                            tr.humidityLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: FarmColors.ink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '%${hum.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: humColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isHumOptimal ? tr.balancedHumidity : tr.adjustmentNeeded,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: humColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
