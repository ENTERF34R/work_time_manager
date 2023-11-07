import 'package:flutter/material.dart';

extension DateTimeTextnsions on DateTime {
  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  bool sameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  DateTime newTime({ required int hour, required int minute, int second = 0 }) {
    return DateTime(year, month, day, hour, minute, second);
  }

  String hourToString() {
    int h = hour.abs();

    if (h < 10) {
      return "0$h";
    } else {
      return h.toString();
    }
  }

  String minuteToString() {
    int m = minute.abs();

    if (m < 10) {
      return "0$m";
    } else {
      return m.toString();
    }
  }
}
