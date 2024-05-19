import 'dart:convert';

import 'package:get_storage/get_storage.dart';

class CacheStore {
  final String name;
  final GetStorage _storage;

  CacheStore({
    this.name = 'cache',
  }) : _storage = GetStorage(name)..initStorage;

  void put(String key, Map<String, dynamic> object) {
    _storage.write(key, jsonEncode(object));
  }

  void remove(String key) {
    _storage.write(key, null);
  }

  Map<String, dynamic>? get(String key) {
    if (!_storage.hasData(key)) {
      return null;
    }
    return jsonDecode(_storage.read(key));
  }
}
