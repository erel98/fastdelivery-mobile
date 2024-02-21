import 'package:flutter/material.dart';
import '../../Models/delivery.dart';
import '../Services/delivery_service.dart';

class DeliveryProvider with ChangeNotifier {
  List<Delivery> deliveries = [];

  Future<void> getDeliveries(context) async {
    deliveries = await DeliveryService.getDeliveries();
    notifyListeners();
  }

  void updateDelivery(Delivery delivery) {
    deliveries[deliveries.indexWhere((a) => a.id == delivery.id)] = delivery;
    notifyListeners();
  }
}
