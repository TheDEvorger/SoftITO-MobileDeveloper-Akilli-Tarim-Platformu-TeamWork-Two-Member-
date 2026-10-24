import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../core/models/user_role.dart';

class RoleController extends ChangeNotifier {
  RoleController(Box<String> settings)
      : _settings = settings,
        _role = UserRole.fromStorage(settings.get('user_role'));

  final Box<String> _settings;
  UserRole _role;

  UserRole get role => _role;
  bool get isProducer => _role.isProducer;

  Future<void> setRole(UserRole value) async {
    if (_role == value) return;
    await _settings.put('user_role', value.name);
    _role = value;
    notifyListeners();
  }
}
