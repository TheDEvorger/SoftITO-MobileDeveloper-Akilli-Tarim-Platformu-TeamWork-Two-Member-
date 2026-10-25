import 'package:flutter/material.dart';

import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_translations.dart';
import '../../../../app/language_controller.dart';

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

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
                      color: Colors.grey.shade300,
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
                        color: const Color(0xFF0288D1).withAlpha(20),
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
                            style: const TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: FarmColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tr.languageSelectSubtitle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
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
  }) {
    final tr = AppTranslations.of(ctx);
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
            backgroundColor: FarmColors.forest,
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? FarmColors.forest : Colors.grey.shade300,
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
                      color: isSelected ? FarmColors.forest : FarmColors.ink,
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
                          ? FarmColors.forest.withAlpha(200)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: FarmColors.forest,
                size: 22,
              )
            else
              const Icon(
                Icons.radio_button_unchecked_rounded,
                color: Color(0xFF9CA3AF),
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
    try {
      langController = AppScope.of(context).languageController;
    } catch (_) {
      langController = null;
    }

    if (langController != null) {
      return AnimatedBuilder(
        animation: langController,
        builder: (context, _) => _buildCard(context, langController, AppTranslations.of(context)),
      );
    }

    return _buildCard(context, null, AppTranslations.of(context));
  }

  Widget _buildCard(
    BuildContext context,
    AppLanguageController? langController,
    AppTranslations tr,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.black.withAlpha(15)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: Text(
                tr.accountSettingsHeader,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: FarmColors.ink,
                ),
              ),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.notifications_active_outlined,
                  color: FarmColors.forest),
              title: Text(
                tr.notificationsTitle,
                style: const TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                tr.notificationsSubtitle,
                style:
                    const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
              ),
              value: _notificationsEnabled,
              activeThumbColor: FarmColors.forest,
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
            const Divider(height: 1, indent: 16, endIndent: 16),
            SwitchListTile(
              secondary:
                  const Icon(Icons.security_rounded, color: FarmColors.gold),
              title: Text(
                tr.twoFactorTitle,
                style: const TextStyle(
                    fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                tr.twoFactorSubtitle,
                style:
                    const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
              ),
              value: _twoFactorEnabled,
              activeThumbColor: FarmColors.gold,
              onChanged: (val) {
                setState(() => _twoFactorEnabled = val);
              },
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
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
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: FarmColors.forest,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF9CA3AF),
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
