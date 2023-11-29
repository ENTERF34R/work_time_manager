import 'package:flutter/material.dart';

extension TimeOfDayExtensions on TimeOfDay {
  // Часы в строковом представлении в формате HH
  String hourToString() {
    int h = hour.abs();

    if (h < 10) {
      return "0$h";
    } else {
      return h.toString();
    }
  }

  // Минуты в строковом представлении в формате MM
  String minuteToString() {
    int m = minute.abs();

    if (m < 10) {
      return "0$m";
    } else {
      return m.toString();
    }
  }

  double toDouble() => hour + minute / 60;

  int toInt() => hour * 60 + minute;

  TimeOfDay operator +(TimeOfDay other) {
    int hour, minute;

    bool isThisNeg = (this.hour < 0 || this.minute < 0);
    int thisTime = this.hour.abs() * 60 + this.minute.abs();
    if (isThisNeg) {
      thisTime *= -1;
    }

    bool isOtherNeg = (other.hour < 0 || other.minute < 0);
    int otherTime = other.hour.abs() * 60 + other.minute.abs();
    if (isOtherNeg) {
      otherTime *= -1;
    }

    int allTime = thisTime + otherTime;
    if (allTime.abs() < 60) {
      return TimeOfDay(hour: 0, minute: allTime);
    } else {
      bool isAllNeg = allTime < 0;
      hour = (allTime.abs() / 60).floor();
      minute = allTime.abs() % 60;

      if (isAllNeg) {
        hour *= -1;
      }

      return TimeOfDay(hour: hour, minute: minute);
    }
  }

  TimeOfDay operator -(TimeOfDay other) {
    int hour, minute;

    if (this > other) {
      hour = this.hour - other.hour;
      minute = this.minute - other.minute;

      if (minute < 0) {
        hour--;
        minute += 60;
      }
    } else if (this < other) {
      hour = other.hour - this.hour;
      minute = other.minute - this.minute;

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
}
