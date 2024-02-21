import 'package:fastdelivery/Controllers/Services/delivery_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Controllers/Providers/delivery_provider.dart';
import '../../Models/delivery.dart';

class UpdateDeliveryStatusScreen extends StatefulWidget {
  static const routeName = '/update-delivery';
  @override
  State<UpdateDeliveryStatusScreen> createState() =>
      _UpdateDeliveryStatusScreenState();
}

class _UpdateDeliveryStatusScreenState
    extends State<UpdateDeliveryStatusScreen> {
  String status = '';
  List<String> generateStatusList(String status) {
    List<String> statusList = [status];
    if (status == 'Received') {
      statusList.add('Dispatched');
      statusList.add('In Transit');
    } else if (status == 'Dispatched') {
      statusList.add('In Transit');
    }
    return statusList;
  }

  String getButtonText(String status) {
    String text = '';
    if (status == 'In Transit') {
      text = 'pin code';
    } else {
      text = 'update';
    }
    return text;
  }

  int selectedStatus = 0;
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var delivery = Delivery.fromJson(routeArgs['delivery']);
    List<String> statusList = generateStatusList(delivery.status);

    void _showDialog(Widget child) {
      showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => Container(
                height: 216,
                padding: const EdgeInsets.only(top: 6.0),
                // The Bottom margin is provided to align the popup above the system navigation bar.
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                // Provide a background color for the popup.
                color: CupertinoColors.systemBackground.resolveFrom(context),
                // Use a SafeArea widget to avoid system overlaps.
                child: SafeArea(
                  top: false,
                  child: child,
                ),
              ));
    }

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text(
              delivery.orderNr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              '${delivery.origin} - ${delivery.destination}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 15,
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              // Display a CupertinoPicker with list of fruits.
              onPressed: () => _showDialog(
                CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32,
                  // This is called when selected item is changed.
                  onSelectedItemChanged: (int selectedItem) {
                    setState(() {
                      selectedStatus = selectedItem;
                    });
                  },
                  children:
                      List<Widget>.generate(statusList.length, (int index) {
                    return Center(
                      child: Text(
                        statusList[index],
                      ),
                    );
                  }),
                ),
              ),
              // This displays the selected fruit name.
              child: Text(
                statusList[selectedStatus],
                style: const TextStyle(
                  fontSize: 22.0,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CupertinoButton.filled(
              onPressed: () async {
                if (statusList[selectedStatus] != delivery.status) {
                  final body = {"delivery_status": statusList[selectedStatus]};
                  await DeliveryService.updateDeliveryStatus(body, delivery.id)
                      .then((Delivery newDelivery) {
                    final prov =
                        Provider.of<DeliveryProvider>(context, listen: false);
                    prov.updateDelivery(newDelivery);
                    Navigator.of(context).pop();
                  });
                }
              },
              child: const Text('Save'),
            )
          ]),
        ),
      ),
    );
  }
}
