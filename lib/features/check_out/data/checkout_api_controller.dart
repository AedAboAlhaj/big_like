import 'dart:convert';
import 'package:big_like/constants/api_settings.dart';
import 'package:big_like/features/check_out/domain/models/date_model.dart';
import 'package:big_like/features/check_out/domain/models/worker_model.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:big_like/local_storage/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../orders/domain/models/order_api_model.dart';
import '../../orders/domain/models/send_order_model.dart';
import '../domain/models/card_api_model.dart';

class CheckoutApiController {
  Future<List<DateModel>> getSchedule({required int optionId}) async {
    final token = await AppSecureStorage().getToken();

    var url = Uri.parse(
        '${ApiSettings.schedule}/$optionId?country_id=${AppSharedPref().countryId}');

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
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
    print(token);
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var productsJsonArray = jsonObject['data'] as List;

      return productsJsonArray
          .map((productJsonObject) => DateModel.fromJson(productJsonObject))
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

  Future<List<WorkerModel>> getWorkers({
    required String date,
    required String startTime,
    required int optionId,
  }) async {
    final token = await AppSecureStorage().getToken();

    var url = Uri.parse(ApiSettings.workers);
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    http.Response response;
    try {
      response = await http.post(url,
          headers: headers,
          body: jsonEncode(
              {"date": date, "start_time": startTime, "option_id": optionId}));
    } catch (e) {
      return [];
    }

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);

      var productsJsonArray = jsonObject['data'] as List;
      return productsJsonArray
          .map((productJsonObject) => WorkerModel.fromJson(productJsonObject))
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

  Future<String?> tokenPayment({
    required num total,
    required PaymentPortalInfo paymentPortalInfo,
    required CardApiModel cardApiModel,
  }) async {
    final token = await AppSecureStorage().getToken();
    var url = Uri.parse(
        'https://icom.yaad.net/p/?action=soft&Masof=${paymentPortalInfo.masof}&PassP=yaad&Amount=$total&CC=${cardApiModel.cardToken}&Tmonth=${cardApiModel.month}&Tyear=${cardApiModel.year}&UserId=${cardApiModel.idNumber}&ClientLName=Israeli&ClientName=Israel&Info=test-api&MoreData=True&Token=True');

    var response = await http.get(url, headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'content-type': 'application/json;encoding=utf-8'
    });
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode != 500) {
      //error msg

      return null;
    } else {
      //500 server error
    }

    return null;
  }

  Future<String?> getToken(
      {required num transId,
      required PaymentPortalInfo paymentPortalInfo}) async {
    var url = Uri.parse(
        'https://icom.yaad.net/p/?action=getToken&Masof=${paymentPortalInfo.masof}&TransId=$transId&PassP=${paymentPortalInfo.passp}');

    var response = await http.get(url, headers: <String, String>{
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode != 500) {
      //error msg

      return null;
    } else {
      //500 server error
    }

    return null;
  }

  Future<bool> deleteOrder(String orderId) async {
    var url = Uri.parse('${ApiSettings.orders}/$orderId');
    final token = await AppSecureStorage().getToken();

    http.Response response;
    try {
      response = await http.delete(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'content-type': 'application/json;encoding=utf-8'
        },
      );
    } catch (e) {
      return false;
    }

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode != 500) {
      return false;
    } else {}

    return false;
  }

  Future<bool> storePayment({required SendPaymentApiModel payment}) async {
    var url = Uri.parse(ApiSettings.payments);
    final token = await AppSecureStorage().getToken();

    var body = payment.toJson();
    var bytes = utf8.encode(json.encode(body));

    var response = await http.post(url,
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'content-type': 'application/json;encoding=utf-8'
        },
        body: bytes);

    // saveMobileLog(log: response.body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode != 500) {
      //error msg
      return false;
    } else {
      //500 server error
    }

    return false;
  }

  Future<bool> deleteCard(String cardId) async {
    var url = Uri.parse('${ApiSettings.cards}/$cardId');
    final token = await AppSecureStorage().getToken();

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'content-type': 'application/json;encoding=utf-8'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode != 500) {
      return false;
    } else {}

    return false;
  }

  Future<List<CardApiModel>> getCards() async {
    var url = Uri.parse(ApiSettings.cards);
    final token = await AppSecureStorage().getToken();

    var response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'content-type': 'application/json;encoding=utf-8'
      },
    );
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var productsJsonArray = jsonObject['data'] as List;

      return productsJsonArray
          .map((productJsonObject) => CardApiModel.fromJson(productJsonObject))
          .toList();
    } else if (response.statusCode != 500) {
      //error msg
    } else {
      //500 server error
    }

    return [];
  }

  Future<OrderResponse?> sendUserOrders(
      {required SendOrderModel order, bool isOrderService = true}) async {
    Uri url;
    if (isOrderService) {
      url = Uri.parse(ApiSettings.ordersService);
    } else {
      url = Uri.parse(ApiSettings.ordersProducts);
    }
    var body = order.toJson();
    var bytes = utf8.encode(json.encode(body));
    final token = await AppSecureStorage().getToken();

    var response = await http.post(url,
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'content-type': 'application/json;encoding=utf-8'
        },
        body: bytes);
    // print('-------->${order.toJson()}<----------');

    dynamic jsonObject;
    try {
      jsonObject = jsonDecode(response.body);
    } catch (e) {
      return null;
    }
    print(response.body);
    if (response.statusCode == 200) {
      // return OrderResponse.fromJson(jsonObject['data']);
      return OrderResponse(orderId: '', orderTimeDown: '');
    } else if (response.statusCode != 500) {
      //error msg
      return null;
    } else {
      //500 server error
    }
    return null;
  }

  Future<PaymentPortalInfo?> getPortalPaymentInfo() async {
    var url = Uri.parse(ApiSettings.paymentsInfo);
    final token = await AppSecureStorage().getToken();

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
      return null;
    }

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      // var productsJsonArray = jsonObject['data'] as List;
      return PaymentPortalInfo.fromJson(jsonObject['data']);
    } else if (response.statusCode != 500) {
      //error msg
      return null;
    } else {
      //500 server error
    }

    return null;
  }

