import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:work_time_manager/domain/converters/time_of_day_json_converter.dart';
import 'package:work_time_manager/domain/extensions/time_of_day_extensions.dart';

part 'current_day_info.g.dart';

@JsonSerializable(converters: [ TimeOfDayJsonConverter() ])
class CurrentDayInfo {
  TimeOfDay arriveTime;
  TimeOfDay amountTime;
  String note;

  CurrentDayInfo(this.arriveTime, this.amountTime, this.note);

  TimeOfDay get timePassed => TimeOfDay.now().subtract(arriveTime);

  TimeOfDay get timeLeft => amountTime.subtract(timePassed);

  factory CurrentDayInfo.fromJson(Map<String, dynamic> json) => _$CurrentDayInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentDayInfoToJson(this);
}