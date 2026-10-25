import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:akilli_tarim_platformu/app/app_theme.dart';
import 'package:akilli_tarim_platformu/app/app_translations.dart';
import 'package:akilli_tarim_platformu/app/widgets/farm_card.dart';

class AddProductImagePicker extends StatelessWidget {
  const AddProductImagePicker({
    super.key,
    required this.selectedImagePath,
    required this.onPickImage,
    required this.onClearImage,
  });

  final String? selectedImagePath;
  final ValueChanged<ImageSource> onPickImage;
  final VoidCallback onClearImage;

  void _showSourceSheet(BuildContext context) {
    final tr = AppTranslations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? FarmDarkColors.surfaceElevated : FarmColors.milk,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tr.addProductPhotoTitle,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.camera_alt_outlined,
                    color: isDark ? FarmDarkColors.forest : FarmColors.forest),
                title: Text(
                  tr.cameraCaptureOption,
                  style: TextStyle(
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onPickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_outlined,
                    color: isDark ? FarmDarkColors.forest : FarmColors.forest),
                title: Text(
                  tr.gallerySelectOption,
                  style: TextStyle(
                    color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onPickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (selectedImagePath != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.file(
              File(selectedImagePath!),
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: FarmColors.ink.withValues(alpha: 0.6),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
                onPressed: onClearImage,
              ),
            ),
          ),
        ],
      );
    }

    return FarmCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: () => _showSourceSheet(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (isDark ? FarmDarkColors.gold : FarmColors.olive)
                  .withValues(alpha: 0.4),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                size: 40,
                color: isDark ? FarmDarkColors.gold : FarmColors.olive,
              ),
              const SizedBox(height: 10),
              Text(
                tr.uploadProductPhotoBtn,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isDark ? FarmDarkColors.forest : FarmColors.forest,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tr.uploadPhotoSubtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? FarmDarkColors.inkMuted : FarmColors.earth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
