import 'package:fastdelivery/Controllers/Providers/availability_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAvailability extends StatefulWidget {
  static const routeName = '/create-availability';
  const CreateAvailability({Key? key}) : super(key: key);

  @override
  State<CreateAvailability> createState() => _CreateAvailabilityState();
}

class _CreateAvailabilityState extends State<CreateAvailability> {
  final List<String> days = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  int selectedDayOfWeek = DateTime.now().weekday;
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

  void _createAvailability(Map<String, dynamic> params) {
    Provider.of<AvailabilityProvider>(context, listen: false)
        .createAvailability(params);
  }

  TimeOfDay? fromTime = const TimeOfDay(hour: 0, minute: 0);
  TimeOfDay? toTime = const TimeOfDay(hour: 12, minute: 0);

  String buildTimeString(TimeOfDay? tod) {
    String hourString = '';
    String minuteString = '';
    if (tod != null) {
      tod.hour < 10 ? hourString = '0${tod.hour}' : hourString = '${tod.hour}';
      tod.minute < 10
          ? minuteString = '0${tod.minute}'
          : minuteString = '${tod.minute}';
    } else {
      return '';
    }

    return '$hourString:$minuteString';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green),
      body: Column(children: [
        SizedBox(
          height: 52,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Text(
                'Day:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showDialog(
                CupertinoPicker(
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: true,
                  itemExtent: 32,
                  scrollController: FixedExtentScrollController(
                      initialItem: DateTime.now().weekday - 1),
                  // This is called when selected item is changed.
                  onSelectedItemChanged: (int selectedItem) {
                    setState(() {
                      selectedDayOfWeek = selectedItem + 1;
                    });
                  },
                  children: List<Widget>.generate(days.length, (int index) {
                    return Center(
                      child: Text(
                        days[index],
                      ),
                    );
                  }),
                ),
              ),
              child: Text(
                days[selectedDayOfWeek - 1],
                style: const TextStyle(
                  fontSize: 22.0,
                ),
              ),
            )
          ]),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'From:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            CupertinoButton(
                child: Text(
                  buildTimeString(fromTime),
                  style: const TextStyle(fontSize: 22),
                ),
                onPressed: () async {
                  var newFromTime = await showTimePicker(
                    initialEntryMode: TimePickerEntryMode.input,
                    initialTime: fromTime!,
                    context: context,
                  );
                  if (newFromTime != null) fromTime = newFromTime;

                  setState(() {});
                })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'To:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            CupertinoButton(
                child: Text(
                  buildTimeString(toTime),
                  style: const TextStyle(fontSize: 22),
                ),
                onPressed: () async {
                  var newToTime = await showTimePicker(
                    initialEntryMode: TimePickerEntryMode.input,
                    initialTime: toTime!,
                    context: context,
                  );
                  if (newToTime != null) toTime = newToTime;

                  setState(() {});
                })
          ],
        ),
        const SizedBox(
          height: 75,
        ),
        CupertinoButton.filled(
          child: const Text('Save'),
          onPressed: () async {
            var params = {
              'dayOfWeek': selectedDayOfWeek - 1,
              'fromTime': buildTimeString(fromTime),
              'toTime': buildTimeString(toTime),
            };
            Provider.of<AvailabilityProvider>(context, listen: false)
                .createAvailability(params);
            Navigator.of(context).pop();
          },
        )
      ]),
    );
  }
}
