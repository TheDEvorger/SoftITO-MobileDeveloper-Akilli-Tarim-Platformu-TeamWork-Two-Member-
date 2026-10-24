import 'dart:convert';
import 'package:akilli_tarim_platformu/core/storage/json_box_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class FakeBox<T> implements Box<T> {
  final Map<dynamic, T> _map = {};
  late final ValueNotifier<Box<T>> _notifier = ValueNotifier<Box<T>>(this);

  @override
  Iterable<dynamic> get keys => _map.keys;

  @override
  int get length => _map.length;

  @override
  bool get isEmpty => _map.isEmpty;

  @override
  bool get isNotEmpty => _map.isNotEmpty;

  @override
  bool get isOpen => true;

  @override
  String? get path => null;

  @override
  String get name => 'fake_box';

  @override
  bool containsKey(dynamic key) => _map.containsKey(key);

  @override
  T? get(dynamic key, {T? defaultValue}) => _map[key] ?? defaultValue;

  @override
  T? getAt(int index) => _map.values.elementAt(index);

  @override
  Future<int> add(T value) async {
    final nextKey = _map.length;
    _map[nextKey] = value;
    _notifier.value = this;
    return nextKey;
  }

  @override
  Future<Iterable<int>> addAll(Iterable<T> values) async {
    final keys = <int>[];
    for (final v in values) {
      keys.add(await add(v));
    }
    return keys;
  }

  @override
  Future<void> put(dynamic key, T value) async {
    _map[key] = value;
    _notifier.value = this;
  }

  @override
  Future<void> putAt(int index, T value) async {
    final key = _map.keys.elementAt(index);
    _map[key] = value;
    _notifier.value = this;
  }

  @override
  Future<void> putAll(Map<dynamic, T> entries) async {
    _map.addAll(entries);
    _notifier.value = this;
  }

  @override
  Future<void> delete(dynamic key) async {
    _map.remove(key);
    _notifier.value = this;
  }

  @override
  Future<void> deleteAt(int index) async {
    final key = _map.keys.elementAt(index);
    _map.remove(key);
    _notifier.value = this;
  }

  @override
  Future<void> deleteAll(Iterable<dynamic> keys) async {
    for (final k in keys) {
      _map.remove(k);
    }
    _notifier.value = this;
  }

  @override
  Future<int> clear() async {
    final count = _map.length;
    _map.clear();
    _notifier.value = this;
    return count;
  }

  @override
  Future<void> flush() async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> compact() async {}

  @override
  Iterable<T> get values => _map.values;

  @override
  Iterable<T> valuesBetween({dynamic startKey, dynamic endKey}) => _map.values;

  @override
  T? keyAt(int index) => _map.keys.elementAt(index);

  @override
  Map<dynamic, T> toMap() => Map.unmodifiable(_map);

  @override
  Stream<BoxEvent> watch({dynamic key}) => const Stream.empty();

  @override
  bool get lazy => false;

  @override
  Future<void> deleteFromDisk() async => _map.clear();

  ValueListenable<Box<T>> listenable({List<dynamic>? keys}) {
    return _notifier;
  }
}

JsonBoxRepository<T> createFakeRepository<T>({
  required T Function(Map<String, dynamic>) decoder,
  required Map<String, dynamic> Function(T) encoder,
  required String Function(T) idOf,
  List<T> initialData = const [],
}) {
  final box = FakeBox<String>();
  for (final item in initialData) {
    box.put(idOf(item), jsonEncode(encoder(item)));
  }

  return JsonBoxRepository<T>(
    box: box,
    decoder: decoder,
    encoder: encoder,
    idOf: idOf,
  );
}
