import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecureStorage {
  static final AppSecureStorage _instance = AppSecureStorage._();
  late FlutterSecureStorage _storage;

  AppSecureStorage._();

  factory AppSecureStorage() {
    return _instance;
  }

  Future initSecureStorage() async {
    _storage = const FlutterSecureStorage();
  }

  static const String tokenKey = 'token';
  static const String phoneKey = 'phone';

  ///***TOKEN***///
  Future deleteToken() async {
    await _storage.delete(key: tokenKey);
  }

  Future setToken(String x) async {
    await _storage.write(key: tokenKey, value: x);
  }

  Future<String?> getToken() async {
    var res = await _storage.read(key: tokenKey);
    return res;
  }

  Future clean() async {
    await _storage.deleteAll();
  }

  ///***PHONE NUMBER***///
  Future deletePhone() async {
    await _storage.delete(key: phoneKey);
  }

  Future setPhone(String x) async {
    await _storage.write(key: phoneKey, value: x);
  }

  Future getPhone() async {
    var res = await _storage.read(key: phoneKey);
    return res;
  }
}
