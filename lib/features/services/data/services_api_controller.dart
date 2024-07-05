import 'dart:convert';
import 'package:big_like/constants/api_settings.dart';
import 'package:big_like/features/check_out/domain/models/date_model.dart';
import 'package:big_like/features/services/domain/models/service_model.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:big_like/local_storage/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServicesApiController {
  Future<List<ServiceModel>> getServices() async {
    var url = Uri.parse(
        '${ApiSettings.services}?country_id=${AppSharedPref().countryId}');
    Map<String, String> headers = {
      'Accept': 'application/json',
    };
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: headers,
      );
    } catch (e) {
      return [];
    }

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);

      var productsJsonArray = jsonObject['data'] as List;
      return productsJsonArray
          .map((productJsonObject) => ServiceModel.fromJson(productJsonObject))
          .toList();

      // return smsResponse;
    } else if (response.statusCode != 500) {
      //error msg
      return [];
    } else {
      //500 server error
      return [];
    }
  }

  Future<ServiceModel?> showService({required int id}) async {
    var url = Uri.parse(
        '${ApiSettings.services}/$id?country_id=${AppSharedPref().countryId}');
    Map<String, String> headers = {
      'Accept': 'application/json',
    };

    http.Response response;
    try {
      response = await http.get(
        url,
        headers: headers,
      );
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);

      var productsJsonArray = jsonObject['data'];
      return ServiceModel.fromJson(productsJsonArray);
      // return smsResponse;
    } else if (response.statusCode != 500) {
      //error msg
      return null;
    } else {
      //500 server error
      return null;
    }
  }
}
