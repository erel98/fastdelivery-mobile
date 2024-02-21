class Global {
  static int globalIndex = 0;
  static bool isLoading = false;
  static Map<String, int> statusCodes = {
    'Received': 1,
    'Dispatched': 2,
    'In Transit': 3,
    'Delivered': 4
  };
  static String getWeekDay(int day) {
    String weekDay = '';
    if (day == 0) {
      weekDay = 'Monday';
    } else if (day == 1) {
      weekDay = 'Tuesday';
    } else if (day == 2) {
      weekDay = 'Wednesday';
    } else if (day == 3) {
      weekDay = 'Thursday';
    } else if (day == 4) {
      weekDay = 'Friday';
    } else if (day == 5) {
      weekDay = 'Saturday';
    } else if (day == 6) {
      weekDay = 'Sunday';
    }

    return weekDay;
  }

  static String currentSelectedStatus = '';
}
