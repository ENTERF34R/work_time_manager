import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:work_time_manager/domain/extensions/time_of_day_extensions.dart';
import '../models/day_info.dart';

part 'month_statistics.g.dart';

@JsonSerializable()
class MonthStatistics {
  int year;
  int month;
  final List<DayInfo> statistics;

  MonthStatistics({ required this.year, required this.month, required this.statistics});

  static TimeOfDay getDiv(MonthStatistics monthStatistics) {
    TimeOfDay result = const TimeOfDay(hour: 0, minute: 0);

    for (var day in monthStatistics.statistics) {
      TimeOfDay div = day.workTime - day.amountTime;
      result = result + div;
    }

    return result;
  }

  factory MonthStatistics.fromJson(Map<String, dynamic> json) => _$MonthStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$MonthStatisticsToJson(this);
}