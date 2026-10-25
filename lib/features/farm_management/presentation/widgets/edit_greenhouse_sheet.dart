import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../core/models/greenhouse.dart';
import '../controllers/greenhouse_simulator_controller.dart';

class EditGreenhouseSheet extends StatefulWidget {
  const EditGreenhouseSheet({
    super.key,
    required this.greenhouse,
    required this.controller,
    this.onUpdated,
  });

  final Greenhouse greenhouse;
  final GreenhouseSimulatorController controller;
  final VoidCallback? onUpdated;

  @override
  State<EditGreenhouseSheet> createState() => _EditGreenhouseSheetState();
}

class _EditGreenhouseSheetState extends State<EditGreenhouseSheet> {
  late final TextEditingController _nameController;
  late double _temperature;
  late double _humidity;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.greenhouse.name);
    _temperature = widget.greenhouse.temperatureC;
    _humidity = widget.greenhouse.humidityPercent;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Please enter a name');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await widget.controller.updateGreenhouse(
      id: widget.greenhouse.id,
      name: name,
      temperatureC: _temperature,
      humidityPercent: _humidity,
    );

    if (mounted) {
      widget.onUpdated?.call();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name OK'),
          backgroundColor: FarmColors.forest,
        ),
      );
    }
  }

  void _confirmDelete() {
    final tr = AppTranslations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr.deleteGreenhouseBtn),
        content: Text(
          '"${widget.greenhouse.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr.cancel),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await widget.controller.removeGreenhouse(widget.greenhouse.id);
              if (mounted) {
                widget.onUpdated?.call();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.greenhouse.name} OK'),
                    backgroundColor: FarmColors.alert,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: FarmColors.alert),
            child: Text(tr.deleteBtn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? FarmDarkColors.surfaceElevated : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: isDark ? const Border(top: BorderSide(color: FarmDarkColors.border)) : null,
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? FarmDarkColors.border : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.edit_note_rounded,
                          color: isDark ? FarmDarkColors.forest : FarmColors.forest, size: 26),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tr.editGreenhouseTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: isDark ? FarmDarkColors.inkMuted : null),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'ID: ${widget.greenhouse.id}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? FarmDarkColors.inkMuted : const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? FarmDarkColors.alert.withAlpha(35) : const Color(0xFFFDE8E8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: FarmDarkColors.alert),
                ),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: FarmDarkColors.alert,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Text(
              tr.greenhouseNameLabel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? FarmDarkColors.ink : FarmColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.eco_outlined,
                    color: isDark ? FarmDarkColors.forest : FarmColors.forest),
                filled: true,
                fillColor: isDark ? FarmDarkColors.surface : const Color(0xFFF9F7F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark ? FarmDarkColors.border : const Color(0xFFE2DDD1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark ? FarmDarkColors.border : const Color(0xFFE2DDD1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr.initialTempLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                  ),
                ),
                Text(
                  '${_temperature.toStringAsFixed(1)} °C',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? FarmDarkColors.forest : FarmColors.forest,
                  ),
                ),
              ],
            ),
            Slider(
              value: _temperature,
              min: 10.0,
              max: 40.0,
              divisions: 60,
              activeColor: isDark ? FarmDarkColors.forest : FarmColors.forest,
              label: '${_temperature.toStringAsFixed(1)} °C',
              onChanged: (val) => setState(() => _temperature = val),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr.initialHumLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                  ),
                ),
                Text(
                  '%${_humidity.toStringAsFixed(1)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFF4FC3F7) : const Color(0xFF0277BD),
                  ),
                ),
              ],
            ),
            Slider(
              value: _humidity,
              min: 20.0,
              max: 95.0,
              divisions: 75,
              activeColor: isDark ? const Color(0xFF4FC3F7) : const Color(0xFF0277BD),
              label: '%${_humidity.toStringAsFixed(1)}',
              onChanged: (val) => setState(() => _humidity = val),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: _isLoading ? null : _confirmDelete,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: FarmDarkColors.alert,
                      side: const BorderSide(color: FarmDarkColors.alert),
                      minimumSize: const Size(40, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                    label: Text(tr.deleteGreenhouseBtn,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _update,
                    style: FilledButton.styleFrom(
                      backgroundColor: isDark ? FarmDarkColors.forest : FarmColors.forest,
                      foregroundColor: isDark ? const Color(0xFF0C2419) : Colors.white,
                      minimumSize: const Size(40, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: _isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_rounded, size: 18),
                    label: Text(tr.saveBtn,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
