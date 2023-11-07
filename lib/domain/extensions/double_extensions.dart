import 'package:flutter/material.dart';

extension DoubleExtensions on double {
  TimeOfDay toTimeOfDay() {
    int hour = floor();
    double m = this - hour;
    int minute = (60 * m).floor();

    return TimeOfDay(hour: hour, minute: minute);
  }
}