/*
  Future<CouponApiModel?> checkCoupon(
      {required String coupon, required num cartTotal}) async {
    var url = Uri.parse('${ApiSettings.coupons}/$coupon/$cartTotal');

    var response = await http.get(url, headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AppSharedPref().token}',
      'content-type': 'application/json;encoding=utf-8'
    });
    var jsonObject = jsonDecode(response.body);

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);

      return CouponApiModel.fromJson(jsonObject['data']);
    } else if (response.statusCode != 500) {
      //error msg
      if (jsonObject['data'] == "invalid coupon") {
        showTopSnackBar(massage: 'الكوبون غير صحيح', error: true);
      } else if (jsonObject['data']
          .toString()
          .contains('Minimum cart should be atleast')) {
        showTopSnackBar(
            massage:
            '  يجب ان يكون اجمالي السلة (${jsonObject['data'].toString().split('atleast')[1].replaceAll(']', '')}) على الاقل لاستخدام الكوبون ',
            error: true,
            seconds: 5);
      } else {
        showTopSnackBar(massage: 'الكوبون منتهي الصلاحية', error: true);
      }
      return null;
    } else {
      //500 server error
    }

    return null;
  }
*/

  Future<String?> authCreditPayment(
      {required String phoneNum,
      required num total,
      required PaymentPortalInfo paymentPortalInfo}) async {
    var url = Uri.parse(
        'https://icom.yaad.net/p/?action=APISign&What=SIGN&KEY=${paymentPortalInfo.key}&PassP=${paymentPortalInfo.passp}&Masof=${paymentPortalInfo.masof}&tmp=7&Amount=$total&ClientLName=Isareli&ClientName=Israel&MoreData=True');
    final token = await AppSecureStorage().getToken();

    var response = await http.get(url, headers: <String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'content-type': 'application/json;encoding=utf-8'
    });
    // print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode != 500) {
      //error msg

      return null;
    } else {
      //500 server error
    }

    return null;
  }

/*  Future<bool> saveMobileLog({
    required String log,
  }) async {
    var url = Uri.parse(ApiSettings.mobileLog);

    var response = await http.post(url, headers: <String, String>{
      'Accept': 'application/json',
      // 'Authorization': 'Bearer ${AppSharedPref().token}',
      // 'content-type': 'application/json;encoding=utf-8'
    }, body: {
      'customer_id': AppSharedPref().userId.toString(),
      'error': log
    });
    // print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode != 500) {
      //error msg

      return false;
    } else {
      //500 server error
    }

    return false;
  }*/
}
