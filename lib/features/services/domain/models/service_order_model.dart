import 'package:big_like/features/check_out/domain/models/worker_model.dart';

class ServiceOrderModel {
  ServiceOrderModel({
    required this.name,
    required this.image,
    required this.cost,
    required this.discount,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.option,
    required this.worker,
  });

  late final String name;
  late final String image;
  late final num cost;
  late final num discount;
  late final String startTime;
  late final String endTime;
  late final String date;
  late final String option;
  late final WorkerModel worker;

  ServiceOrderModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    cost = json['cost'];
    discount = json['discount'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    date = json['date'];
    option = json['option'];
    worker = WorkerModel.fromJson(json['worker']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['image'] = image;
    _data['cost'] = cost;
    _data['discount'] = discount;
    _data['start_time'] = startTime;
    _data['end_time'] = endTime;
    _data['date'] = date;
    _data['option'] = option;
    _data['worker'] = worker.toJson();
    return _data;
  }
}
