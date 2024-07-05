import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../constants/api_settings.dart';
import '../domain/models/products_api_model.dart';

class ProductsApiController {
  Future<List<ProductApiModel>> getProducts() async {
    var url = Uri.parse(ApiSettings.products);

    print(url);
    http.Response response;
    try {
      response = await http.get(url);
    } catch (e) {
      return [];
    }
    print(response.body);
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var productsJsonArray = jsonObject['data']['data'] as List;
      var list = productsJsonArray
          .map((productJsonObject) =>
              ProductApiModel.fromJson(productJsonObject))
          .toList();
      return list;
    } else if (response.statusCode != 500) {
      //error message
    } else {
      //500 server error
    }

    return [];
  }
}
