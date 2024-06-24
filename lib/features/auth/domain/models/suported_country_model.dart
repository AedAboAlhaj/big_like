class SupportedCountryModel {
  SupportedCountryModel({
    required this.id,
    this.image,
    required this.name,
  });

  late final int id;
  late final String? image;
  late final String name;
  bool isSelected = false;

  SupportedCountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    return data;
  }
}
