import 'package:fastdelivery/Controllers/Providers/delivery_provider.dart';
import 'package:fastdelivery/Models/delivery.dart';
import 'package:fastdelivery/Views/Screens/pincode_screen.dart';
import 'package:fastdelivery/Views/Screens/update_delivery_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryWidget extends StatefulWidget {
  /* final List<Delivery> deliveries;
  HomeWidget({required this.deliveries}); */
  @override
  State<DeliveryWidget> createState() => _DeliveryWidgetState();
}

class _DeliveryWidgetState extends State<DeliveryWidget> {
  List<Item> _data = [];

  Future<void> initData() async {
    _data = [];
    final deliveryProvider =
        Provider.of<DeliveryProvider>(context, listen: false);
    await deliveryProvider.getDeliveries(context);
    final deliveries = deliveryProvider.deliveries;
    deliveries.sort((a, b) => b.createDate.compareTo(a.createDate));
    deliveries.forEach((element) {
      _data.add(generateItem(element));
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Color? getStatusColor(String status) {
    Color? color;
    if (status == 'Received') {
      color = Colors.green;
    } else if (status == 'Dispatched') {
      color = Colors.yellow;
    } else if (status == 'In Transit') {
      color = Colors.orange;
    } else if (status == 'Delivered') {
      color = Colors.red;
    }
    return color;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _data.isNotEmpty
          ? _buildPanel()
          : const Center(
              child: Text('No data found'),
            ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              width: MediaQuery.of(context).size.width,
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
                child: Center(child: child),
              ),
            ));
  }

  Widget _buildPanel() {
    var width = MediaQuery.of(context).size.width;
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              leading: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  item.delivery.orderNr,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              title: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                    'from: ${item.delivery.origin}\nto: ${item.delivery.destination}'),
              ),
              trailing: SizedBox(
                width: 100,
                child: Row(children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: getStatusColor(item.delivery.status)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(item.delivery.status)
                ]),
              ),
            );
          },
          body: ListTile(
            leading: SizedBox(
              width: width * 0.3,
              child: Text(
                'Weight: ${item.delivery.weight} kg',
              ),
            ),
            title:
                SizedBox(width: width * 0.4, child: Text(item.delivery.type)),
            subtitle: SizedBox(
                width: width * 0.4,
                child: Text('HxWxD: ${item.delivery.dimensions}')),
            trailing: SizedBox(
                width: width * 0.2,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () => _showDialog(
                                  Text(item.delivery.comment ?? '')),
                              icon: Icon(
                                Icons.comment,
                                color: item.delivery.comment == null
                                    ? Colors.grey
                                    : Colors.blue,
                              )),
                          IconButton(
                              onPressed: () => _showDialog(Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.person),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            item.delivery.customerInfo['name'],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.phone),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            item.delivery
                                                .customerInfo['number'],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.mail),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            item.delivery.customerInfo['email'],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              icon: const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ))
                        ],
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          String text = getButtonText(item.delivery.status);
                          if (text == 'update') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateDeliveryStatusScreen(),
                                settings: RouteSettings(
                                  arguments: {
                                    'delivery': item.delivery.toJson()
                                  },
                                ),
                              ),
                            ).then((_) => initData());
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PincodeScreen(),
                                settings: RouteSettings(
                                  arguments: {
                                    'delivery': item.delivery.toJson()
                                  },
                                ),
                              ),
                            ).then((_) => initData());
                          }
                        },
                        child: Text(
                          getButtonText(item.delivery.status),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class Item extends ChangeNotifier {
  Delivery delivery;
  bool isExpanded;

  Item({required this.delivery, this.isExpanded = false});
}

Item generateItem(Delivery delivery) {
  return Item(delivery: delivery);
}
