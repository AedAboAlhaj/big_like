// class ServiceModel {
//   ServiceModel({
//     required this.id,
//     required this.name,
//     required this.images,
//   });
//
//   late final int id;
//   late final String name;
//   late final Images images;
//
//   ServiceModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     images = Images.fromJson(json['images']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['images'] = images.toJson();
//     return data;
//   }
// }

class ServiceModel {
  ServiceModel({
    required this.id,
    required this.name,
    required this.images,
    required this.cover,
    required this.countries,
    required this.options,
    required this.description,
  });

  late final int id;
  late final String name;
  late final Images images;
  late final String cover;
  late final String? description;
  late final List<Countries> countries;
  late final List<Options> options;

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    images = json['images'] != null
        ? Images.fromJson(json['images'])
        : Images(he: '');
    cover = json['cover'] ?? '';
    countries = json['countries'] != null
        ? List.from(json['countries'])
            .map((e) => Countries.fromJson(e))
            .toList()
        : [];
    options = json['options'] != null
        ? List.from(json['options']).map((e) => Options.fromJson(e)).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['images'] = images;
    data['cover'] = cover;
    data['countries'] = countries.map((e) => e.toJson()).toList();
    data['options'] = options.map((e) => e.toJson()).toList();
    return data;
  }
}

class Images {
  Images({
    required this.he,
  });

  late final String he;

  Images.fromJson(Map<String, dynamic> json) {
    he = json['HE'] ?? json['AR'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['HE'] = he;
    return data;
  }
}

class Countries {
  Countries({
    required this.id,
    required this.name,
    required this.children,
  });

  late final int id;
  late final String name;
  late final List<Children> children;

  Countries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    children =
        List.from(json['children']).map((e) => Children.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['children'] = children.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Children {
  Children({
    required this.id,
    required this.name,
  });

  late final int id;
  late final String name;

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    return _data;
  }
}

class Options {
  Options({
    required this.id,
    required this.name,
    required this.desc,
    required this.fullDesc,
    required this.cost,
    required this.hours,
    required this.discount,
  });

  late final int id;
  late final String name;
  late final String desc;
  late final String fullDesc;
  late final num cost;
  late final num hours;
  late final num discount;
  bool isSelected = false;

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
    desc = json['desc'];
    fullDesc = json['full_desc'];
    cost = json['cost'];
    hours = json['hours'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['desc'] = desc;
    _data['full_desc'] = fullDesc;
    _data['cost'] = cost;
    _data['hours'] = hours;
    _data['discount'] = discount;
    return _data;
  }
}
