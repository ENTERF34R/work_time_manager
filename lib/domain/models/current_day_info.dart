import 'package:flutter/material.dart';
import 'package:work_time_manager/domain/extensions/date_time_extensions.dart';
import 'package:work_time_manager/domain/models/day_info.dart';
import 'package:work_time_manager/domain/models/time_interval.dart';

class CurrentDayInfo {
  DateTime arriveTime;
  TimeOfDay amountTime;
  String note;
  Map<String, TimeInterval> skips = {};

  CurrentDayInfo({ required this.arriveTime, required this.amountTime, this.note = ""});

  TimeOfDay get workTime => TimeInterval(arriveTime.time, TimeOfDay.now()).remove(intervals: skips.values.toList());

  DayInfo toDayInfo() => DayInfo(arriveTime, amountTime, workTime, note, skips);
}