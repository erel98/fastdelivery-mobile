import 'dart:async';

import 'package:fastdelivery/Controllers/Services/delivery_service.dart';
import 'package:fastdelivery/constraints.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../Controllers/Providers/delivery_provider.dart';
import '../../Models/delivery.dart';

class PincodeScreen extends StatefulWidget {
  static const routeName = '/pincode';
  PincodeScreen({Key? key}) : super(key: key);

  @override
  State<PincodeScreen> createState() => _PincodeScreenState();
}

class _PincodeScreenState extends State<PincodeScreen> {
  final GlobalKey<FormFieldState> _formKey = GlobalKey<FormFieldState>();
  TextEditingController textEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  bool isCorrectGlobal = false;
  bool isFalseGlobal = false;
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var delivery = Delivery.fromJson(routeArgs['delivery']);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please enter the pincode',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'You are about to deliver the order with number:',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              delivery.orderNr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: formKey,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: false,
                    blinkWhenObscuring: true,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey,
                      selectedColor: Colors.black,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    onCompleted: (v) async {
                      if (v.length == 4) {
                        setState(() {
                          isCorrectGlobal = false;
                          isFalseGlobal = false;
                        });
                        var body = {
                          'orderNumber': delivery.orderNr,
                          'orderCode': textEditingController.text
                        };
                        bool isCorrect =
                            await DeliveryService.checkPincode(body);
                        if (isCorrect) {
                          setState(() {
                            isCorrectGlobal = true;
                          });
                          await Future.delayed(const Duration(seconds: 2))
                              .then((_) async {
                            var params = {'delivery_status': 'Delivered'};
                            await DeliveryService.updateDeliveryStatus(
                                    params, delivery.id)
                                .then((newDelivery) {
                              final prov = Provider.of<DeliveryProvider>(
                                  context,
                                  listen: false);
                              prov.updateDelivery(newDelivery);
                              Navigator.of(context).pop();
                            });
                          });
                        } else {
                          setState(() {
                            isFalseGlobal = true;
                            textEditingController.clear();
                          });
                        }
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            isCorrectGlobal
                ? Column(children: const [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 96,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        'Pincode is correct. Delivery complete!',
                        style: TextStyle(fontSize: 20, color: kPrimaryColor),
                      ),
                    )
                  ])
                : Container(),
            isFalseGlobal
                ? Column(children: const [
                    Icon(
                      FontAwesomeIcons.circleXmark,
                      color: Colors.red,
                      size: 96,
                    ),
                    Text('Pincode is incorrect. Please try again.')
                  ])
                : Container(),
          ],
        ),
      ),
    );
  }
}
