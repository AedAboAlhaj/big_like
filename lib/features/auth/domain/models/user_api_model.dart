import 'package:big_like/local_storage/shared_preferences.dart';

class UserApiModel {
  UserApiModel();

  late final String token;
  late final String phone;
  late final String name;

  UserApiModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'] ?? '';
    name = json['name'] ?? '';
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['phone'] = phone;
    data['country_id'] = AppSharedPref().countryId;

    return data;
  }
}
