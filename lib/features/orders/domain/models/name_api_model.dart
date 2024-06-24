import 'package:big_like/local_storage/shared_preferences.dart';

class Name {
  Name({
    required this.ar,
    required this.he,
  });

  late final String ar;
  late final String he;

  Name.fromJson(Map<String, dynamic> json) {
    ar = (json[AppSharedPref().languageLocale?.toUpperCase()] ?? json['AR']) ??
        '';
    he = (json['HE'] ?? json['AR']) ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['AR'] = ar;
    return data;
  }
}
