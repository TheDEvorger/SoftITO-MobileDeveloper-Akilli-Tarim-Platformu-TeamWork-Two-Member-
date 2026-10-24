import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Ortak veri sözleşmesi: Hive Box<String> içinde JSON kaydı; key = id.
/// Gerçek backend eklendiğinde UI bu arayüzün yerine yeni repository kullanabilir.
class JsonBoxRepository<T> {
  const JsonBoxRepository({
    required Box<String> box,
    required T Function(Map<String, dynamic>) decoder,
    required Map<String, dynamic> Function(T) encoder,
    required String Function(T) idOf,
  })  : _box = box,
        _decoder = decoder,
        _encoder = encoder,
        _idOf = idOf;

  final Box<String> _box;
  final T Function(Map<String, dynamic>) _decoder;
  final Map<String, dynamic> Function(T) _encoder;
  final String Function(T) _idOf;

  ValueListenable<Box<String>> get changes => _box.listenable();

  T? find(String id) {
    final raw = _box.get(id);
    if (raw == null) return null;
    try {
      return _decoder(Map<String, dynamic>.from(jsonDecode(raw) as Map));
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  List<T> all() {
    final results = <T>[];
    for (final key in _box.keys) {
      final value = find(key.toString());
      if (value != null) results.add(value);
    }
    return results;
  }

  Future<void> put(T record) async {
    final id = _idOf(record);
    if (id.trim().isEmpty) throw ArgumentError('Kayıt kimliği boş olamaz');
    await _box.put(id, jsonEncode(_encoder(record)));
  }

  Future<void> delete(String id) => _box.delete(id);
}
