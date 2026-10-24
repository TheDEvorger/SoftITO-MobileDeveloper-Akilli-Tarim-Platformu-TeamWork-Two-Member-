import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../controllers/animal_controller.dart';

class AddAnimalSheet extends StatefulWidget {
  const AddAnimalSheet({
    super.key,
    required this.controller,
    required this.onSaved,
  });

  final AnimalController controller;
  final VoidCallback onSaved;

  @override
  State<AddAnimalSheet> createState() => _AddAnimalSheetState();
}

class _AddAnimalSheetState extends State<AddAnimalSheet> {
  final _earTagController = TextEditingController();
  final _vaccinationDateController = TextEditingController();
  String _selectedSpecies = 'İnek (Büyükbaş)';
  String _pregnancyStatus = 'unknown';
  String? _errorMessage;
  bool _isSaving = false;

  final List<String> _speciesOptions = const [
    'İnek (Büyükbaş)',
    'Düve (Büyükbaş)',
    'Tosun (Büyükbaş)',
    'Koyun (Küçükbaş)',
    'Kuzu (Küçükbaş)',
    'Keçi (Küçükbaş)',
    'Manda (Büyükbaş)',
  ];

  @override
  void dispose() {
    _earTagController.dispose();
    _vaccinationDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: now,
      helpText: 'Son Aşı Tarihini Seçin',
      cancelText: 'Vazgeç',
      confirmText: 'Seç',
    );
    if (picked != null) {
      final y = picked.year.toString().padLeft(4, '0');
      final m = picked.month.toString().padLeft(2, '0');
      final d = picked.day.toString().padLeft(2, '0');
      setState(() {
        _vaccinationDateController.text = '$y-$m-$d';
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      _errorMessage = null;
      _isSaving = true;
    });

    final result = await widget.controller.addAnimal(
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
              'Hayvan ${_earTagController.text.trim()} başarıyla kaydedildi.'),
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
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: FarmColors.milk,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                    color: const Color(0xFFD4CEC1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Yeni Hayvan Kaydı',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: FarmColors.ink,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECE5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: FarmColors.alert),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: FarmColors.alert, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: FarmColors.alert,
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
              const Text(
                'Küpe Numarası *',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _earTagController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'Örn: TR-06-A-9921',
                  prefixIcon: Icon(Icons.tag_rounded, color: FarmColors.forest),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Hayvan Türü / Irkı *',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: FarmColors.ink),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedSpecies,
                decoration: const InputDecoration(
                  prefixIcon:
                      Icon(Icons.pets_rounded, color: FarmColors.forest),
                ),
                items: _speciesOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedSpecies = val);
                },
              ),
              const SizedBox(height: 14),
              const Text(
                'Son Aşı Tarihi (Opsiyonel)',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: FarmColors.ink),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _vaccinationDateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  hintText: 'YYYY-AA-GG (Seçmek için dokunun)',
                  prefixIcon: const Icon(Icons.calendar_today_rounded,
                      color: FarmColors.forest),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear_rounded, size: 18),
                    onPressed: () => _vaccinationDateController.clear(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Gebelik Durumu',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: FarmColors.ink),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPregnancyOption('unknown', 'Bilinmiyor'),
                  const SizedBox(width: 8),
                  _buildPregnancyOption('pregnant', 'Gebe'),
                  const SizedBox(width: 8),
                  _buildPregnancyOption('not_pregnant', 'Gebe Değil'),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _submit,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Kaydet ve Sürüye Ekle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPregnancyOption(String value, String label) {
    final isSelected = _pregnancyStatus == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _pregnancyStatus = value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? FarmColors.forest : const Color(0xFFF0EBE0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? FarmColors.forest : const Color(0xFFD4CEC1),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
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
