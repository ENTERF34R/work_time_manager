import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  TimeOfDay add(TimeOfDay time) {
    int hour = this.hour + time.hour;
    int minute = this.minute + time.minute;

    if (minute >= 60) {
      hour++;
      minute -= 60;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  TimeOfDay subtract(TimeOfDay time) {
    int hour = this.hour - time.hour;
    int minute = this.minute - time.minute;

    if (minute < 0) {
      hour--;
      minute += 60;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }
}