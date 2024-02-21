import 'dart:convert';
import 'package:fastdelivery/Controllers/Services/http_service.dart';
import 'package:fastdelivery/preferences_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../Models/User.dart';

class UserService {
  static Future<bool> login(String email, String password) async {
    EasyLoading.show(status: 'loading...');
    Map<String, String> params = {};
    params['email'] = email;
    params['password'] = password;
    var url = '${dotenv.get('API_URL')}/login';
    var headers = {'Content-Type': 'application/json', 'Accept': '*/*'};
    bool success = false;

    try {
      await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(params))
          .then((http.Response response) {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        String? token = decodedResponse['access_token'];
        if (token != null) {
          PreferecesController.sharedPreferencesInstance!
              .setString('token', token);
          success = true;
        } else {
          success = false;
        }
      });
    } catch (error) {
      rethrow;
    }
    EasyLoading.dismiss();
    return success;
  }

  static Future<User> getMe() async {
    var user;
    var url = '${dotenv.get('API_URL')}/me';
    await HTTPService.httpGET(url, appendToken: true)
        .then((http.Response response) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      user = User(
          id: jsonResponse['id'],
          fullName: jsonResponse['fullName'],
          age: jsonResponse['age'],
          gender: jsonResponse['gender'],
          mobile: jsonResponse['mobile'],
          username: jsonResponse['username'],
          email: jsonResponse['email']);
    });
    return user;
  }

  static Future<bool> updateMe(Map<String, dynamic> params) async {
    var url = '${dotenv.get('API_URL')}/updateMe';
    var success = false;
    await HTTPService.httpPOST(url, params, appendToken: true).then((response) {
      success = response.body['success'];
    });

    return success;
  }
}
