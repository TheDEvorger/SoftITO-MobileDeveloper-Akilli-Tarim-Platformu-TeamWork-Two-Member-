import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:akilli_tarim_platformu/core/models/product.dart';
import 'package:akilli_tarim_platformu/core/storage/json_box_repository.dart';

class AddProductController extends ChangeNotifier {
  AddProductController({
    required this.productsRepository,
    this.sellerId = 'demo_producer_001',
    ImagePicker? picker,
  }) : _picker = picker ?? ImagePicker();

  final JsonBoxRepository<Product> productsRepository;
  final String sellerId;
  final ImagePicker _picker;

  String? selectedImagePath;
  bool isSaving = false;

  Future<void> pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = 'prod_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedFile = await File(picked.path).copy('${appDir.path}/$fileName');

    selectedImagePath = savedFile.path;
    notifyListeners();
  }

  void clearImage() {
    selectedImagePath = null;
    notifyListeners();
  }

  Future<Product> saveProduct({
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
    isSaving = true;
    notifyListeners();

    try {
      final now = DateTime.now().toIso8601String();
      final id = 'prod_${DateTime.now().millisecondsSinceEpoch}';

      final fallbackImage = switch (category) {
        'Tahıl' => 'assets/images/wheat.png',
        'Meyve' => 'assets/images/apples.png',
        'Süt ve Hayvancılık' => 'assets/images/milk.png',
        'Sebze' => 'assets/images/tomatoes.jpg',
        'Arıcılık' => 'assets/images/honey.jpg',
        'Zeytinyağı' => 'assets/images/olive_oil.jpg',
        _ => 'assets/images/harvest_hero.png',
      };

      final product = Product(
        id: id,
        sellerId: sellerId,
        title: title.trim(),
        category: category,
        quantity: quantity,
        unit: unit,
        unitPrice: unitPrice,
        city: city.trim(),
        district: district.trim(),
        imagePath: selectedImagePath ?? fallbackImage,
        sellerPhone: sellerPhone.trim(),
        description: description.trim(),
        createdAt: now,
      );

      await productsRepository.put(product);
      return product;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
