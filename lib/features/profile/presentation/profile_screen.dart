import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../app/role_controller.dart';
import '../../../../core/models/user_role.dart';
import '../../../../core/storage/app_storage.dart';
import 'widgets/profile_action_tile.dart';
import 'widgets/profile_badges_card.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_role_card.dart';
import 'widgets/profile_settings_section.dart';
import 'widgets/profile_stats_row.dart';
import 'widgets/role_explanation_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.roleController,
    this.storage,
  });

  final RoleController? roleController;
  final AppStorage? storage;

  void _showLogoutDialog(BuildContext context) {
    final tr = AppTranslations.of(context);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: FarmColors.alert),
            const SizedBox(width: 10),
            Text(tr.logoutDialogTitle),
          ],
        ),
        content: Text(
          tr.logoutDialogContent,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FarmColors.alert,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(tr.logoutAction),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeController =
        roleController ?? AppScope.of(context).roleController;
    final langController = AppScope.of(context).languageController;
    final themeController = AppScope.of(context).themeController;

    return AnimatedBuilder(
      animation: Listenable.merge([
        activeController,
        if (langController != null) langController,
        if (themeController != null) themeController,
      ]),
      builder: (context, _) {
        final tr = AppTranslations.of(context);
        final isProducer = activeController.isProducer;

        final isDark = themeController?.isDark ??
            Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isProducer
                  ? tr.profileProducerTitle
                  : tr.profileConsumerTitle,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
                  color: isDark ? FarmDarkColors.gold : FarmColors.forest,
                ),
                tooltip: tr.themeToggleTooltip,
                onPressed: () => themeController?.toggleTheme(),
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: FarmColors.alert),
                tooltip: tr.logoutTooltip,
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fantastik Başlık ve Avatar Kartı
                  ProfileHeaderCard(isProducer: isProducer),

                  // Canlı İstatistikler
                  ProfileStatsRow(
                    isProducer: isProducer,
                    storage: storage,
                  ),

                  // Bereket Rozetleri
                  ProfileBadgesCard(isProducer: isProducer),

                  // Rol Değiştirme Kartı
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: ProfileRoleCard(roleController: activeController),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
                    child: Text(
                      tr.quickModuleAccessTitle,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                      ),
                    ),
                  ),

                  // Modül Menüleri
                  ProfileActionTile(
                    icon: Icons.pets_rounded,
                    title: tr.farmHerdPanelTitle,
                    subtitle: tr.farmHerdPanelDesc,
                    routeName: AppRoutes.farm,
                    requiredRole: UserRole.producer,
                    roleController: activeController,
                  ),
                  ProfileActionTile(
                    icon: Icons.add_circle_outline_rounded,
                    title: tr.postNewAd,
                    subtitle: tr.postNewCropDesc,
                    routeName: AppRoutes.addProduct,
                    requiredRole: UserRole.producer,
                    roleController: activeController,
                  ),
                  ProfileActionTile(
                    icon: Icons.request_quote_outlined,
                    title: tr.offerDemandManagementTitle,
                    subtitle: tr.offerDemandManagementDesc,
                    routeName: AppRoutes.offers,
                    roleController: activeController,
                  ),
                  ProfileActionTile(
                    icon: Icons.storefront_rounded,
                    title: tr.marketplaceShowcaseTitle,
                    subtitle: tr.marketDirectDesc,
                    routeName: AppRoutes.marketplace,
                    roleController: activeController,
                  ),
                  ProfileActionTile(
                    icon: Icons.local_shipping_outlined,
                    title: tr.agriServiceGuideTitle,
                    subtitle: tr.agriServiceGuideDesc,
                    routeName: AppRoutes.services,
                    roleController: activeController,
                  ),

                  const SizedBox(height: 8),
                  const RoleExplanationCard(),

                  // Hesap & Güvenlik Ayarları
                  const SizedBox(height: 12),
                  const ProfileSettingsSection(),

                  // Çıkış Yap Butonu
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: OutlinedButton.icon(
                      onPressed: () => _showLogoutDialog(context),
                      icon: const Icon(Icons.logout_rounded,
                          color: FarmColors.alert),
                      label: Text(
                        tr.logoutButtonLabel,
                        style: const TextStyle(
                          color: FarmColors.alert,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: FarmColors.alert, width: 1.2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
