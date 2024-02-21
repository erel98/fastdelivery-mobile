import 'package:fastdelivery/Controllers/Services/availability_service.dart';
import 'package:fastdelivery/Models/availability.dart';
import 'package:flutter/material.dart';

class AvailabilityProvider with ChangeNotifier {
  List<Availability> availabilities = [];

  void getAvailabilities(context) async {
    availabilities = await AvailabilityService.getAvailabilities();
    notifyListeners();
  }

  void createAvailability(Map<String, dynamic> params) async {
    var newAvailability = await AvailabilityService.createAvailability(params);
    availabilities.add(newAvailability);
    notifyListeners();
  }

  void updateAvailability(Availability availability) {
    availabilities[availabilities.indexWhere((a) => a.id == availability.id)] =
        availability;
    notifyListeners();
  }

  void deleteAvailability(String id) {
    availabilities.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
