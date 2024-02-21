import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/api_response.dart';

class HTTPService {
  static Future<Response> httpGET(String url,
      {bool appendToken = false}) async {
    EasyLoading.show(
      status: 'loading...',
    );
    var uri = Uri.parse(url);
    String token;
    var prefs = await SharedPreferences.getInstance();
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    if (appendToken) {
      token = prefs.getString('token') ?? '';
      headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    var response;
    try {
      response =
          await http.get(uri, headers: headers).then((http.Response response) {
        EasyLoading.dismiss();
        return response;
      });
    } catch (error) {
      EasyLoading.dismiss();
      rethrow;
    }
    EasyLoading.dismiss();
    return response;
  }

  static Future<API_Response> httpPOST(String url, Object body,
      {bool appendToken = false}) async {
    EasyLoading.show(status: 'loading');
    var prefs = await SharedPreferences.getInstance();
    var uri = Uri.parse(url);
    String token;
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    if (appendToken) {
      token = prefs.getString('token') ?? '';
      headers.putIfAbsent('Authorization', () => 'Bearer $token');
    }
    try {
      var response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .then((http.Response response) {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        API_Response api_response =
            API_Response(status: response.statusCode, body: decodedResponse);
        EasyLoading.dismiss();
        return api_response;
      });
      EasyLoading.dismiss();
      return response;
    } catch (error) {
      EasyLoading.dismiss();
      rethrow;
    }
  }
}
