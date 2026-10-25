import 'dart:io';

import 'package:akilli_tarim_platformu/core/models/product.dart';
import 'package:akilli_tarim_platformu/core/storage/json_box_repository.dart';
import 'package:akilli_tarim_platformu/features/marketplace/domain/marketplace_filter.dart';
import 'package:akilli_tarim_platformu/features/marketplace/presentation/controllers/add_product_controller.dart';
import 'package:akilli_tarim_platformu/features/marketplace/presentation/controllers/marketplace_filter_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('mkt_hive_test_');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.close();
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  final dummyProduct = Product(
    id: 'p1',
    sellerId: 'demo_producer_001',
    title: 'Organik Buğday',
    category: 'Tahıl',
    quantity: 500,
    unit: 'kg',
    unitPrice: 15.5,
    city: 'Konya',
    district: 'Çumra',
    imagePath: 'assets/images/wheat.png',
    sellerPhone: '05551112233',
    description: 'Sertifikalı organik buğday',
    createdAt: DateTime.now().toIso8601String(),
  );

  test('MarketplaceFilter kategori, şehir ve arama filtresini doğru uygular',
      () {
    const filterAll = MarketplaceFilter();
    expect(filterAll.matches(dummyProduct), isTrue);

    const filterMismatchCat = MarketplaceFilter(category: 'Meyve');
    expect(filterMismatchCat.matches(dummyProduct), isFalse);

    const filterMatchCity = MarketplaceFilter(category: 'Tahıl', city: 'Konya');
    expect(filterMatchCity.matches(dummyProduct), isTrue);

    const filterSearch = MarketplaceFilter(searchQuery: 'organik');
    expect(filterSearch.matches(dummyProduct), isTrue);

    const filterMismatchSearch = MarketplaceFilter(searchQuery: 'elma');
    expect(filterMismatchSearch.matches(dummyProduct), isFalse);
  });

  test('MarketplaceFilterController filtre durumunu günceller ve sıfırlar', () {
    final controller = MarketplaceFilterController();
    controller.setCategory('Tahıl');
    controller.setCity('Konya');
    controller.setSearchQuery('Buğday');

    expect(controller.filter.category, 'Tahıl');
    expect(controller.filter.city, 'Konya');
    expect(controller.filter.searchQuery, 'Buğday');

    final filtered = controller.apply([dummyProduct]);
    expect(filtered.length, 1);

    controller.reset();
    expect(controller.filter.category, 'Tümü');
    expect(controller.filter.city, 'Tümü');
    expect(controller.filter.searchQuery, isEmpty);
  });

  test('AddProductController demo_producer_001 ile Hive üzerine kayıt yapar',
      () async {
    final box = await Hive.openBox<String>('products_add_test');
    final repo = JsonBoxRepository<Product>(
      box: box,
      decoder: Product.fromJson,
      encoder: (p) => p.toJson(),
      idOf: (p) => p.id,
    );

    final controller = AddProductController(productsRepository: repo);

    final saved = await controller.saveProduct(
      title: 'Amasya Elması',
      category: 'Meyve',
      quantity: 250,
      unit: 'kg',
      unitPrice: 35.0,
      city: 'Amasya',
      district: 'Merkez',
      sellerPhone: '05559998877',
      description: 'Yeni hasat tatlı elma',
    );

    expect(saved.sellerId, 'demo_producer_001');
    expect(saved.title, 'Amasya Elması');
    expect(saved.quantity, 250);
    expect(repo.find(saved.id), isNotNull);
    expect(repo.find(saved.id)!.category, 'Meyve');
  });

  test('Product copyWith alanları doğru günceller', () {
    final updated = dummyProduct.copyWith(quantity: 1200, unitPrice: 20.0);
    expect(updated.quantity, 1200);
    expect(updated.unitPrice, 20.0);
    expect(updated.title, dummyProduct.title);
    expect(updated.sellerId, dummyProduct.sellerId);
  });
}
