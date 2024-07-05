import 'package:big_like/features/products/domain/models/products_api_model.dart';

import '../../../services/domain/models/service_model.dart';
import '../../../services/domain/models/service_order_model.dart';

class WorkerOrderApiModel {
  WorkerOrderApiModel({
    required this.id,
    required this.status,
    this.onWayTime,
    this.doneTime,
    this.canceledTime,
    required this.pendingTime,
    required this.paymentMethod,
    required this.customerInfo,
    required this.service,
    required this.products,
    required this.productsInfo,
    required this.total,
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
  late final ServiceOrderModel? service;
  late final List<ProductApiModel> products;
  late final ProductsInfo? productsInfo;

  late final num total;
  late final String? note;

  WorkerOrderApiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    onWayTime = DateTime.tryParse(json['on_way_time'] ?? '');
    doneTime = DateTime.tryParse(json['done_time'] ?? '');
    canceledTime = DateTime.tryParse(json['canceled_time'] ?? '');
    pendingTime = DateTime.tryParse(json['pending_time'] ?? '');
    paymentMethod = json['payment_method'] == 0 ? 'cash' : 'visa';
    customerInfo = CustomerInfo.fromJson(json['customerInfo']);
    service = json['service'] != null
        ? ServiceOrderModel.fromJson(json['service'])
        : null;
    products = List.from(json['products'])
        .map((e) => ProductApiModel.fromJson(e))
        .toList();
    productsInfo = json['productsInfo'] != null
        ? ProductsInfo.fromJson(json['productsInfo'])
        : null;
    total = json['total'] ?? 0;
    note = json['note'] ?? '';
  }
}

class CustomerInfo {
  CustomerInfo({
    required this.address,
    this.country,
    required this.city,
  });

  late final String address;
  late final Null country;
  late final String city;

  CustomerInfo.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    country = null;
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address'] = address;
    data['country'] = country;
    data['city'] = city;
    return data;
  }
}

class OrderResponse {
  OrderResponse({
    required this.orderId,
    required this.orderTimeDown,
  });

  late final String orderId;
  late final String orderTimeDown;

  OrderResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['order'];
    orderTimeDown = json['order_time_down'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['order'] = orderId;
    data['order_time_down'] = orderTimeDown;
    return data;
  }
}

class PaymentPortalInfo {
  PaymentPortalInfo({
    required this.key,
    required this.masof,
    required this.passp,
  });

  late final String key;
  late final String masof;
  late final String passp;

  PaymentPortalInfo.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    masof = json['masof'];
    passp = json['passp'];
  }

// Map<String, dynamic> toJson() {
//   final _data = <String, dynamic>{};
//
//   _data['order'] = orderId;
//   _data['order_time_down'] = orderTimeDown;
//   return _data;
// }
}

class Address {
  Address({
    required this.id,
    required this.customerId,
    required this.longitude,
    required this.latitude,
    this.addressName,
    this.addressDetails,
    required this.specialMarque,
    required this.km,
    required this.createdAt,
    required this.updatedAt,
  });

  late final int id;
  late final int customerId;
  late final String longitude;
  late final String latitude;
  late final String? addressName;
  late final String? addressDetails;
  late final String specialMarque;
  late final num km;
  late final String createdAt;
  late final String updatedAt;

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    addressName = json['address_name'];
    addressDetails = json['address_details'];
    specialMarque = json['special_marque'];
    km = json['km'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['customer_id'] = customerId;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['address_name'] = addressName;
    data['address_details'] = addressDetails;
    data['special_marque'] = specialMarque;
    data['km'] = km;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

/*
class SendOrderApiModel {
  SendOrderApiModel();

  int? addressId;
  num? distanceInKm;
  num? longitude;
  num? latitude;
  num? totalCart;
  num? storageId;
  String? specialMarque;
  String? addressDetails;
  String? coupon;
  String? note;
  String? paymentMethod;
  String? deliveryTime;
  String? taxId;
  String? taxName;
  late List<ProductSendOrder> products;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address_id'] = addressId;
    data['km'] = distanceInKm;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['special_marque'] = specialMarque;
    data['address_details'] = addressDetails;
    data['coupon'] = coupon;
    data['note'] = note;
    data['payment_method'] = paymentMethod;
    data['delivery_time'] = deliveryTime;
    data['total_cart'] = totalCart;
    data['storage_id'] = storageId;
    data['tax_id'] = taxId;
    data['tax_name'] = taxName;
    data['products'] = products.map((e) => e.toJson()).toList();
    return data;
  }
}
*/

class ProductSendOrder {
  ProductSendOrder();

  late int id;
  int? campaignId;
  late int quantity;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['campaign_id'] = campaignId;
    data['quantity'] = quantity;

    return data;
  }
}

class SendPaymentApiModel {
  SendPaymentApiModel();

  String? orderId;

  int? transactionId;
  String? cCode;
  num? amount;
  String? field_1;
  String? field_2;
  String? field_3;
  String? token;
  String? deliveryStartTime;
  String? idNumber;
  String? last4Numbers;
  String? year;
  String? month;
  int? cartId;

  SendPaymentApiModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    deliveryStartTime = json['delivery_time'];
    transactionId = json['transaction_id'];
    cCode = json['ccode'];
    amount = json['amount'];
    cartId = json['cart_id'];
    token = json['token'];
    idNumber = json['id_number'];
    last4Numbers = json['last_4_numbers'];
    year = json['year'];
    month = json['month'];
    field_1 = json['field_1'];
    field_2 = json['field_2'];
    field_3 = json['field_3'];
  }

/*  {
  "address_id":1,
  "km":null,
  "longitude": null,
  "latitude":null,
  "special_marque": null,
  "cart_id": null,
  "coupon": null,
  "payment_method": "cash",
  "delivery_time" :null // Select times from (Delivery times )  Y-m-d H:i:s
  }*/
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['delivery_time'] = deliveryStartTime;
    data['transaction_id'] = transactionId;
    data['ccode'] = cCode;
    data['amount'] = amount;
    data['cart_id'] = cartId;
    data['token'] = token;
    data['month'] = month;
    data['year'] = year;
    data['last_4_numbers'] = last4Numbers;
    data['id_number'] = idNumber;
    data['field_1'] = field_1;
    data['field_2'] = field_2;
    data['field_3'] = field_3;

    return data;
  }
}

class SendOrderReviewApiModel {
  SendOrderReviewApiModel();

  String? note;
  num deliveryRating = 0;
  num serviceRating = 0;
  num appRating = 0;
  late num orderId;

  SendOrderReviewApiModel.fromJson(Map<String, dynamic> json) {
    note = json['note'];
    deliveryRating = json['delivery_rating'];
    serviceRating = json['service_rating'];
    appRating = json['app_rating'];
    orderId = json['order_id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['note'] = note;
    data['delivery'] = deliveryRating;
    data['service'] = serviceRating;
    data['app'] = appRating;
    data['order_id'] = orderId;

    return data;
  }
}

class ProductsInfo {
  ProductsInfo({
    required this.deliveryCost,
  });

  late final int deliveryCost;

  ProductsInfo.fromJson(Map<String, dynamic> json) {
    deliveryCost = json['delivery_cost'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['delivery_cost'] = deliveryCost;
    return data;
  }
}
