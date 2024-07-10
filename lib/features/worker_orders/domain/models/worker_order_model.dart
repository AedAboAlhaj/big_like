class WorkerOrderModel {
  WorkerOrderModel({
    required this.id,
    required this.status,
    this.onWayTime,
    this.doneTime,
    this.canceledTime,
    required this.pendingTime,
    required this.paymentMethod,
    required this.customerInfo,
    required this.name,
    required this.image,
    required this.cost,
    required this.discount,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.option,
    this.note,
  });

  late final int id;
  late final int status;
  late final DateTime? onWayTime;
  late final DateTime? doneTime;
  late final DateTime? canceledTime;
  late final DateTime? pendingTime;
  late final String paymentMethod;
  late final CustomerInfo customerInfo;
  late final String name;
  late final String image;
  late final num cost;
  late final int discount;
  late final String startTime;
  late final String endTime;
  late final String date;
  late final String option;
  late final Null note;

  WorkerOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    onWayTime = DateTime.tryParse(json['on_way_time'] ?? '');
    doneTime = DateTime.tryParse(json['done_time'] ?? '');
    canceledTime = DateTime.tryParse(json['canceled_time'] ?? '');
    pendingTime = DateTime.tryParse(json['pending_time'] ?? '');
    paymentMethod = json['payment_method'] == 0 ? 'cash' : 'visa';

    customerInfo = CustomerInfo.fromJson(json['customerInfo']);
    name = json['name'];
    image = json['image'];
    cost = json['cost'];
    discount = json['discount'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    date = json['date'];
    option = json['option'];
    note = null;
  }
}

class CustomerInfo {
  CustomerInfo({
    required this.phone,
    required this.name,
    required this.address,
    this.country,
    required this.city,
  });

  late final String phone;
  late final String name;
  late final String address;
  late final Null country;
  late final String city;

  CustomerInfo.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    name = json['name'];
    address = json['address'];
    country = null;
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['phone'] = phone;
    _data['name'] = name;
    _data['address'] = address;
    _data['country'] = country;
    _data['city'] = city;
    return _data;
  }
}
