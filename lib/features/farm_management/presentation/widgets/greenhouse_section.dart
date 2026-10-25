import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../core/models/greenhouse.dart';
import '../controllers/greenhouse_simulator_controller.dart';
import 'add_greenhouse_sheet.dart';
import 'edit_greenhouse_sheet.dart';
import 'greenhouse_card.dart';

class GreenhouseSection extends StatelessWidget {
  const GreenhouseSection({
    super.key,
    required this.controller,
    this.onAddPressed,
  });

  final GreenhouseSimulatorController controller;
  final VoidCallback? onAddPressed;

  void _openAddSheet(BuildContext context) {
    if (onAddPressed != null) {
      onAddPressed!();
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddGreenhouseSheet(controller: controller),
    );
  }

  void _openEditSheet(BuildContext context, Greenhouse greenhouse) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditGreenhouseSheet(
        greenhouse: greenhouse,
        controller: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);

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
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            tr.greenhouseClimateTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: FarmColors.ink,
                            ),
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
                            '${greenhouses.length} ${tr.unitUnit}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: FarmColors.olive,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        onPressed: () => _openAddSheet(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        icon: const Icon(
                          Icons.add_circle_outline_rounded,
                          size: 16,
                          color: FarmColors.forest,
                        ),
                        label: Text(
                          tr.addGreenhouseBtn,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: FarmColors.forest,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          if (controller.isRunning) {
                            controller.stopSimulation();
                          } else {
                            controller.startSimulation();
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                        icon: Icon(
                          controller.isRunning
                              ? Icons.pause_circle_outline_rounded
                              : Icons.play_circle_outline_rounded,
                          size: 16,
                          color: FarmColors.forest,
                        ),
                        label: Text(
                          controller.isRunning ? tr.simStop : tr.simLive,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: FarmColors.forest,
                          ),
                        ),
                      ),
                    ],
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
                      Text(
                        tr.noGreenhousesFound,
                        style: const TextStyle(
                            color: FarmColors.ink, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => _openAddSheet(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: FarmColors.forest,
                        ),
                        icon: const Icon(Icons.add_rounded),
                        label: Text(tr.addFirstGreenhouseBtn),
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
                  final gh = greenhouses[index];
                  return GreenhouseCard(
                    greenhouse: gh,
                    isLiveUpdating: controller.isRunning,
                    onEdit: () => _openEditSheet(context, gh),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
