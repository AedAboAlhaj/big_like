class ProductApiModel {
  ProductApiModel({
    required this.id,
    required this.name,
    required this.price,
    this.image,
    required this.barcode,
    required this.quantity,
    required this.discount,
  });

  late final int id;
  late final String name;
  late final num price;
  late final String? image;
  late final String? barcode;
  late final int quantity;
  int userSelectedQuantity = 0;
  late final int discount;

  ProductApiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    barcode = json['barcode'];
    quantity = json['quantity'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['quantity'] = userSelectedQuantity;
    return data;
  }
}
