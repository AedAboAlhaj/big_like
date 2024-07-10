import 'dart:convert';
import 'package:big_like/constants/api_settings.dart';
import 'package:big_like/features/worker_times/domain/models/work_times_model.dart';
import 'package:big_like/local_storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../local_storage/shared_preferences.dart';

class WorkerScheduleApiController {
  Future<List<WorkDayModel>> getWorkerDays() async {
    final token = await AppSecureStorage().getToken();
    var url = Uri.parse(ApiSettings.workersSchedule);
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'content-type': 'application/json;encoding=utf-8'
        },
      );
    } catch (e) {
      return [];
    }

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var productsJsonArray = (jsonObject['data']['days'] as List);
      List<WorkDayModel> dayList = [];
      var list = productsJsonArray
          .map(
              (productJsonObject) => WorkTimesModel.fromJson(productJsonObject))
          .toList();
      daysOfWeek.forEach(
        (key, value) {},
      );
      list.forEach(
        (element) {
          daysOfWeek.forEach(
            (key, value) {
              if (element.dayNum == key) {
                final workDay =
                    WorkDayModel(times: [], day: value, dayNum: key);
                workDay.times.add(element);
                print(
                    'day:${workDay.day} dayNum:${workDay.dayNum} times:${workDay.times}');
                dayList.add(workDay);
              }
            },
          );
        },
      );
      print(list);
      return dayList;
    } else if (response.statusCode != 500) {
      //error msg
    } else {
      //500 server error
    }

    return [];
  }

  Future<List<HollyDaysModel>> getWorkerHollyDays() async {
    final token = await AppSecureStorage().getToken();
    var url = Uri.parse(ApiSettings.workersSchedule);
    http.Response response;
    try {
      response = await http.get(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'content-type': 'application/json;encoding=utf-8'
        },
      );
    } catch (e) {
      return [];
    }

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      var productsJsonArray = (jsonObject['data']['holidays'] as List);
      var list = productsJsonArray
          .map(
              (productJsonObject) => HollyDaysModel.fromJson(productJsonObject))
          .toList();
      return list;
    } else if (response.statusCode != 500) {
      //error msg
    } else {
      //500 server error
    }

    return [];
  }

  Future<bool> updateHollyDays(List<HollyDaysModel> daysList) async {
    final token = await AppSecureStorage().getToken();
    var url = Uri.parse(ApiSettings.workersSchedule);
    http.Response response;
    print(json.encode({"holidays": daysList.map((e) => e.toJson()).toList()}));
    try {
      response = await http.post(url,
          headers: <String, String>{
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'content-type': 'application/json;encoding=utf-8'
          },
          body: utf8.encode(json
              .encode({"holidays": daysList.map((e) => e.toJson()).toList()})));
    } catch (e) {
      return false;
    }
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode != 500) {
      //error msg
    } else {
      //500 server error
    }

    return false;
  }

  Future<bool> updateWorkDays(List<WorkTimesModel> daysList) async {
    final token = await AppSecureStorage().getToken();
    var url = Uri.parse(ApiSettings.workersSchedule);
    http.Response response;
    print(json.encode({"days": daysList.map((e) => e.toJson()).toList()}));
    try {
      response = await http.post(url,
          headers: <String, String>{
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'content-type': 'application/json;encoding=utf-8'
          },
          body: utf8.encode(
              json.encode({"days": daysList.map((e) => e.toJson()).toList()})));
    } catch (e) {
      return false;
    }
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode != 500) {
      //error msg
    } else {
      //500 server error
    }

    return false;
  }

  Map<int, String> daysOfWeek = <int, String>{
    0: DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 2)), // Monday
    1: DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 3)), // Tuesday
    2: DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 4)), // Wednesday
    3: DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 5)), // Thursday
    4: DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 6)), // Friday
    5: DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 7)), // Saturday
    6: DateFormat.EEEE(AppSharedPref().languageLocale ?? 'en')
        .format(DateTime.utc(2023, 7, 8)), // Sunday
  };
}
