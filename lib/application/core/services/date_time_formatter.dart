import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');

    return formatter.format(dateTime);
  }

  static String formatPaymentDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM');

    return formatter.format(dateTime);
  }

  static String formatDay(DateTime date) {
    int day = date.day;
    if (day == 1) {
      return '${day}st';
    } else if (day == 2) {
      return '${day}nd';
    } else if (day == 3) {
      return '${day}rd';
    } else {
      return '${day}th';
    }
  }

  static String formatMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "Wrong format, month cannot retrieve";
    }
  }

  static DateTime findNextMatchingDate(DateTime currentDate) {
    final now = DateTime.now();
    final nextYear = now.year + 1; // Adding a year for loop boundary
    DateTime nextMatchingDate = currentDate;

    while (nextMatchingDate
        .isBefore(DateTime(nextYear, currentDate.month, currentDate.day))) {
      nextMatchingDate = nextMatchingDate.add(const Duration(days: 1));
    }

    return nextMatchingDate;
  }
}
