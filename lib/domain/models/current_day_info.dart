import 'package:flutter/material.dart';
import 'package:work_time_manager/domain/extensions/date_time_extensions.dart';
import 'package:work_time_manager/domain/extensions/time_of_day_extensions.dart';
import 'package:work_time_manager/domain/models/day_info.dart';

class CurrentDayInfo {
  DateTime arriveTime;
  TimeOfDay amountTime;
  String note;

  CurrentDayInfo({ required this.arriveTime, required this.amountTime, this.note = "" });

  TimeOfDay get workTime => TimeOfDay.now().subtract(arriveTime.time);

  DayInfo toDayInfo() => DayInfo(arriveTime, amountTime, workTime, note);
}