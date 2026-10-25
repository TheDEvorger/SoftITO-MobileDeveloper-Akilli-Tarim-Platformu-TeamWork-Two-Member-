import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../controllers/greenhouse_simulator_controller.dart';

class AddGreenhouseSheet extends StatefulWidget {
  const AddGreenhouseSheet({
    super.key,
    required this.controller,
    this.onSaved,
  });

  final GreenhouseSimulatorController controller;
  final VoidCallback? onSaved;

  @override
  State<AddGreenhouseSheet> createState() => _AddGreenhouseSheetState();
}

class _AddGreenhouseSheetState extends State<AddGreenhouseSheet> {
  final _nameController = TextEditingController();
  double _temperature = 24.0;
  double _humidity = 65.0;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final count = widget.controller.greenhouses.length + 1;
    _nameController.text = 'Sera $count';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(
          () => _errorMessage = 'Please enter a name');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await widget.controller.addGreenhouse(
      name: name,
      initialTemp: _temperature,
      initialHumidity: _humidity,
    );

    if (mounted) {
      widget.onSaved?.call();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name OK'),
          backgroundColor: FarmColors.forest,
        ),
      );
    }
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
                      Icon(Icons.wb_twilight_rounded,
                          color: isDark ? FarmDarkColors.forest : FarmColors.forest, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tr.newGreenhouseTitle,
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
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: FarmDarkColors.alert, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: FarmDarkColors.alert,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: isDark ? FarmDarkColors.forest : FarmColors.forest,
                  foregroundColor: isDark ? const Color(0xFF0C2419) : Colors.white,
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
                    : const Icon(Icons.check_circle_outline_rounded),
                label: Text(
                  tr.saveBtn,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
