import 'dart:convert';
import 'package:big_like/constants/api_settings.dart';
import 'package:big_like/features/home/domain/models/banner_api_model.dart';
import 'package:http/http.dart' as http;

class HomeApiController {
  Future<List<BannerApiModel>> getBanners() async {
    var url = Uri.parse(ApiSettings.banners);
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
          'content-type': 'application/json;encoding=utf-8'
        },
      );
    } catch (e) {
      return [];
    }

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var productsJsonArray = (jsonObject['data'] as List);

      var list = productsJsonArray
          .map((productJsonObject) =>
          BannerApiModel.fromJson(productJsonObject))
          .toList();
      return list;
    } else if (response.statusCode != 500) {
      //error msg
    } else {
      //500 server error
    }

    return [];
  }
}
