import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../controllers/greenhouse_simulator_controller.dart';
import 'greenhouse_card.dart';

class GreenhouseSection extends StatelessWidget {
  const GreenhouseSection({
    super.key,
    required this.controller,
  });

  final GreenhouseSimulatorController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final greenhouses = controller.greenhouses;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Sera İklim İzleme',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: FarmColors.ink,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: FarmColors.olive.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${greenhouses.length} Ünite',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: FarmColors.olive,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      if (controller.isRunning) {
                        controller.stopSimulation();
                      } else {
                        controller.startSimulation();
                      }
                    },
                    icon: Icon(
                      controller.isRunning
                          ? Icons.pause_circle_outline_rounded
                          : Icons.play_circle_outline_rounded,
                      size: 18,
                      color: FarmColors.forest,
                    ),
                    label: Text(
                      controller.isRunning ? 'Durdur' : 'Canlı Başlat',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: FarmColors.forest,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (greenhouses.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.wb_cloudy_outlined,
                          size: 48, color: FarmColors.ink.withAlpha(90)),
                      const SizedBox(height: 12),
                      const Text(
                        'Kayıtlı sera bulunamadı.',
                        style: TextStyle(
                            color: FarmColors.ink, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                itemCount: greenhouses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return GreenhouseCard(
                    greenhouse: greenhouses[index],
                    isLiveUpdating: controller.isRunning,
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
