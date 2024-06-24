import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constants/api_settings.dart';
import '../domain/models/app_settings_api_model.dart';
import '../domain/models/company_profile_page_api_model.dart';

class SettingsApiController {
  Future<AppSettingsApiModel?> settings() async {
    var url = Uri.parse(ApiSettings.settings);
    http.Response response;
    try {
      response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
    } catch (e) {
      return null;
    }
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);

      return AppSettingsApiModel.fromJson(jsonObject['data']);
    } else if (response.statusCode != 500) {
      //error msg
      return null;
    } else {
      //500 server error
      return null;
    }
  }

  Future<List<CompanyProfilePageApiModel>> getCompanyProfilePages() async {
    var url = Uri.parse(ApiSettings.companyProfilePages);
    http.Response response;
    try {
      response = await http.get(url);
    } catch (e) {
      return [];
    }
    // print('${ApiSettings.products}/$id/$lat/$lng');
    // print(response.body);
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var productsJsonArray = jsonObject['data'] as List;
      var list = productsJsonArray
          .map((productJsonObject) =>
              CompanyProfilePageApiModel.fromJson(productJsonObject))
          .toList();
      list.removeWhere((element) => !element.status);
      return list;
    } else if (response.statusCode != 500) {
      //error msg
    } else {
      //500 server error
    }

    return [];
  }
}
