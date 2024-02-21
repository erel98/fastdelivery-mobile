import 'dart:convert';

import 'package:fastdelivery/Controllers/Services/http_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../Models/delivery.dart';

class DeliveryService {
  static Future<List<Delivery>> getDeliveries() async {
    var url = '${dotenv.get('API_URL')}/delivery';
    List<Delivery> deliveries = [];
    await HTTPService.httpGET(url, appendToken: true).then((response) {
      var jsonResponse = jsonDecode(response.body) as List<dynamic>;
      jsonResponse.forEach((element) {
        var delivery = Delivery.fromJson(element);
        deliveries.add(delivery);
      });
    });
    return deliveries;
  }

  static Future<Delivery> updateDeliveryStatus(
      Map<String, dynamic> body, String id) async {
    var delivery;
    var url = '${dotenv.get('API_URL')}/delivery/$id';
    await HTTPService.httpPOST(url, body, appendToken: true).then((response) {
      var element = response.body;
      delivery = Delivery.fromJson(element);
    });
    return delivery;
  }

  static Future<bool> checkPincode(Map<String, dynamic> body) async {
    bool isCorrect = false;
    var url = '${dotenv.get('REQUESTING_APP_URL')}/verify-order-code';
    await HTTPService.httpPOST(url, body).then((response) {
      var element = response.body;
      String message = element['message'];
      if (message.contains('not')) {
        isCorrect = false;
      } else {
        isCorrect = true;
      }
    });
    return isCorrect;
  }
}
