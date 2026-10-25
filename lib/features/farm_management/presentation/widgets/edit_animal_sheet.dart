import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../core/models/animal.dart';
import '../controllers/animal_controller.dart';

class EditAnimalSheet extends StatefulWidget {
  const EditAnimalSheet({
    super.key,
    required this.animal,
    required this.controller,
    required this.onSaved,
  });

  final Animal animal;
  final AnimalController controller;
  final VoidCallback onSaved;

  @override
  State<EditAnimalSheet> createState() => _EditAnimalSheetState();
}

class _EditAnimalSheetState extends State<EditAnimalSheet> {
  late final TextEditingController _earTagController;
  late final TextEditingController _vaccinationDateController;
  late String _selectedSpecies;
  late String _pregnancyStatus;

  String? _errorMessage;
  bool _isSaving = false;

  final List<String> _speciesOptions = const [
    'İnek (Büyükbaş)',
    'Düve (Büyükbaş)',
    'Tosun (Büyükbaş)',
    'Holstein İnek',
    'Koyun (Küçükbaş)',
    'Koyun',
    'Kuzu (Küçükbaş)',
    'Keçi (Küçükbaş)',
    'Manda (Büyükbaş)',
  ];

  @override
  void initState() {
    super.initState();
    _earTagController = TextEditingController(text: widget.animal.earTag);
    final rawDate = widget.animal.lastVaccinationDate.trim();
    _vaccinationDateController =
        TextEditingController(text: rawDate == '-' ? '' : rawDate);

    if (_speciesOptions.contains(widget.animal.species)) {
      _selectedSpecies = widget.animal.species;
    } else {
      _selectedSpecies = 'İnek (Büyükbaş)';
    }

    _pregnancyStatus = widget.animal.pregnancyStatus;
  }

  @override
  void dispose() {
    _earTagController.dispose();
    _vaccinationDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final tr = AppTranslations.of(context);
    final now = DateTime.now();
    DateTime initial = now;
    if (_vaccinationDateController.text.trim().isNotEmpty) {
      try {
        initial = DateTime.parse(_vaccinationDateController.text.trim());
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: tr.pickDateHelp,
      cancelText: tr.cancel,
      confirmText: tr.selectBtn,
    );
    if (picked != null) {
      final y = picked.year.toString().padLeft(4, '0');
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      setState(() {
        _errorMessage = null;
        _vaccinationDateController.text = '$y-$m-$d';
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      _errorMessage = null;
      _isSaving = true;
    });

    final result = await widget.controller.updateAnimal(
      id: widget.animal.id,
      earTag: _earTagController.text,
      species: _selectedSpecies,
      lastVaccinationDate: _vaccinationDateController.text,
      pregnancyStatus: _pregnancyStatus,
    );

    if (!mounted) return;

    if (result.isValid) {
      widget.onSaved();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${_earTagController.text.trim()} OK'),
          backgroundColor: FarmColors.forest,
        ),
      );
    } else {
      setState(() {
        _errorMessage = result.errorMessage;
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: isDark ? FarmDarkColors.surfaceElevated : FarmColors.milk,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: isDark ? const Border(top: BorderSide(color: FarmDarkColors.border)) : null,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isDark ? FarmDarkColors.border : const Color(0xFFD4CEC1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.editAnimalTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.animal.earTag,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? FarmDarkColors.earth : FarmColors.earth,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded,
                        color: isDark ? FarmDarkColors.inkMuted : null),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? FarmDarkColors.alert.withAlpha(35) : const Color(0xFFFFECE5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: FarmDarkColors.alert),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: FarmDarkColors.alert, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tr.translateValidationError(_errorMessage!),
                          style: const TextStyle(
                            color: FarmDarkColors.alert,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],
              Text(
                tr.earTagLabel,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _earTagController,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) {
                  if (_errorMessage != null) {
                    setState(() => _errorMessage = null);
                  }
                },
                decoration: InputDecoration(
                  hintText: tr.earTagHint,
                  prefixIcon: Icon(Icons.tag_rounded,
                      color: isDark ? FarmDarkColors.forest : FarmColors.forest),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                tr.speciesLabel,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedSpecies,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.pets_rounded,
                      color: isDark ? FarmDarkColors.forest : FarmColors.forest),
                ),
                items: _speciesOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(tr.translateSpecies(s))))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSpecies = val);
                },
              ),
              const SizedBox(height: 14),
              Text(
                tr.lastVaccineDateLabel,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _vaccinationDateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: Icon(Icons.calendar_today_rounded,
                      color: isDark ? FarmDarkColors.forest : FarmColors.forest),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () {
                      setState(() {
                        _vaccinationDateController.clear();
                        _errorMessage = null;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                tr.pregnancyStatusLabel,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPregnancyOption('unknown', tr.pregnancyBadgeLabel('unknown'), isDark),
                  const SizedBox(width: 8),
                  _buildPregnancyOption('pregnant', tr.pregnancyBadgeLabel('pregnant'), isDark),
                  const SizedBox(width: 8),
                  _buildPregnancyOption('not_pregnant', tr.pregnancyBadgeLabel('not_pregnant'), isDark),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: _isSaving
                      ? const SizedBox.shrink()
                      : const Icon(Icons.save_rounded, size: 18),
                  label: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(tr.saveBtn),
                  style: FilledButton.styleFrom(
                    backgroundColor: isDark ? FarmDarkColors.forest : FarmColors.forest,
                    foregroundColor: isDark ? const Color(0xFF0C2419) : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPregnancyOption(String value, String label, bool isDark) {
    final isSelected = _pregnancyStatus == value;
    final activeForest = isDark ? FarmDarkColors.forest : FarmColors.forest;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _pregnancyStatus = value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? activeForest
                : (isDark ? FarmDarkColors.surface : const Color(0xFFF0EBE0)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? activeForest
                  : (isDark ? FarmDarkColors.border : const Color(0xFFD4CEC1)),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
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
    );
  }
}
