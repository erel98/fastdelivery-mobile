import 'dart:convert';

import 'package:fastdelivery/Views/Screens/create_availability_screen.dart';
import 'package:fastdelivery/Views/Widgets/availability_widget.dart';
import 'package:fastdelivery/Views/Widgets/delivery_widget.dart';
import 'package:fastdelivery/Views/Widgets/profile_widget.dart';
import 'package:fastdelivery/constraints.dart';
import 'package:fastdelivery/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controllers/Providers/availability_provider.dart';
import '../../Controllers/Providers/delivery_provider.dart';
import '../../Models/User.dart';
import '../../main.dart';
import '../../preferences_controller.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget>? getIconButton() {
    List<Widget>? widgets = [];
    IconButton? button;
    if (Global.globalIndex == 1) {
      button = IconButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateAvailability())),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ));
    }
    if (button != null) widgets.add(button);
    return widgets;
  }

  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      Global.globalIndex = index;
    });
  }

  void _updatePage() {
    setState(() {});
  }

  User user = User.fromJson(jsonDecode(
      PreferecesController.sharedPreferencesInstance?.getString('user') ?? ''));
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome ${user.username}'),
          backgroundColor: kPrimaryColor,
          actions: getIconButton(),
          automaticallyImplyLeading: false,
        ),
        body: CupertinoTabScaffold(
          resizeToAvoidBottomInset: true,
          tabBar: CupertinoTabBar(
            onTap: onTabTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Availability',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
          tabBuilder: (context, index) {
            var currentWidget;
            if (index == 0) {
              currentWidget = CupertinoTabView(
                navigatorKey: firstTabNavKey,
                builder: (BuildContext context) => Consumer<DeliveryProvider>(
                  builder: (_, value, child) => DeliveryWidget(),
                ),
              );
            } else if (index == 1) {
              currentWidget = CupertinoTabView(
                navigatorKey: secondTabNavKey,
                builder: (BuildContext context) => Container(
                    child: Consumer<AvailabilityProvider>(
                  builder: (_, availabilities, child) => AvailabilityWidget(),
                )),
              );
            } else if (index == 2) {
              currentWidget = CupertinoTabView(
                navigatorKey: thirdTabNavKey,
                builder: (BuildContext context) => ProfileWidget(),
              );
            }
            return SafeArea(child: currentWidget);
          },
        ),
      ),
    );
  }
}
