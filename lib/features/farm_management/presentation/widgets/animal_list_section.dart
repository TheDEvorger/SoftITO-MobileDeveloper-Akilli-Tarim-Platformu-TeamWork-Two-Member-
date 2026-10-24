import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/models/animal.dart';
import '../controllers/animal_controller.dart';
import 'animal_card.dart';
import 'animal_detail_sheet.dart';

class AnimalListSection extends StatefulWidget {
  const AnimalListSection({
    super.key,
    required this.controller,
    required this.onAddPressed,
  });

  final AnimalController controller;
  final VoidCallback onAddPressed;

  @override
  State<AnimalListSection> createState() => _AnimalListSectionState();
}

class _AnimalListSectionState extends State<AnimalListSection> {
  String _selectedFilter = 'all';

  void _showDetail(Animal animal) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AnimalDetailSheet(
        animal: animal,
        onDelete: () async {
          await widget.controller.removeAnimal(animal.id);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${animal.earTag} kaydı silindi.'),
                backgroundColor: FarmColors.alert,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final allAnimals = widget.controller.animals;

        final filtered = allAnimals.where((a) {
          if (_selectedFilter == 'all') {
            return true;
          }
          if (_selectedFilter == 'pregnant') {
            return a.pregnancyStatus == 'pregnant';
          }
          if (_selectedFilter == 'vaccinated') {
            return a.lastVaccinationDate.trim().isNotEmpty &&
                a.lastVaccinationDate != '-';
          }
          return true;
        }).toList();

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
                        'Kayıtlı Hayvanlar',
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
                          color: FarmColors.forest.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${allAnimals.length} Baş',
                          style: const TextStyle(
                            fontSize: 11,
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
            const SizedBox(height: 10),
            // Hızlı filtre çipleri
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildChip('all', 'Tümü (${allAnimals.length})'),
                  const SizedBox(width: 8),
                  _buildChip('pregnant',
                      'Gebeler (${widget.controller.pregnantCount})'),
                  const SizedBox(width: 8),
                  _buildChip('vaccinated',
                      'Aşılı (${widget.controller.vaccinatedCount})'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (filtered.isEmpty)
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: FarmColors.milk,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD9D6C8)),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.pets_outlined,
                          size: 48, color: FarmColors.ink.withAlpha(90)),
                      const SizedBox(height: 12),
                      const Text(
                        'Bu kritere uygun hayvan kaydı yok',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: FarmColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Yeni hayvan kaydı ekleyerek sürünüzü takip edebilirsiniz.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: FarmColors.ink.withAlpha(160),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: widget.onAddPressed,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('İlk Hayvanı Ekle'),
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
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return AnimalCard(
                    animal: filtered[index],
                    onTap: () => _showDetail(filtered[index]),
                  );
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildChip(String filterKey, String label) {
    final isSelected = _selectedFilter == filterKey;
    return ChoiceChip(
      selected: isSelected,
      label: Text(label),
      selectedColor: FarmColors.forest,
      backgroundColor: FarmColors.milk,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isSelected ? Colors.white : FarmColors.ink,
      ),
      onSelected: (_) => setState(() => _selectedFilter = filterKey),
    );
  }
}
