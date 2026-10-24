import 'package:akilli_tarim_platformu/app/role_controller.dart';
import 'package:akilli_tarim_platformu/core/models/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_json_box_repository.dart';

void main() {
  group('Profile & Role Management Unit Tests', () {
    late FakeBox<String> settingsBox;
    late RoleController roleController;

    setUp(() {
      settingsBox = FakeBox<String>();
      settingsBox.put('user_role', 'producer');
      roleController = RoleController(settingsBox);
    });

    tearDown(() {
      roleController.dispose();
    });

    test('Başlangıçta saklanan üretici rolü doğru okunur', () {
      expect(roleController.role, UserRole.producer);
      expect(roleController.isProducer, isTrue);
    });

    test('Tüketici rolüne geçiş yapılır ve settings kutusuna yazılır',
        () async {
      await roleController.setRole(UserRole.consumer);

      expect(roleController.role, UserRole.consumer);
      expect(roleController.isProducer, isFalse);
      expect(settingsBox.get('user_role'), 'consumer');
    });

    test('Uygulama yeniden başlatıldığında son seçilen rol korunur (kalıcılık)',
        () {
      // settingsBox içinde consumer var
      settingsBox.put('user_role', 'consumer');

      final newController = RoleController(settingsBox);
      expect(newController.role, UserRole.consumer);
      expect(newController.isProducer, isFalse);
      newController.dispose();
    });
  });
}
