import 'package:big_like/features/products/domain/models/products_api_model.dart';
import 'package:big_like/features/services/domain/models/service_model.dart';
import 'package:big_like/local_storage/shared_preferences.dart';

class SendOrderModel {
  SendOrderModel();

  int? workerId;
  String? time;

  // String? endTime;
  String? date;
  Options? options;
  String? paymentMethod;
  int? cityId;
  String? address;
  String? note;
  String? coupon;
  List<ProductApiModel> products = [];

/*
  SendOrderModel.fromJson(Map<String, dynamic> json){
    workerId = json['worker_id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    date = json['date'];
    s = json['option_id'];
    paymentMethod = json['payment_method'];
    cityId = json['city_id'];
    address = json['address'];
    note = json['note'];
  }
*/

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['worker_id'] = workerId;
    _data['time'] = time;
    // _data['end_time'] = endTime;
    _data['date'] = date;
    _data['option_id'] = options?.id;
    _data['payment_method'] = paymentMethod == 'cash' ? 0 : 1;
    _data['city_id'] = AppSharedPref().countryId;
    _data['address'] = address;
    _data['note'] = note;
    _data['coupon'] = coupon;
    _data['products'] = products.map((e) => e.toJson()).toList();
    return _data;
  }
}
