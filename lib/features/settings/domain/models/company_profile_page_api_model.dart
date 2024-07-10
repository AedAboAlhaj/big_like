class CompanyProfilePageApiModel {
  CompanyProfilePageApiModel({
    required this.id,
    required this.status,
    required this.defaultTitle,
    required this.title,
    required this.defaultDescription,
    required this.description,
  });

  late final int id;
  late final bool status;
  late final String defaultTitle;
  late final Title? title;
  late final String defaultDescription;
  late final Description? description;

  CompanyProfilePageApiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'] == 1;
    defaultTitle = json['default_title'];
    title = Title.fromJson(json['title']);
    defaultDescription = json['default_description'];
    description = Description.fromJson(json['description']);
  }
}

class Title {
  Title({
    required this.ar,
  });

  late final String ar;

  Title.fromJson(Map<String, dynamic> json) {
    ar = json['HE'] ?? json['AR'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['AR'] = ar;
    return data;
  }
}

class Description {
  Description({
    required this.ar,
  });

  late final String ar;

  Description.fromJson(Map<String, dynamic> json) {
    ar = json['HE'] ?? json['AR'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['AR'] = ar;
    return data;
  }
}
