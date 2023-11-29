import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:work_time_manager/domain/models/time_interval.dart';
import '../converters/time_of_day_json_converter.dart';
import 'current_day_info.dart';

part 'day_info.g.dart';

@JsonSerializable(converters: [ TimeOfDayJsonConverter() ])
class DayInfo {
  final DateTime arriveTime;
  final TimeOfDay amountTime;
  final TimeOfDay workTime;
  final String note;
  final Map<String, TimeInterval>? skips;

  DayInfo(this.arriveTime, this.amountTime, this.workTime, this.note, this.skips);

  CurrentDayInfo toCurrentDayInfo () => CurrentDayInfo(arriveTime: arriveTime, amountTime: amountTime, note: note);

  factory DayInfo.fromJson(Map<String, dynamic> json) => _$DayInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DayInfoToJson(this);
}