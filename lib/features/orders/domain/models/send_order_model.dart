import 'package:big_like/features/services/domain/models/service_model.dart';

class SendOrderModel {
  SendOrderModel();

  int? workerId;
  String? startTime;
  String? endTime;
  String? date;
  Options? options;
  String? paymentMethod;
  int? cityId;
  String? address;
  String? note;
  String? coupon;

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
    _data['start_time'] = startTime;
    _data['end_time'] = endTime;
    _data['date'] = date;
    _data['option_id'] = options?.id;
    _data['payment_method'] = paymentMethod;
    _data['city_id'] = cityId;
    _data['address'] = address;
    _data['note'] = note;
    _data['coupon'] = coupon;
    return _data;
  }
}
