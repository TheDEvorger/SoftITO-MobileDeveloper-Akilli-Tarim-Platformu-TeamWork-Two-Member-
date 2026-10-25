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

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
                  color: Colors.grey.shade300,
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
                      const Icon(Icons.wb_twilight_rounded,
                          color: FarmColors.forest, size: 24),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tr.newGreenhouseTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: FarmColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
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
                  color: const Color(0xFFFDE8E8),
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
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: FarmColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.eco_outlined, color: FarmColors.forest),
                filled: true,
                fillColor: const Color(0xFFF9F7F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFFE2DDD1)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr.initialTempLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: FarmColors.ink,
                  ),
                ),
                Text(
                  '${_temperature.toStringAsFixed(1)} °C',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: FarmColors.forest,
                  ),
                ),
              ],
            ),
            Slider(
              value: _temperature,
              min: 10.0,
              max: 40.0,
              divisions: 60,
              activeColor: FarmColors.forest,
              label: '${_temperature.toStringAsFixed(1)} °C',
              onChanged: (val) => setState(() => _temperature = val),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr.initialHumLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: FarmColors.ink,
                  ),
                ),
                Text(
                  '%${_humidity.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0277BD),
                  ),
                ),
              ],
            ),
            Slider(
              value: _humidity,
              min: 20.0,
              max: 95.0,
              divisions: 75,
              activeColor: const Color(0xFF0277BD),
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
                  backgroundColor: FarmColors.forest,
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
