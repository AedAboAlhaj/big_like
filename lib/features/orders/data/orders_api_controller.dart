import 'dart:convert';
import 'package:big_like/constants/api_settings.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import '../domain/models/order_api_model.dart';

class OrdersApiController {
  Future<List<OrderApiModel>> getUserOrders() async {
    final token = await AppSecureStorage().getToken();
    var url = Uri.parse(ApiSettings.orders);
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'content-type': 'application/json;encoding=utf-8'
        },
      );
    } catch (e) {
      return [];
    }
    print(token);
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var productsJsonArray = (jsonObject['data'] as List);

      var list = productsJsonArray
          .map((productJsonObject) => OrderApiModel.fromJson(productJsonObject))
          .toList();
      list.removeWhere((element) => element.status == '');
      return list;
    } else if (response.statusCode != 500) {
      //error msg
    } else {
      //500 server error
    }

    return [];
  }
}
