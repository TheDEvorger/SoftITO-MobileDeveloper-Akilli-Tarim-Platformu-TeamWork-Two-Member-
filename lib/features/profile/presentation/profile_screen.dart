import 'package:flutter/material.dart';

import '../../../../app/app_router.dart';
import '../../../../app/app_scope.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/role_controller.dart';
import '../../../../core/models/user_role.dart';
import 'widgets/profile_action_tile.dart';
import 'widgets/profile_role_card.dart';
import 'widgets/role_explanation_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.roleController,
  });

  final RoleController? roleController;

  @override
  Widget build(BuildContext context) {
    final activeController =
        roleController ?? AppScope.of(context).roleController;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil & Rol Yönetimi',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: ProfileRoleCard(roleController: activeController),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 14, 18, 6),
                child: Text(
                  'Hızlı Modül Erişimi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: FarmColors.ink,
                  ),
                ),
              ),
              // Çiftlik ve Sürü Takibi (Üreticiye özel)
              ProfileActionTile(
                icon: Icons.pets_rounded,
                title: 'Çiftlik & Sürü Paneli',
                subtitle:
                    'Hayvan aşı takibi, gebelik ve sera sensör simülasyonu',
                routeName: AppRoutes.farm,
                requiredRole: UserRole.producer,
                roleController: activeController,
              ),
              // İlan Ekleme (Üreticiye özel)
              ProfileActionTile(
                icon: Icons.add_circle_outline_rounded,
                title: 'Yeni Mahsul İlanı Ver',
                subtitle: 'Ürettiğiniz buğday, elma, süt vb. pazara listeleyin',
                routeName: AppRoutes.addProduct,
                requiredRole: UserRole.producer,
                roleController: activeController,
              ),
              // Teklifler (Her iki mod da görebilir)
              ProfileActionTile(
                icon: Icons.request_quote_outlined,
                title: 'Teklif & Talep Yönetimi',
                subtitle: 'Gelen veya alıcı olarak ilettiğiniz ürün teklifleri',
                routeName: AppRoutes.offers,
                roleController: activeController,
              ),
              // Pazar Yeri Vitrini
              ProfileActionTile(
                icon: Icons.storefront_rounded,
                title: 'Pazar Yeri Vitrini',
                subtitle: 'Tüm üreticilerin doğrudan satış listeleri',
                routeName: AppRoutes.marketplace,
                roleController: activeController,
              ),
              // Hizmet Rehberi
              ProfileActionTile(
                icon: Icons.local_shipping_outlined,
                title: 'Tarımsal Hizmet Rehberi',
                subtitle:
                    'Bölgesel veteriner, traktör ve nakliye sağlayıcıları',
                routeName: AppRoutes.services,
                roleController: activeController,
              ),
              const SizedBox(height: 8),
              const RoleExplanationCard(),
            ],
          ),
        ),
      ),
    );
  }
}
