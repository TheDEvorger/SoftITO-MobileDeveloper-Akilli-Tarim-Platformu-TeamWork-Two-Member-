import 'package:flutter/material.dart';

import 'package:akilli_tarim_platformu/app/app_scope.dart';
import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/app_translations.dart';
import 'package:akilli_tarim_platformu/core/models/user_role.dart';
import '../controllers/add_product_controller.dart';
import '../widgets/add_product_form.dart';
import '../widgets/add_product_image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  AddProductController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller ??= AddProductController(
      productsRepository: AppScope.of(context).storage.products,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
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
    if (_controller == null) return;
    try {
      await _controller!.saveProduct(
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
        final tr = AppTranslations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: FarmColors.forest,
            content: Text(tr.listingPublishedSuccess),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: FarmColors.alert,
            content: Text('Error: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final scope = AppScope.of(context);
    final tr = AppTranslations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr.publishListingBtn)),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller!, scope.roleController]),
          builder: (context, _) {
            final isProducer = scope.roleController.isProducer;
            if (!isProducer) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: FarmColors.gold.withAlpha(25),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.storefront_outlined,
                            size: 56, color: FarmColors.gold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        tr.producerOnlyPublishWarning,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: FarmColors.ink,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        tr.producerRoleDesc,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4B5563),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () async {
                          await scope.roleController.setRole(UserRole.producer);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: FarmColors.forest,
                                content: Text(
                                  tr.producerModeTitle,
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.agriculture_rounded),
                        label: Text(tr.producerTab),
                        style: FilledButton.styleFrom(
                          backgroundColor: FarmColors.forest,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AddProductImagePicker(
                  selectedImagePath: _controller!.selectedImagePath,
                  onPickImage: _controller!.pickImage,
                  onClearImage: _controller!.clearImage,
                ),
                const SizedBox(height: 16),
                AddProductForm(
                  onSubmit: _handleSubmit,
                  isSubmitting: _controller!.isSaving,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
