import 'package:flutter/material.dart';

import '../core/storage/app_storage.dart';
import 'app_router.dart';
import 'app_scope.dart';
import 'app_theme.dart';
import 'role_controller.dart';
import 'screens/home_screen.dart';

class AkilliTarimApp extends StatelessWidget {
  const AkilliTarimApp({
    super.key,
    required this.storage,
    required this.roleController,
  });

  final AppStorage storage;
  final RoleController roleController;

  @override
  Widget build(BuildContext context) => AppScope(
        storage: storage,
        roleController: roleController,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bereket Ovası | Akıllı Tarım',
          theme: FarmTheme.light,
          home: const HomeScreen(),
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ),
      );
}
