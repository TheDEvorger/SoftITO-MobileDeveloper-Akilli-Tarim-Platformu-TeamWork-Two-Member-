import 'package:flutter/material.dart';

import 'package:akilli_tarim_platformu/app/app_scope.dart';
import 'package:akilli_tarim_platformu/app/app_theme.dart';
import '../controllers/add_product_controller.dart';
import '../widgets/add_product_form.dart';
import '../widgets/add_product_image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  late final AddProductController _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller = AddProductController(
      productsRepository: AppScope.of(context).storage.products,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit({
    required String title,
    required String category,
    required double quantity,
    required String unit,
    required double unitPrice,
    required String city,
    required String district,
    required String sellerPhone,
    required String description,
  }) async {
    try {
      await _controller.saveProduct(
        title: title,
        category: category,
        quantity: quantity,
        unit: unit,
        unitPrice: unitPrice,
        city: city,
        district: district,
        sellerPhone: sellerPhone,
        description: description,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: FarmColors.forest,
            content: Text('İlanınız başarıyla yayına alındı.'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: FarmColors.alert,
            content: Text('İlan eklenirken hata oluştu: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni İlan Ver')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AddProductImagePicker(
                  selectedImagePath: _controller.selectedImagePath,
                  onPickImage: _controller.pickImage,
                  onClearImage: _controller.clearImage,
                ),
                const SizedBox(height: 16),
                AddProductForm(
                  onSubmit: _handleSubmit,
                  isSubmitting: _controller.isSaving,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
