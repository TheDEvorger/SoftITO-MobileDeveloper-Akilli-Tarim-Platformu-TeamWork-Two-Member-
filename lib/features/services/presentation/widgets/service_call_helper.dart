import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/app_theme.dart';

abstract final class ServiceCallHelper {
  static Future<void> callPhone(BuildContext context, String? rawPhone) async {
    final phone = rawPhone?.trim() ?? '';
    if (phone.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Bu sağlayıcı için kayıtlı bir telefon numarası bulunmuyor.'),
            backgroundColor: FarmColors.alert,
          ),
        );
      }
      return;
    }

    // Yalnızca rakamları ve baştaki + işaretini tut
    final cleanDigits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri(scheme: 'tel', path: cleanDigits);

    try {
      final launched = await launchUrl(uri);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Arama başlatılamadı ($phone). Cihazınız telefon aramasını desteklemiyor olabilir.'),
            backgroundColor: FarmColors.alert,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Arama başlatılamadı ($phone).'),
            backgroundColor: FarmColors.alert,
          ),
        );
      }
    }
  }
}
