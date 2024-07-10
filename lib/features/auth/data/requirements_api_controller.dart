import 'dart:convert';
import 'package:big_like/constants/api_settings.dart';
import 'package:big_like/features/auth/domain/models/suported_country_model.dart';
import 'package:big_like/features/auth/domain/models/suported_lang_model.dart';
import 'package:http/http.dart' as http;

class RequirementsApiController {
  Future<List<SupportedCountryModel>> getSupportedCountries() async {
    var url = Uri.parse(ApiSettings.requirements);
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
    print(response.body);
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);

      var productsJsonArray = jsonObject['data']['countries'] as List;
      return productsJsonArray
          .map((productJsonObject) =>
              SupportedCountryModel.fromJson(productJsonObject))
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

  Future<List<SupportedLangModel>> getSupportedLang() async {
    var url = Uri.parse(ApiSettings.requirements);
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

      var productsJsonArray = jsonObject['data']['langs'] as List;
      return productsJsonArray
          .map((productJsonObject) =>
              SupportedLangModel.fromJson(productJsonObject))
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
}
