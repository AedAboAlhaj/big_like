class CardApiModel {
  CardApiModel({
    required this.id,
    required this.cardToken,
    required this.customerId,
    required this.createdAt,
    required this.updatedAt,
    required this.month,
    required this.year,
    required this.last_4Numbers,
    required this.idNumber,
  });
  late final int id;
  late final String cardToken;
  late final int customerId;
  late final String createdAt;
  late final String updatedAt;
  late final String month;
  late final String year;
  late final String last_4Numbers;
  late final String idNumber;

  CardApiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardToken = json['card_token'];
    customerId = json['customer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    month = json['month'];
    year = json['year'];
    last_4Numbers = json['last_4_numbers'];
    idNumber = json['id_number'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['card_token'] = cardToken;
    data['customer_id'] = customerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['month'] = month;
    data['year'] = year;
    data['last_4_numbers'] = last_4Numbers;
    data['id_number'] = idNumber;
    return data;
  }
}
