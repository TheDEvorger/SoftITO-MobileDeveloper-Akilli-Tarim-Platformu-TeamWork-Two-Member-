import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../app_translations.dart';
import '../widgets/farm_card.dart';

/// İlgili geliştirici gerçek widget'ı teslim edene kadar güvenli ekran.
class FeatureComingScreen extends StatelessWidget {
  const FeatureComingScreen({
    super.key,
    required this.title,
    required this.owner,
    this.icon = Icons.construction_outlined,
  });

  final String title;
  final String owner;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FarmCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 64, color: FarmColors.olive),
                  const SizedBox(height: 14),
                  Text(title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  Text(
                    '${tr.comingSoonTitle(owner)}. ${tr.comingSoonDesc}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: Text(tr.backToHomeBtn),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
