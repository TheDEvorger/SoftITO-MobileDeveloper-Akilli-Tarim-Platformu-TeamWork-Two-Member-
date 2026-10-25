import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../app/language_controller.dart';
import '../../../../app/theme_controller.dart';

class ProfileSettingsSection extends StatefulWidget {
  const ProfileSettingsSection({super.key});

  @override
  State<ProfileSettingsSection> createState() => _ProfileSettingsSectionState();
}

class _ProfileSettingsSectionState extends State<ProfileSettingsSection> {
  bool _notificationsEnabled = true;
  bool _twoFactorEnabled = true;

  void _showLanguageSheet(
    BuildContext context,
    AppLanguageController? controller,
    AppTranslations tr,
  ) {
    if (controller == null) return;
    final currentLang = controller.language;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? FarmDarkColors.surfaceElevated : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isDark
                          ? FarmDarkColors.border
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0288D1).withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.language_rounded,
                        color: Color(0xFF0288D1),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr.selectLanguageTitle,
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? FarmDarkColors.ink
                                  : FarmColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tr.languageSelectSubtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? FarmDarkColors.inkMuted
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                for (final lang in AppLanguage.values) ...[
                  _buildLanguageTile(
                    ctx: ctx,
                    controller: controller,
                    language: lang,
                    isSelected: currentLang == lang,
                    isDark: isDark,
                  ),
                  if (lang != AppLanguage.values.last)
                    const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageTile({
    required BuildContext ctx,
    required AppLanguageController controller,
    required AppLanguage language,
    required bool isSelected,
    required bool isDark,
  }) {
    final tr = AppTranslations.of(ctx);
    final activeForest = isDark ? FarmDarkColors.forest : FarmColors.forest;

    return InkWell(
      onTap: () async {
        Navigator.pop(ctx);
        await controller.setLanguage(language);
        if (!mounted) return;
        final newTr = AppTranslations(language);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newTr.languageUpdatedMessage(language.displayName)),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: activeForest,
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? FarmDarkColors.forest.withAlpha(45)
                  : const Color(0xFFE8F5E9))
              : (isDark
                  ? FarmDarkColors.surface
                  : const Color(0xFFF9FAFB)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? activeForest
                : (isDark ? FarmDarkColors.border : Colors.grey.shade300),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text(language.flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.displayName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? activeForest
                          : (isDark ? FarmDarkColors.ink : FarmColors.ink),
                    ),
                  ),
                  Text(
                    switch (language) {
                      AppLanguage.tr => tr.langTrSubtitle,
                      AppLanguage.en => tr.langEnSubtitle,
                      AppLanguage.de => tr.langDeSubtitle,
                    },
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isSelected
                          ? activeForest.withAlpha(200)
                          : (isDark
                              ? FarmDarkColors.inkMuted
                              : const Color(0xFF6B7280)),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: activeForest,
                size: 22,
              )
            else
              Icon(
                Icons.radio_button_unchecked_rounded,
                color: isDark ? FarmDarkColors.border : const Color(0xFF9CA3AF),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLanguageController? langController;
    AppThemeController? themeController;
    try {
      final scope = AppScope.of(context);
      langController = scope.languageController;
      themeController = scope.themeController;
    } catch (_) {
      langController = null;
      themeController = null;
    }

    final listenables = <Listenable>[
      if (langController != null) langController,
      if (themeController != null) themeController,
    ];

    if (listenables.isNotEmpty) {
      return AnimatedBuilder(
        animation: Listenable.merge(listenables),
        builder: (context, _) =>
            _buildCard(context, langController, themeController, AppTranslations.of(context)),
      );
    }

    return _buildCard(context, null, null, AppTranslations.of(context));
  }

  Widget _buildCard(
    BuildContext context,
    AppLanguageController? langController,
    AppThemeController? themeController,
    AppTranslations tr,
  ) {
    final isDark = themeController?.isDark ??
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? const Color(0x33000000) : const Color(0x0C000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: isDark ? FarmDarkColors.surface : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark
                ? FarmDarkColors.border
                : Colors.black.withAlpha(15),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(
                tr.accountSettingsHeader,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? FarmDarkColors.ink : FarmColors.ink,
                ),
              ),
            ),

            // Karanlık Tema Toggle Switch (Anında Değiştirilebilir ve Hive Kalıcı)
            SwitchListTile(
              key: const Key('theme_dark_switch_tile'),
              secondary: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_outlined,
                color: isDark ? FarmDarkColors.gold : FarmColors.forest,
              ),
              title: Text(
                tr.themeDarkTitle,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                tr.themeDarkSubtitle,
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark
                      ? FarmDarkColors.inkMuted
                      : const Color(0xFF6B7280),
                ),
              ),
              value: isDark,
              activeThumbColor: FarmDarkColors.forest,
              onChanged: (val) async {
                if (themeController != null) {
                  await themeController
                      .setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                }
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr.themeUpdatedMessage(val)),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: isDark ? FarmDarkColors.border : null,
            ),

            // Bildirimler
            SwitchListTile(
              secondary: Icon(
                Icons.notifications_active_outlined,
                color: isDark ? FarmDarkColors.forest : FarmColors.forest,
              ),
              title: Text(
                tr.notificationsTitle,
                style: const TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                tr.notificationsSubtitle,
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark
                      ? FarmDarkColors.inkMuted
                      : const Color(0xFF6B7280),
                ),
              ),
              value: _notificationsEnabled,
              activeThumbColor:
                  isDark ? FarmDarkColors.forest : FarmColors.forest,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(val
                        ? tr.notificationsEnabled
                        : tr.notificationsDisabled),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: isDark ? FarmDarkColors.border : null,
            ),

            // İki Adımlı Giriş (2FA)
            SwitchListTile(
              secondary: Icon(
                Icons.security_rounded,
                color: isDark ? FarmDarkColors.gold : FarmColors.gold,
              ),
              title: Text(
                tr.twoFactorTitle,
                style: const TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                tr.twoFactorSubtitle,
                style: TextStyle(
                  fontSize: 11.5,
                  color: isDark
                      ? FarmDarkColors.inkMuted
                      : const Color(0xFF6B7280),
                ),
              ),
              value: _twoFactorEnabled,
              activeThumbColor: isDark ? FarmDarkColors.gold : FarmColors.gold,
              onChanged: (val) {
                setState(() => _twoFactorEnabled = val);
              },
            ),
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: isDark ? FarmDarkColors.border : null,
            ),

            // Uygulama Dili
            ListTile(
              leading:
                  const Icon(Icons.language_rounded, color: Color(0xFF0288D1)),
              title: Text(
                tr.appLanguageTitle,
                style: const TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    langController?.labelWithFlag ?? '🇹🇷 Türkçe (TR)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isDark ? FarmDarkColors.forest : FarmColors.forest,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark
                        ? FarmDarkColors.inkMuted
                        : const Color(0xFF9CA3AF),
                    size: 20,
                  ),
                ],
              ),
              onTap: () => _showLanguageSheet(context, langController, tr),
            ),
          ],
        ),
      ),
    );
  }
}
