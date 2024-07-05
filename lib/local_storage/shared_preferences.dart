import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPref {
  static final AppSharedPref _instance = AppSharedPref._();
  late SharedPreferences _sharedPreferences;

  AppSharedPref._();

  factory AppSharedPref() {
    return _instance;
  }

  // setBooleanValue(String key, bool value) async {
  //   SharedPreferences myPrefs = await SharedPreferences.getInstance();
  //   myPrefs.setBool(key, value);
  // }
  //
  // Future<bool> getBooleanValue(String key) async {
  //   SharedPreferences myPrefs = await SharedPreferences.getInstance();
  //   return myPrefs.getBool(key) ?? false;
  // }
  Future initSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  ///Country///
  Future saveCountryId({required int countryId}) async =>
      await _sharedPreferences.setInt('countryId', countryId);

  int? get countryId => _sharedPreferences.getInt('countryId');

  ///Language///
  Future saveLanguageLocale({required String languageLocale}) async =>
      await _sharedPreferences.setString('languageLocale', languageLocale);

  String? get languageLocale =>
      _sharedPreferences.getString('languageLocale') ?? 'ar';

  ///USER TYPE///
  Future saveUserType({required String userType}) async =>
      await _sharedPreferences.setString('userType', userType);

  String get userType => _sharedPreferences.getString('userType') ?? '';

  ///order///
  Future saveOrderId({required String orderId}) async =>
      await _sharedPreferences.setString('orderId', orderId);

  String get orderId => _sharedPreferences.getString('orderId') ?? '';

  Future saveLastOrderTime({required String lastOrderTime}) async =>
      await _sharedPreferences.setString('lastOrderTime', lastOrderTime);

  String get lastOrderTime =>
      _sharedPreferences.getString('lastOrderTime') ?? '';

  Future clear() async {
    return await _sharedPreferences.clear();
  }
}
