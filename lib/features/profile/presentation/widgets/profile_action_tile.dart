import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../app/role_controller.dart';
import '../../../../app/widgets/main_tab_scope.dart';
import '../../../../core/models/user_role.dart';

class ProfileActionTile extends StatelessWidget {
  const ProfileActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.routeName,
    this.requiredRole,
    required this.roleController,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String routeName;
  final UserRole? requiredRole;
  final RoleController roleController;

  void _dispatchNavigation(BuildContext context) {
    final tabScope = MainTabScope.of(context);
    if (tabScope != null) {
      if (routeName == AppRoutes.marketplace) {
        tabScope.switchTab(1);
        return;
      }
      if (routeName == AppRoutes.farm && roleController.isProducer) {
        tabScope.switchTab(2);
        return;
      }
      if (routeName == AppRoutes.offers) {
        tabScope.switchTab(roleController.isProducer ? 3 : 2);
        return;
      }
      if (routeName == AppRoutes.services && !roleController.isProducer) {
        tabScope.switchTab(3);
        return;
      }
      if (routeName == AppRoutes.profile) {
        tabScope.switchTab(4);
        return;
      }
    }
    Navigator.of(context).pushNamed(routeName);
  }

  void _handleTap(BuildContext context) {
    final tr = AppTranslations.of(context);

    if (requiredRole != null && roleController.role != requiredRole) {
      final roleText =
          requiredRole == UserRole.producer ? tr.roleProducer : tr.roleConsumer;
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(tr.roleRequiredTitle(roleText)),
          content: Text(
            tr.roleSwitchPrompt(title, roleText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(tr.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await roleController.setRole(requiredRole!);
                if (context.mounted) {
                  _dispatchNavigation(context);
                }
              },
              child: Text(tr.switchToRoleBtn(roleText)),
            ),
          ],
        ),
      );
      return;
    }

    _dispatchNavigation(context);
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(context);
    final isRestricted =
        requiredRole != null && roleController.role != requiredRole;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeForest = isDark ? FarmDarkColors.forest : FarmColors.forest;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Material(
        color: isDark ? FarmDarkColors.surface : FarmColors.milk,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isRestricted
                ? (isDark ? FarmDarkColors.borderSubtle : const Color(0xFFE2DDD1))
                : (isDark ? FarmDarkColors.border : const Color(0xFFD9D6C8)),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          onTap: () => _handleTap(context),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isRestricted
                  ? (isDark ? FarmDarkColors.surfaceElevated : const Color(0xFFEAE5DA))
                  : activeForest.withAlpha(isDark ? 40 : 25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isRestricted
                  ? (isDark ? FarmDarkColors.inkMuted : FarmColors.ink.withAlpha(120))
                  : activeForest,
              size: 22,
            ),
          ),
          title: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: isRestricted
                        ? (isDark ? FarmDarkColors.inkMuted : const Color(0xFF6B7280))
                        : (isDark ? FarmDarkColors.ink : FarmColors.ink),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (requiredRole != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isRestricted
                        ? (isDark ? FarmDarkColors.borderSubtle : const Color(0xFFE2DDD1))
                        : (requiredRole == UserRole.producer
                            ? activeForest.withAlpha(isDark ? 40 : 25)
                            : (isDark ? FarmDarkColors.gold.withAlpha(40) : FarmColors.gold.withAlpha(35))),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    requiredRole == UserRole.producer ? tr.roleProducer : tr.roleConsumer,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isRestricted
                          ? (isDark ? FarmDarkColors.inkMuted : const Color(0xFF6B7280))
                          : (requiredRole == UserRole.producer
                              ? activeForest
                              : (isDark ? FarmDarkColors.gold : const Color(0xFF8A6216))),
                    ),
                  ),
                ),
              ],
            ],
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? FarmDarkColors.inkMuted : const Color(0xFF4B5563),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: isRestricted
                ? (isDark ? FarmDarkColors.border : const Color(0xFFB5AF9F))
                : activeForest,
          ),
        ),
      ),
    );
  }
}
