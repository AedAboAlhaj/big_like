import 'dart:convert';
import 'package:big_like/constants/api_settings.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import '../domain/models/worker_order_model.dart';

class WorkerOrdersApiController {
  Future<List<WorkerOrderModel>> getWorkerOrders() async {
    final token = await AppSecureStorage().getToken();
    var url = Uri.parse(ApiSettings.workersOrders);
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
    print(response.body);
    print(token);
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var productsJsonArray = (jsonObject['data']['data'] as List);

      var list = productsJsonArray
          .map((productJsonObject) =>
              WorkerOrderModel.fromJson(productJsonObject))
          .toList();
      return list;
    } else if (response.statusCode != 500) {
      //error msg
    } else {
      //500 server error
    }

    return [];
  }

  Future<bool> updateOrderStatus({required int orderId}) async {
    var url = Uri.parse('${ApiSettings.workersOrdersStatus}/$orderId');
    final token = await AppSecureStorage().getToken();

    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    var response = await http.put(
      url,
      headers: headers,
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode != 500) {
      //error message
      return false;
    } else {
      //500 server error
      return false;
    }
  }
}
