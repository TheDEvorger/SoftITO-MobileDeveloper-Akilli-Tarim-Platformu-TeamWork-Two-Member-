import 'package:flutter/material.dart';

import '../../core/models/user_role.dart';
import '../app_scope.dart';
import '../app_theme.dart';
import '../widgets/farm_card.dart';

/// Emirhan'ın gerçek ProfileScreen widget'ı bağlanana kadarki rol demosu.
class ProfileModePreview extends StatelessWidget {
  const ProfileModePreview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context).roleController;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil · Demo modu')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(Icons.agriculture, color: FarmColors.olive, size: 54),
              const SizedBox(height: 16),
              Text('Nasıl kullanmak istersin?',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center),
              const SizedBox(height: 14),
              FarmCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tek cihazda rol testi',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(controller.isProducer
                          ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: FarmColors.forest),
                      title: const Text('Üretici'),
                      subtitle: const Text('İlan ve çiftlik yönetimi görünümü'),
                      onTap: () => controller.setRole(UserRole.producer),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(!controller.isProducer
                          ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: FarmColors.forest),
                      title: const Text('Tüketici'),
                      subtitle: const Text('Pazar keşfi ve teklif görünümü'),
                      onTap: () => controller.setRole(UserRole.consumer),
                    ),
                    const SizedBox(height: 8),
                    const Text('Bu bir demo tercihidir; gerçek kullanıcı hesabı veya '
                        'kimlik doğrulaması değildir.'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => Navigator.pushNamed(context, '/marketplace'),
                child: const Text('Pazara git'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
