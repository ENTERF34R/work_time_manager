import 'package:flutter/material.dart';
import 'package:work_time_manager/domain/models/time_interval.dart';

void main() {
  TimeInterval base = TimeInterval(const TimeOfDay(hour: 5, minute: 0), const TimeOfDay(hour: 19, minute: 0));
  List<TimeInterval> skips = [
    TimeInterval(const TimeOfDay(hour: 2, minute: 0), const TimeOfDay(hour: 5, minute: 0)),
    TimeInterval(const TimeOfDay(hour: 19, minute: 0), const TimeOfDay(hour: 20, minute: 0)),
    TimeInterval(const TimeOfDay(hour: 9, minute: 0), const TimeOfDay(hour: 11, minute: 0)),
    TimeInterval(const TimeOfDay(hour: 10, minute: 0), const TimeOfDay(hour: 12, minute: 0)),
    TimeInterval(const TimeOfDay(hour: 4, minute: 0), const TimeOfDay(hour: 7, minute: 0)),
    TimeInterval(const TimeOfDay(hour: 17, minute: 0), const TimeOfDay(hour: 20, minute: 0))
  ];

  TimeOfDay result = base.remove(intervals: skips);
  print(result.toString());
}