import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/app_translations.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({
    super.key,
    required this.onSubmit,
    required this.isSubmitting,
  });

  final Future<void> Function({
    required String title,
    required String category,
    required double quantity,
    required String unit,
    required double unitPrice,
    required String city,
    required String district,
    required String sellerPhone,
    required String description,
  }) onSubmit;
  final bool isSubmitting;

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _cityController = TextEditingController(text: 'Konya');
  final _districtController = TextEditingController(text: 'Çumra');
  final _phoneController = TextEditingController(text: '05550123456');
  final _descriptionController = TextEditingController();

  String _category = 'Tahıl';
  String _unit = 'kg';

  static const _categories = [
    'Tahıl',
    'Meyve',
    'Sebze',
    'Süt ve Hayvancılık',
    'Bakliyat',
    'Yem',
  ];

  static const _units = ['kg', 'ton', 'litre', 'kasa', 'adet', 'çuval'];

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final quantity =
        double.tryParse(_quantityController.text.replaceAll(',', '.')) ?? 0;
    final price =
        double.tryParse(_unitPriceController.text.replaceAll(',', '.')) ?? 0;

    widget.onSubmit(
      title: _titleController.text,
      category: _category,
      quantity: quantity,
      unit: _unit,
      unitPrice: price,
      city: _cityController.text,
      district: _districtController.text,
      sellerPhone: _phoneController.text,
      description: _descriptionController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: tr.productTitleLabel),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? tr.titleRequiredMsg : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: InputDecoration(labelText: '${tr.categoryTitle} *'),
            items: _categories
                .map((c) => DropdownMenuItem(value: c, child: Text(tr.translateCategory(c))))
                .toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
                  ],
                  decoration: InputDecoration(labelText: tr.quantityLabel),
                  validator: (v) {
                    final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                    return (n == null || n <= 0)
                        ? '1+'
                        : null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  initialValue: _unit,
                  decoration: InputDecoration(labelText: tr.unitLabel),
                  items: _units
                      .map((u) => DropdownMenuItem(value: u, child: Text(tr.translateUnit(u))))
                      .toList(),
                  onChanged: (v) => setState(() => _unit = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _unitPriceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
            ],
            decoration: InputDecoration(
              labelText: tr.unitPriceLabel,
              prefixText: '₺ ',
            ),
            validator: (v) {
              final n = double.tryParse((v ?? '').replaceAll(',', '.'));
              return (n == null || n <= 0) ? '1+' : null;
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: tr.cityLabel),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? '*' : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _districtController,
                  decoration: InputDecoration(labelText: tr.districtLabel),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? '*'
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: tr.contactPhoneLabel),
            validator: (v) => (v == null || v.trim().length < 5)
                ? '*'
                : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
                labelText: tr.descriptionLabel),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: widget.isSubmitting ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: FarmColors.forest,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: widget.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(tr.publishListingBtn,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
