import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../app/role_controller.dart';
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

  void _handleTap(BuildContext context) {
    if (requiredRole != null && roleController.role != requiredRole) {
      final roleText =
          requiredRole == UserRole.producer ? 'Üretici' : 'Tüketici';
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('$roleText Modu Gerekli'),
          content: Text(
            '"$title" özelliğine erişebilmek için aktif modunuzun $roleText olması gerekmektedir. Şimdi bu moda geçiş yapmak ister misiniz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await roleController.setRole(requiredRole!);
                if (context.mounted) {
                  Navigator.of(context).pushNamed(routeName);
                }
              },
              child: Text('$roleText Moduna Geç'),
            ),
          ],
        ),
      );
      return;
    }

    Navigator.of(context).pushNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    final isRestricted =
        requiredRole != null && roleController.role != requiredRole;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Material(
        color: FarmColors.milk,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isRestricted
                ? const Color(0xFFE2DDD1)
                : const Color(0xFFD9D6C8),
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
                  ? const Color(0xFFEAE5DA)
                  : FarmColors.forest.withAlpha(25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: isRestricted
                  ? FarmColors.ink.withAlpha(120)
                  : FarmColors.forest,
              size: 22,
            ),
          ),
          title: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: isRestricted
                      ? FarmColors.ink.withAlpha(160)
                      : FarmColors.ink,
                ),
              ),
              if (requiredRole != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isRestricted
                        ? const Color(0xFFE2DDD1)
                        : (requiredRole == UserRole.producer
                            ? FarmColors.forest.withAlpha(25)
                            : FarmColors.gold.withAlpha(35)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    requiredRole == UserRole.producer ? 'Üretici' : 'Tüketici',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isRestricted
                          ? FarmColors.ink.withAlpha(130)
                          : (requiredRole == UserRole.producer
                              ? FarmColors.forest
                              : const Color(0xFF8A6216)),
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
              color: FarmColors.ink.withAlpha(150),
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: isRestricted ? const Color(0xFFB5AF9F) : FarmColors.forest,
          ),
        ),
      ),
    );
  }
}
