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
    int hour, minute;

    if (this > time) {
      hour = this.hour - time.hour;
      minute = this.minute - time.minute;

      if (minute < 0) {
        hour--;
        minute += 60;
      }
    } else if (this < time) {
      hour = time.hour - this.hour;
      minute = time.minute - this.minute;

      if (minute < 0) {
        hour--;
        minute += 60;
      }

      if (hour != 0) {
        hour *= -1;
      } else {
        minute *= -1;
      }
    } else {
      hour = 0;
      minute = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  bool operator <(other) {
    if (other is TimeOfDay) {
      if (hour == other.hour) {
        return minute < other.minute;
      } else {
        return hour < other.hour;
      }
    }

    return false;
  }

  bool operator >(other) {
    if (other is TimeOfDay) {
      if (hour == other.hour) {
        bool res = minute > other.minute;
        return res;
      } else {
        return hour > other.hour;
      }
    }

    return false;
  }

  bool operator <=(other) {
    if (other is TimeOfDay) {
      return this == other || this < other;
    }

    return false;
  }

  bool operator >=(other) {
    if (other is TimeOfDay) {
      return this == other || this > other;
    }

    return false;
  }

  double operator /(TimeOfDay other) {
    double thisAmount = hour.toDouble() * 60 + minute.toDouble();
    double otherAmount = other.hour.toDouble() * 60 + other.minute.toDouble();

    return thisAmount / otherAmount;
  }

  double toDouble() => hour + minute / 60;

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
