import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../core/storage/app_storage.dart';
import 'controllers/animal_controller.dart';
import 'controllers/greenhouse_simulator_controller.dart';
import 'widgets/add_animal_sheet.dart';
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

  @override
  Widget build(BuildContext context) {
    if (_animalController == null || _greenhouseController == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Çiftlik & Üretim Paneli',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Yeni Hayvan Ekle',
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: FarmColors.forest),
            onPressed: _openAddAnimalSheet,
          ),
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
                      color: const Color(0xFFECE7DA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _buildTabButton(0, 'Tüm Tesis'),
                        _buildTabButton(1, 'Sürü Takibi'),
                        _buildTabButton(2, 'Sera Sensörleri'),
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
                  GreenhouseSection(controller: _greenhouseController!),
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
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTabIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? FarmColors.forest : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : FarmColors.ink,
            ),
          ),
        ),
      ),
    );
  }
}
