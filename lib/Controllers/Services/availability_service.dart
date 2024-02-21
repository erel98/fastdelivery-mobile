import 'dart:convert';
import 'package:fastdelivery/Models/availability.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'http_service.dart';

class AvailabilityService {
  static Future<List<Availability>> getAvailabilities() async {
    List<Availability> availabilities = [];
    var url = '${dotenv.get('API_URL')}/availability';
    await HTTPService.httpGET(url, appendToken: true)
        .then((http.Response response) {
      var jsonResponse = jsonDecode(response.body) as List<dynamic>;
      jsonResponse.forEach((element) {
        var availability = Availability(
          id: element['id'],
          dayOfWeek: int.parse(element['dayOfWeek']),
          fromTime: element['fromTime'],
          toTime: element['toTime'],
        );
        availabilities.add(availability);
      });
    });
    return availabilities;
  }

  static Future<Availability> createAvailability(
      Map<String, dynamic> params) async {
    var availability;
    var url = '${dotenv.get('API_URL')}/availability/create';
    await HTTPService.httpPOST(url, params, appendToken: true).then((response) {
      if (response.status == 200) {
        var body = response.body;
        availability = Availability(
          id: body['id'],
          dayOfWeek: body['dayOfWeek'],
          fromTime: body['fromTime'],
          toTime: body['toTime'],
        );
      }
    });
    return availability;
  }

  static Future<Availability> updateAvailability(
      Map<String, dynamic> body, String id) async {
    var availability;
    var url = '${dotenv.get('API_URL')}/availability/update/$id';
    await HTTPService.httpPOST(url, body, appendToken: true).then((response) {
      String fromTime;
      String toTime;
      var body = response.body;
      if (body['fromTime'] is Map<String, String>) {
        Map<String, String> fromTimeMap = body['fromTime'];
        fromTime = fromTimeMap['S']!;
      } else {
        fromTime = body['fromTime'];
      }

      if (body['toTime'] is Map<String, String>) {
        Map<String, String> toTimeMap = body['toTime'];
        toTime = toTimeMap['S']!;
      } else {
        toTime = body['toTime'];
      }

      availability = Availability(
        id: body['id'],
        dayOfWeek: body['dayOfWeek'],
        fromTime: fromTime,
        toTime: toTime,
      );
    });

    return availability;
  }

  static Future<bool> deleteAvailability(String id) async {
    var url = '${dotenv.get('API_URL')}/availability/delete/$id';
    var body = {};
    bool success = false;
    await HTTPService.httpPOST(url, body, appendToken: true).then((response) {
      success = response.body['success'];
      return success;
    });
    return success;
  }
}
