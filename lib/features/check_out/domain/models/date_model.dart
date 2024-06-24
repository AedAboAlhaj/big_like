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
    final _data = <String, dynamic>{};
    _data['day'] = day;
    _data['date'] = date;
    _data['times'] = times.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Times {
  Times({
    required this.startTime,
    required this.endTime,
    required this.isDate,
  });

  late final String startTime;
  late final String endTime;
  late final bool isDate;

  Times.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'];
    endTime = json['end_time'];
    isDate = json['is_date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['start_time'] = startTime;
    _data['end_time'] = endTime;
    _data['is_date'] = isDate;
    return _data;
  }
}
