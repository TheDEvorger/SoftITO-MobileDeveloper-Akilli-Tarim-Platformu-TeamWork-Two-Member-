import 'package:hive_flutter/hive_flutter.dart';

import '../models/animal.dart';
import '../models/greenhouse.dart';
import '../models/offer.dart';
import '../models/product.dart';
import '../models/service_provider.dart';
import 'json_box_repository.dart';
import 'seed_loader.dart';

class AppStorage {
  const AppStorage._({
    required this.products,
    required this.offers,
    required this.animals,
    required this.greenhouses,
    required this.serviceProviders,
    required this.settings,
  });

  final JsonBoxRepository<Product> products;
  final JsonBoxRepository<Offer> offers;
  final JsonBoxRepository<Animal> animals;
  final JsonBoxRepository<Greenhouse> greenhouses;
  final JsonBoxRepository<ServiceProvider> serviceProviders;
  final Box<String> settings;

  static Future<AppStorage> initialize() async {
    await Hive.initFlutter();
    final productBox = await Hive.openBox<String>('products');
    final offerBox = await Hive.openBox<String>('offers');
    final animalBox = await Hive.openBox<String>('animals');
    final greenhouseBox = await Hive.openBox<String>('greenhouses');
    final serviceBox = await Hive.openBox<String>('serviceProviders');
    final settings = await Hive.openBox<String>('settings');

    await SeedLoader.loadAsset(
      boxes: {
        'products': productBox,
        'offers': offerBox,
        'animals': animalBox,
        'greenhouses': greenhouseBox,
        'serviceProviders': serviceBox,
      },
      settings: settings,
    );

    return AppStorage._(
      products: JsonBoxRepository(
        box: productBox,
        decoder: Product.fromJson,
        encoder: (p) => p.toJson(),
        idOf: (p) => p.id,
      ),
      offers: JsonBoxRepository(
        box: offerBox,
        decoder: Offer.fromJson,
        encoder: (p) => p.toJson(),
        idOf: (p) => p.id,
      ),
      animals: JsonBoxRepository(
        box: animalBox,
        decoder: Animal.fromJson,
        encoder: (p) => p.toJson(),
        idOf: (p) => p.id,
      ),
      greenhouses: JsonBoxRepository(
        box: greenhouseBox,
        decoder: Greenhouse.fromJson,
        encoder: (p) => p.toJson(),
        idOf: (p) => p.id,
      ),
      serviceProviders: JsonBoxRepository(
        box: serviceBox,
        decoder: ServiceProvider.fromJson,
        encoder: (p) => p.toJson(),
        idOf: (p) => p.id,
      ),
      settings: settings,
    );
  }

  factory AppStorage.fromBoxes({
    required Box<String> productBox,
    required Box<String> offerBox,
    required Box<String> animalBox,
    required Box<String> greenhouseBox,
    required Box<String> serviceBox,
    required Box<String> settingsBox,
  }) =>
      AppStorage._(
        products: JsonBoxRepository(
          box: productBox,
          decoder: Product.fromJson,
          encoder: (p) => p.toJson(),
          idOf: (p) => p.id,
        ),
        offers: JsonBoxRepository(
          box: offerBox,
          decoder: Offer.fromJson,
          encoder: (p) => p.toJson(),
          idOf: (p) => p.id,
        ),
        animals: JsonBoxRepository(
          box: animalBox,
          decoder: Animal.fromJson,
          encoder: (p) => p.toJson(),
          idOf: (p) => p.id,
        ),
        greenhouses: JsonBoxRepository(
          box: greenhouseBox,
          decoder: Greenhouse.fromJson,
          encoder: (p) => p.toJson(),
          idOf: (p) => p.id,
        ),
        serviceProviders: JsonBoxRepository(
          box: serviceBox,
          decoder: ServiceProvider.fromJson,
          encoder: (p) => p.toJson(),
          idOf: (p) => p.id,
        ),
        settings: settingsBox,
      );
}
