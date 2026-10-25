import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';

abstract final class ServiceCallHelper {
  static Future<void> callPhone(BuildContext context, String? rawPhone) async {
    final tr = AppTranslations.of(context);
    final phone = rawPhone?.trim() ?? '';
    if (phone.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr.noPhoneProvided),
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
            content: Text(tr.callFailedWithPhone(phone)),
            backgroundColor: FarmColors.alert,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr.callFailedWithPhone(phone)),
            backgroundColor: FarmColors.alert,
          ),
        );
      }
    }
  }
}
