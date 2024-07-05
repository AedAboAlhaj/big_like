class BannerApiModel {
  BannerApiModel({
    required this.id,
    required this.name,
    required this.image,
  });

  late final int id;
  late final String name;
  late final String image;

  BannerApiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}
