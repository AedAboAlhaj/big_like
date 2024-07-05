import 'dart:convert';
import 'package:big_like/local_storage/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants/api_settings.dart';
import '../domain/models/user_api_model.dart';

class AuthApiController {
  Future<int?> registerCustomer({required UserApiModel userApiModel}) async {
    // var url = Uri.parse(ApiSettings.REGISTER);
    // var response =
    //     await http.MultipartRequest(url, body: userApiSignUpModel.toJson());

    var request =
        http.MultipartRequest('POST', Uri.parse(ApiSettings.register));
    request.fields['name'] = userApiModel.name;
    request.fields['phone'] = userApiModel.phone;
    request.headers['Accept'] = 'application/json';
    request.fields['country_id'] = AppSharedPref().countryId.toString();
    // if (userSignUpApiModel.birthdate != null) {
    //   request.fields['birthdate'] = userSignUpApiModel.birthdate!;
    // }

    //  request.fields['email'] = userApiSignUpModel.email!;
    // if (userSignUpApiModel.image != null) {
    //   request.files.add(await http.MultipartFile.fromPath(
    //       'image', userSignUpApiModel.image!));
    // }
    var response = await request.send();
    final res = await http.Response.fromStream(response);
    print(ApiSettings.register);
    print(request.fields);
    print(res.body);
    if (res.statusCode == 200) {
      var jsonObject = jsonDecode(res.body);
      var code = jsonObject["code"];
      return code;
      // return smsResponse;
    } else if (res.statusCode != 500) {
      return null;
    } else {
      return null;
    }
  }

  Future<String?> sendOtp({required String phoneNumber}) async {
    var url = Uri.parse('${ApiSettings.login}/$phoneNumber');
    // print({
    //   'phone': phoneNumber,
    // });

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // body: jsonEncode({
      //   'phone': phoneNumber,
      // }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode != 500) {
      //error message
      return null;
    } else {
      //500 server error
      return null;
    }
  }

  Future<UserApiModel?> checkSignUpCode({required String code}) async {
    var url = Uri.parse('${ApiSettings.checkOtp}/$code');
    var response = await http.post(url, headers: {
      'Accept': 'application/json',
    });
    print(url);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      return UserApiModel.fromJson(jsonObject['data']);
    } else if (response.statusCode != 500) {
      return null;
    } else {
      return null;
    }
  }

/*  Future<UserModel?> getUserData() async {
    var url = Uri.parse(ApiSettings.userInfo);
    http.Response response;
    try {
      response = await http.get(url, headers: {
        'Authorization': 'Bearer ${AppSharedPref().token}',
        'Accept': 'application/json',
      });
    } catch (e) {
      return null;
    }

    if (response.statusCode == 200) {
      var jsonObject = jsonDecode(response.body);
      return UserModel.fromJson(jsonObject["data"]);
    } else if (response.statusCode != 500) {
      return null;
    } else {
      return null;
    }
  }*/

/*  Future<bool> saveNotificationToken(
      {required String token, required String? deviceId}) async {
    var url = Uri.parse(ApiSettings.notification);
    var response = await http.post(url, body: {
      'token': token,
      'device_id': deviceId != null ? 'c_$deviceId' : null,
      "type": "customer"
    }, headers: {
      'Authorization': 'Bearer ${AppSharedPref().token}',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode != 500) {
      return false;
    } else {
      return false;
    }
  }*/
// Future<CheckToken> upDateUserData(
//     {required UserApiSignUpModel userApiSignUpModel}) async {
//   var request = http.MultipartRequest(
//     'POST',
//     Uri.parse(ApiSettings.UPDATEUserData),
//   );
//   request.headers.addAll(<String, String>{
//     'Accept': 'application/json; charset=UTF-8',
//     'Content-Type': 'application/json; charset=UTF-8',
//     'Authorization': 'Bearer ' + AppSharedPref().token,
//   });
//
//   request.fields['name'] = userApiSignUpModel.name;
//   request.fields['phone_number'] = userApiSignUpModel.phoneNumber;
//   request.fields['town'] = userApiSignUpModel.town;
//   //  request.fields['email'] = userApiSignUpModel.email!;
//   if (userApiSignUpModel.image != null)
//     request.files.add(await http.MultipartFile.fromPath(
//         'image', userApiSignUpModel.image!));
//   var response = await request.send();
//   final res = await http.Response.fromStream(response);
//   if (response.statusCode == 200) {
//     CheckToken checkToken = CheckToken.fromJson(jsonDecode(res.body)['data']);
//
//     return checkToken;
//     // return smsResponse;
//   } else if (response.statusCode != 500) {
//     //eror mssage
//     return CheckToken(
//       message: null,
//       status: 'error',
//       accessToken: null,
//     );
//   } else {
//     //500 server eror
//     return CheckToken(
//       message: null,
//       status: 'error',
//       accessToken: null,
//     );
//   }
// }
}
