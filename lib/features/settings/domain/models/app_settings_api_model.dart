class AppSettingsApiModel {
  AppSettingsApiModel({
    // required this.id,
    this.logo,
    required this.phone,
    required this.whatsapp,
  });

  // late final int id;
  late final String? iosVersion;
  late final String? iosLink;
  late final String? androidVersion;
  late final String? androidLink;
  late final String? logo;
  late final String? phone;
  late final String? whatsapp;
  late final DateTime timeNow;
  late final List<String> messages;

  AppSettingsApiModel.fromJson(Map<String, dynamic> json) {
    // id = json['id'];
    iosVersion = json['ios_version'];
    iosLink = json['ios_link'];
    androidVersion = json['android_version'];
    androidLink = json['android_link'];
    logo = json['logo'];
    phone = json['phone'];
    whatsapp = json['whatsapp'];
    messages = List.from(json['messages']);
    timeNow = DateTime.tryParse(json['current_time'] ?? '') ?? DateTime.now();
  }
}
