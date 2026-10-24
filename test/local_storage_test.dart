import 'dart:convert';
import 'dart:io';

import 'package:akilli_tarim_platformu/app/role_controller.dart';
import 'package:akilli_tarim_platformu/core/models/user_role.dart';
import 'package:akilli_tarim_platformu/core/storage/seed_loader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory temporary;

  setUp(() async {
    temporary = await Directory.systemTemp.createTemp('farm_hive_test_');
    Hive.init(temporary.path);
  });

  tearDown(() async {
    await Hive.close();
    if (await temporary.exists()) await temporary.delete(recursive: true);
  });

  test('Seed eksik kayıtları ekler ve kullanıcı değişikliğini ezmez', () async {
    final products = await Hive.openBox<String>('products_test');
    final settings = await Hive.openBox<String>('settings_test');
    final data = {
      'products': [
        {'id': 'demo1', 'title': 'Eski buğday'}
      ],
    };
    await products.put(
        'demo1', jsonEncode({'id': 'demo1', 'title': 'Benim ilanım'}));
    final boxes = <String, Box<String>>{'products': products};
    for (final key in SeedLoader.collectionKeys) {
      if (key == 'products') continue;
      boxes[key] = await Hive.openBox<String>('test_$key');
    }
    await SeedLoader.seedFromMap(data: data, boxes: boxes, settings: settings);
    expect(jsonDecode(products.get('demo1')!)['title'], 'Benim ilanım');
    await SeedLoader.seedFromMap(data: data, boxes: {}, settings: settings);
    expect(products.length, 1);
  });

  test('Rol seçimi Hive üzerinde saklanır', () async {
    final settings = await Hive.openBox<String>('role_settings');
    final controller = RoleController(settings);
    expect(controller.role, UserRole.producer);
    await controller.setRole(UserRole.consumer);
    final reloaded = RoleController(settings);
    expect(reloaded.role, UserRole.consumer);
    controller.dispose();
    reloaded.dispose();
  });
}
