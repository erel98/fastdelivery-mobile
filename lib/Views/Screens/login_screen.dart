import 'dart:convert';

import 'package:fastdelivery/Controllers/Services/user_service.dart';
import 'package:fastdelivery/Views/Screens/main_screen.dart';
import 'package:fastdelivery/preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Models/User.dart';
import '../../constraints.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController(text: 'erelozturk98@gmail.com');
  var passwordController = TextEditingController(text: 'test123');
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: const Text(
                'FastDelivery',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontSize: 35,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: const Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 100, left: 10),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 54,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.05)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(-1, 1),
                    blurRadius: 1,
                    color: Colors.black.withOpacity(0.23),
                  ),
                ],
              ),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  label: const Text('email'),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  //hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: kPrimaryColor.withOpacity(0.5),
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 54,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.05)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(-1, 1),
                    blurRadius: 1,
                    color: Colors.black.withOpacity(0.23),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  label: const Text('password'),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  //hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: kPrimaryColor.withOpacity(0.5),
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              child: ElevatedButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                  backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                ),
                onPressed: () async {
                  EasyLoading.show(status: 'loading...');
                  bool success = await UserService.login(
                      emailController.text, passwordController.text);
                  if (success) {
                    //get user details
                    User user = await UserService.getMe();
                    //store user in local storage

                    PreferecesController.sharedPreferencesInstance!
                        .setString('user', jsonEncode(user.toJson()));

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()));
                  } else {
                    EasyLoading.showError('Invalid username or password');
                  }
                },
                child: const Text(
                  'login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
