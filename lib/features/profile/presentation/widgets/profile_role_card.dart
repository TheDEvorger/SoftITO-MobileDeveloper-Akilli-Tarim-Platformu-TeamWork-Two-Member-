import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
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
    return ListenableBuilder(
      listenable: roleController,
      builder: (context, _) {
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Aktif Kullanım Modu',
                            style: TextStyle(
                              color: Color(0xFFE2EFE7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            isProducer
                                ? 'Üretici (Çiftçi) Modu'
                                : 'Tüketici (Alıcı) Modu',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                      title: 'Üretici Modu',
                      icon: Icons.grass_rounded,
                      isSelected: isProducer,
                      onTap: () => roleController.setRole(UserRole.producer),
                    ),
                    _buildRoleOption(
                      title: 'Tüketici Modu',
                      icon: Icons.store_mall_directory_rounded,
                      isSelected: !isProducer,
                      onTap: () => roleController.setRole(UserRole.consumer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                isProducer
                    ? '🌾 Üretici modu açık: Sürü yönetimi, sera sensörleri, hasat ilanı verme ve gelen teklifleri yanıtlama yetkilerine sahipsiniz.'
                    : '🛒 Tüketici modu açık: Doğrudan üreticilerden taze ürün arama, talep/teklif oluşturma ve tarımsal hizmetleri inceleme yetkilerine sahipsiniz.',
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
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color:
                    isSelected ? FarmColors.ink : Colors.white.withAlpha(190),
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color:
                      isSelected ? FarmColors.ink : Colors.white.withAlpha(220),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
