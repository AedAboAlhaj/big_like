class DateModel {
  DateModel({
    required this.day,
    required this.date,
    required this.times,
  });

  late final String day;
  late final String date;
  late final List<Times> times;

  DateModel.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    date = json['date'];
    times = List.from(json['times']).map((e) => Times.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['day'] = day;
    data['date'] = date;
    data['times'] = times.map((e) => e.toJson()).toList();
    return data;
  }
}

class Times {
  Times({
    required this.time,
  });

  late final String time;

  Times.fromJson(Map<String, dynamic> json) {
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['time'] = time;

    return data;
  }
}
