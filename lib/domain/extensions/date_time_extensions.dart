import 'package:flutter/material.dart';

extension DateTimeTextnsions on DateTime {
  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  bool sameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
