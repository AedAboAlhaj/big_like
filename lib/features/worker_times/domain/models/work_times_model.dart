import 'package:big_like/utils/utils.dart';
import 'package:flutter/material.dart';

class WorkDayModel {
  WorkDayModel({
    this.id,
    required this.dayNum,
    required this.day,
    required this.times,
  });

  int? id;
  int dayNum;
  String day;
  List<WorkTimesModel> times;
}

class WorkTimesModel {
  WorkTimesModel({
    required this.startTime,
    required this.endTime,
    required this.dayNum,
    required this.id,
  });

  TimeOfDay? startTime;
  TimeOfDay? endTime;
  late int dayNum;
  int? id;

  WorkTimesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = Utils.stringToTimeOfDay(json['start_time']);
    endTime = Utils.stringToTimeOfDay(json['end_time']);
    dayNum = json['day'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['start_time'] = Utils.getTimeText(startTime);
    data['end_time'] = Utils.getTimeText(endTime);
    data['day'] = dayNum;
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
    date = DateTime.parse(json['date']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = Utils.toStringApiDateTime(date);
    return data;
  }
}
