import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fastdelivery/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  User user = User();
  bool isLoading = true;
  void getUserFromLocalStorage(context) async {
    var prefs = await SharedPreferences.getInstance();
    user = User.fromJson(jsonDecode(prefs.getString('user') ?? ''));
    isLoading = false;
    notifyListeners();
  }
}
