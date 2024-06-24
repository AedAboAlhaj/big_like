class SupportedLangModel {
  SupportedLangModel(
      {required this.name,
      required this.dir,
      required this.id,
      required this.isDefault,
      required this.locale,
      this.isSelected = false});

  late final String name;
  late final String dir;
  late final int id;
  late final int isDefault;
  late final String locale;
  bool isSelected = false;

  SupportedLangModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dir = json['dir'];
    id = json['id'];
    isDefault = json['is_default'];
    locale = json['locale'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['dir'] = dir;
    data['id'] = id;
    data['is_default'] = isDefault;
    data['locale'] = locale.toLowerCase();
    return data;
  }
}
