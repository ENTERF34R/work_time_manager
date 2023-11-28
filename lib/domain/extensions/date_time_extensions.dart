import 'package:flutter/material.dart';

extension DateTimeExtensions on DateTime {
  // Выделить объект TimeOfDay
  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);

  // Сравнить только даты объектов DateTime
  bool sameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  // Создать новый объект DateTime с той же датой, но другим временем
  DateTime newTime({ required int hour, required int minute, int second = 0 }) {
    return DateTime(year, month, day, hour, minute, second);
  }

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
}
