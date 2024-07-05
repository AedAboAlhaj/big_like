class WorkTimesModel {
  WorkTimesModel({
    this.id,
    required this.startTime,
    required this.endTime,
  });

  int? id;
  late String startTime;
  late String endTime;
  late num cost;

  WorkTimesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}

class HollyDaysModel {
  HollyDaysModel({
    this.id,
    required this.date,
  });

  int? id;
  late DateTime date;

  HollyDaysModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['id'] = date;
    return data;
  }
}
