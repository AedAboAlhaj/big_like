class WorkerModel {
  WorkerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.photo,
    this.coordinates,
  });

  late final int id;
  late final String name;
  late final String phone;
  late final String address;
  late final String photo;
  late final Null coordinates;

  WorkerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    photo = json['photo'];
    coordinates = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['address'] = address;
    _data['photo'] = photo;
    _data['coordinates'] = coordinates;
    return _data;
  }
}
