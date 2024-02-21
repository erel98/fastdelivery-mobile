import 'dart:convert';

import 'package:fastdelivery/Controllers/Services/user_service.dart';
import 'package:fastdelivery/Views/Widgets/profile_textfield.dart';
import 'package:fastdelivery/preferences_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Models/User.dart';
import '../../constraints.dart';

class ProfileWidget extends StatefulWidget {
  ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final mobileController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    initControllers();
  }

  void initControllers() {
    User user = User.fromJson(jsonDecode(
        PreferecesController.sharedPreferencesInstance?.getString('user') ??
            ''));
    nameController.text = user.fullName ?? '';
    ageController.text = user.age.toString();
    genderController.text = user.gender == 1 ? 'Male' : 'Female';
    mobileController.text = user.mobile.toString();
    userNameController.text = user.username ?? '';
    emailController.text = user.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width,
          // ignore: prefer_const_literals_to_create_immutables
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Text('Name:'),
            ProfileTextfield(
              controller: nameController,
              inputType: TextInputType.name,
            ),
            const Text('Age:'),
            ProfileTextfield(
              controller: ageController,
              inputType: TextInputType.number,
            ),
            const Text('Gender:'),
            ProfileTextfield(
              controller: genderController,
              inputType: TextInputType.text,
            ),
            const Text('phone num:'),
            ProfileTextfield(
              controller: mobileController,
              inputType: TextInputType.phone,
            ),
            const Text('username:'),
            ProfileTextfield(
              controller: userNameController,
              inputType: TextInputType.name,
            ),
            const Text('email:'),
            ProfileTextfield(
              controller: emailController,
              inputType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 50,
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
                  var params = {
                    'fullName': nameController.text,
                    'age': int.parse(ageController.text),
                    'mobile': mobileController.text.toString(),
                    'gender': genderController.text == 'Male' ? 1 : 0,
                    'username': userNameController.text,
                    'email': emailController.text
                  };
                  var success = await UserService.updateMe(params);
                  if (success) {
                    EasyLoading.showSuccess('Success');
                  } else {
                    EasyLoading.showError('Failure');
                  }
                },
                child: const Text(
                  'save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
