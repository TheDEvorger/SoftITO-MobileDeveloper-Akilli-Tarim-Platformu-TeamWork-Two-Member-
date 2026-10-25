import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class SeedLoader {
  const SeedLoader._();

  static const _seedMarker = 'mock_seed_version';
  static const _seedVersion = '7';
  static const collectionKeys = [
    'products',
    'offers',
    'animals',
    'greenhouses',
    'serviceProviders',
  ];

  static Future<void> loadAsset({
    required Map<String, Box<String>> boxes,
    required Box<String> settings,
  }) async {
    final anyBoxEmpty = collectionKeys.any((k) => boxes[k]?.isEmpty ?? false);
    if (!anyBoxEmpty && settings.get(_seedMarker) == _seedVersion) return;
    final jsonText = await rootBundle.loadString('assets/mock_farms.json');
    final data = Map<String, dynamic>.from(jsonDecode(jsonText) as Map);
    await seedFromMap(data: data, boxes: boxes, settings: settings);
  }

  /// Test edilebilir: eksik kimlikleri ekler, kullanıcı verisini korur.
  static Future<void> seedFromMap({
    required Map<String, dynamic> data,
    required Map<String, Box<String>> boxes,
    required Box<String> settings,
  }) async {
    final anyBoxEmpty = collectionKeys.any((k) => boxes[k]?.isEmpty ?? false);
    final isNewVersion = settings.get(_seedMarker) != _seedVersion;
    if (!anyBoxEmpty && !isNewVersion) return;

    for (final key in collectionKeys) {
      final records = data[key];
      if (records is! List) continue;
      final box = boxes[key];
      if (box == null) throw StateError('$key Hive kutusu eksik');
      for (final entry in records) {
        if (entry is! Map) continue;
        final record = Map<String, dynamic>.from(entry);
        final id = record['id'];
        if (id is! String || id.isEmpty || box.containsKey(id)) continue;
        await box.put(id, jsonEncode(record));
      }
    }
    await settings.put(_seedMarker, _seedVersion);
  }
}
