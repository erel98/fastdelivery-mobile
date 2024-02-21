import 'package:fastdelivery/Controllers/Providers/availability_provider.dart';
import 'package:fastdelivery/Controllers/Providers/delivery_provider.dart';
import 'package:fastdelivery/Controllers/Providers/user_provider.dart';
import 'package:fastdelivery/Views/Screens/create_availability_screen.dart';
import 'package:fastdelivery/Views/Screens/pincode_screen.dart';
import 'package:fastdelivery/Views/Screens/update_delivery_screen.dart';
import 'package:fastdelivery/preferences_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'Views/Screens/main_screen.dart';
import 'Views/Screens/login_screen.dart';
import './constraints.dart';

final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferences.getInstance().then(
      (instance) => PreferecesController.sharedPreferencesInstance = instance);
  Provider.debugCheckInvalidValueType = null;
  await dotenv.load();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => AvailabilityProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => DeliveryProvider(),
      ),
    ],
    child: const MyApp(
        /*  home: LoginScreen(),
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ], */
        ),
  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.dualRing
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 25.0
    ..radius = 20.0
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = ThemeData();

    return MaterialApp(
        title: 'FastDelivery',
        theme: theme.copyWith(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const LoginScreen(),
        builder: EasyLoading.init(),
        routes: {
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          MainScreen.routeName: (ctx) => const MainScreen(),
          CreateAvailability.routeName: (ctx) => const CreateAvailability(),
          UpdateDeliveryStatusScreen.routeName: (ctx) =>
              UpdateDeliveryStatusScreen(),
          PincodeScreen.routeName: (ctx) => PincodeScreen()
        });
  }
}
