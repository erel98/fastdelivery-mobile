import 'package:fastdelivery/Controllers/Providers/availability_provider.dart';
import 'package:fastdelivery/Controllers/Services/availability_service.dart';
import 'package:fastdelivery/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvailabilityWidget extends StatefulWidget {
  @override
  State<AvailabilityWidget> createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  bool isToday(int day) {
    var now = DateTime.now();
    if (now.weekday - 1 == day) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    final availabilityProvider =
        Provider.of<AvailabilityProvider>(context, listen: false);
    availabilityProvider.getAvailabilities(context);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final availabilityData = Provider.of<AvailabilityProvider>(context);
    final av = availabilityData.availabilities;
    av.sort((a, b) {
      int comp = a.dayOfWeek.compareTo(b.dayOfWeek);
      if (comp == 0) {
        return a.fromTime.compareTo(b.fromTime);
      }
      return comp;
    });
    return av.isEmpty
        ? const Center(child: Text('You don\'t have any availabilities'))
        : ListView.builder(
            itemBuilder: ((BuildContext context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                color: isToday(av[index].dayOfWeek)
                    ? Colors.greenAccent
                    : Colors.white,
                child: ListTile(
                  leading: SizedBox(
                      width: mq.width * 0.4,
                      child: Text(Global.getWeekDay(av[index].dayOfWeek))),
                  title: SizedBox(
                      width: mq.width * 0.4,
                      child:
                          Text('${av[index].fromTime} - ${av[index].toTime}')),
                  trailing: SizedBox(
                    width: mq.width * 0.2,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await AvailabilityService.deleteAvailability(
                                av[index].id)
                            .then((success) {
                          if (success) {
                            availabilityData.deleteAvailability(av[index].id);
                          }
                        });
                      },
                    ),
                  ),
                ),
              );
            }),
            itemCount: av.length);
  }
}
