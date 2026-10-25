import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../app/language_controller.dart';
import '../../../../app/role_controller.dart';
import '../../../../core/models/user_role.dart';

class ProfileRoleCard extends StatelessWidget {
  const ProfileRoleCard({
    super.key,
    required this.roleController,
  });

  final RoleController roleController;

  @override
  Widget build(BuildContext context) {
    AppLanguageController? langController;
    try {
      langController = AppScope.of(context).languageController;
    } catch (_) {
      langController = null;
    }

    return ListenableBuilder(
      listenable: Listenable.merge([
        roleController,
        if (langController != null) langController,
      ]),
      builder: (context, _) {
        final tr = AppTranslations.of(context);
        final isProducer = roleController.isProducer;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isProducer
                  ? [FarmColors.forest, const Color(0xFF2C5E4E)]
                  : [const Color(0xFF8A6216), FarmColors.gold],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: FarmColors.gold.withAlpha(120), width: 1.4),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F214A3D),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isProducer
                          ? Icons.agriculture_rounded
                          : Icons.shopping_basket_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr.activeRoleMode,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFE2EFE7),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          isProducer
                              ? tr.producerModeTitle
                              : tr.consumerModeTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(35),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    _buildRoleOption(
                      title: tr.producerTab,
                      icon: Icons.grass_rounded,
                      isSelected: isProducer,
                      isDark: Theme.of(context).brightness == Brightness.dark,
                      onTap: () => roleController.setRole(UserRole.producer),
                    ),
                    _buildRoleOption(
                      title: tr.consumerTab,
                      icon: Icons.store_mall_directory_rounded,
                      isSelected: !isProducer,
                      isDark: Theme.of(context).brightness == Brightness.dark,
                      onTap: () => roleController.setRole(UserRole.consumer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                isProducer
                    ? tr.producerRoleDesc
                    : tr.consumerRoleDesc,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? FarmDarkColors.surfaceElevated : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: isSelected
                        ? (isDark ? FarmDarkColors.ink : FarmColors.ink)
                        : const Color(0xFFD7E8DC),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? (isDark ? FarmDarkColors.ink : FarmColors.ink)
                          : const Color(0xFFE2EFE7),
                    ),
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
