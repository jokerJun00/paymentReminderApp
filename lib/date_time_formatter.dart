import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final DateTime now = DateTime.now();

    final updatedDateTime = DateTime(now.year, dateTime.month, dateTime.day);

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
