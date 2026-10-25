import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../core/models/user_role.dart';
import '../../../../core/storage/app_storage.dart';
import 'controllers/animal_controller.dart';
import 'controllers/greenhouse_simulator_controller.dart';
import 'widgets/add_animal_sheet.dart';
import 'widgets/add_greenhouse_sheet.dart';
import 'widgets/animal_list_section.dart';
import 'widgets/farm_summary_header.dart';
import 'widgets/greenhouse_section.dart';

class FarmDashboardScreen extends StatefulWidget {
  const FarmDashboardScreen({
    super.key,
    this.storage,
  });

  final AppStorage? storage;

  @override
  State<FarmDashboardScreen> createState() => _FarmDashboardScreenState();
}

class _FarmDashboardScreenState extends State<FarmDashboardScreen> {
  AnimalController? _animalController;
  GreenhouseSimulatorController? _greenhouseController;
  int _selectedTabIndex = 0; // 0: Genel Bakış, 1: Sürü (Hayvanlar), 2: Seralar

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_animalController == null) {
      final storage = widget.storage ?? AppScope.of(context).storage;
      _animalController = AnimalController(repository: storage.animals);
      _greenhouseController =
          GreenhouseSimulatorController(repository: storage.greenhouses);
    }
  }

  @override
  void dispose() {
    _animalController?.dispose();
    _greenhouseController?.dispose();
    super.dispose();
  }

  void _openAddAnimalSheet() {
    if (_animalController == null) return;
    final scope = AppScope.of(context);
    final tr = AppTranslations.of(context);
    if (!scope.roleController.isProducer) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(tr.producerModeRequiredTitle),
          content: Text(tr.producerModeRequiredDesc),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(tr.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await scope.roleController.setRole(UserRole.producer);
                if (mounted) {
                  _openAddAnimalSheet();
                }
              },
              child: Text(tr.switchToProducerAction),
            ),
          ],
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddAnimalSheet(
        controller: _animalController!,
        onSaved: () => setState(() {}),
      ),
    );
  }

  void _openAddGreenhouseSheet() {
    final roleController = AppScope.of(context).roleController;
    final tr = AppTranslations.of(context);
    if (!roleController.isProducer) {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(tr.producerModeRequiredTitle),
          content: Text(tr.producerModeRequiredDesc),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(tr.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await roleController.setRole(UserRole.producer);
                if (mounted) _openAddGreenhouseSheet();
              },
              child: Text(tr.switchToProducerAction),
            ),
          ],
        ),
      );
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddGreenhouseSheet(
        controller: _greenhouseController!,
        onSaved: () => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_animalController == null || _greenhouseController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final tr = AppTranslations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.farmDashboardTitle,
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          if (_selectedTabIndex == 2)
            IconButton(
              tooltip: tr.tooltipAddGreenhouse,
              icon: const Icon(Icons.add_business_rounded,
                  color: FarmColors.forest),
              onPressed: _openAddGreenhouseSheet,
            )
          else ...[
            IconButton(
              tooltip: tr.tooltipAddAnimal,
              icon: const Icon(Icons.add_circle_outline_rounded,
                  color: FarmColors.forest),
              onPressed: _openAddAnimalSheet,
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: FarmColors.forest,
          onRefresh: () async {
            setState(() {});
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: AppScope.of(context).roleController,
                  builder: (context, _) {
                    final isProducer =
                        AppScope.of(context).roleController.isProducer;
                    if (isProducer) return const SizedBox.shrink();

                    final isDark =
                        Theme.of(context).brightness == Brightness.dark;
                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? FarmDarkColors.surfaceElevated
                            : const Color(0xFFFFF9ED),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: (isDark ? FarmDarkColors.gold : FarmColors.gold)
                              .withAlpha(isDark ? 90 : 90),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: isDark
                                ? FarmDarkColors.gold
                                : const Color(0xFF8A6216),
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              tr.consumerFarmNotice,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? FarmDarkColors.ink
                                    : FarmColors.ink,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                ListenableBuilder(
                  listenable: Listenable.merge(
                      [_animalController!, _greenhouseController!]),
                  builder: (context, _) {
                    return FarmSummaryHeader(
                      animalCount: _animalController!.totalCount,
                      vaccinatedCount: _animalController!.vaccinatedCount,
                      greenhouseCount:
                          _greenhouseController!.greenhouses.length,
                      onAddAnimalPressed: _openAddAnimalSheet,
                    );
                  },
                ),
                const SizedBox(height: 8),
                // Segment Navigasyonu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? FarmDarkColors.surfaceElevated
                          : const Color(0xFFECE7DA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton(0, tr.farmTabOverview),
                        _buildTabButton(1, tr.farmTabHerd),
                        _buildTabButton(2, tr.farmTabGreenhouse),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedTabIndex == 0 || _selectedTabIndex == 1) ...[
                  AnimalListSection(
                    controller: _animalController!,
                    onAddPressed: _openAddAnimalSheet,
                  ),
                  const SizedBox(height: 20),
                ],
                if (_selectedTabIndex == 0 || _selectedTabIndex == 2) ...[
                  GreenhouseSection(
                    controller: _greenhouseController!,
                    onAddPressed: _openAddGreenhouseSheet,
                  ),
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String title) {
    final isSelected = _selectedTabIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTabIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? FarmDarkColors.forest : FarmColors.forest)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? (isDark ? const Color(0xFF0C2419) : Colors.white)
                      : (isDark ? FarmDarkColors.ink : FarmColors.ink),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
