import 'package:flutter/material.dart';

import '../../core/models/user_role.dart';
import '../app_scope.dart';
import '../app_theme.dart';
import '../app_translations.dart';
import '../widgets/farm_card.dart';

/// Emirhan'ın gerçek ProfileScreen widget'ı bağlanana kadarki rol demosu.
class ProfileModePreview extends StatelessWidget {
  const ProfileModePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context).roleController;
    final tr = AppTranslations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('${tr.navProfile} · Demo')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(Icons.agriculture, color: FarmColors.olive, size: 54),
              const SizedBox(height: 16),
              Text(tr.howToUseTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 14),
              FarmCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr.activeRoleMode,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                          controller.isProducer
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: FarmColors.forest),
                      title: Text(tr.roleProducer),
                      subtitle: Text(tr.producerModeDesc),
                      onTap: () => controller.setRole(UserRole.producer),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                          !controller.isProducer
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: FarmColors.forest),
                      title: Text(tr.roleConsumer),
                      subtitle: Text(tr.consumerModeDesc),
                      onTap: () => controller.setRole(UserRole.consumer),
                    ),
                    const SizedBox(height: 8),
                    Text(tr.modePreviewNotice),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, '/marketplace'),
                child: Text(tr.goToMarketBtn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
