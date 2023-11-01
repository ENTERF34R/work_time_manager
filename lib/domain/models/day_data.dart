import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:quiver/core.dart';
import 'package:work_time_manager/domain/extensions/time_of_day_extensions.dart';
import '../converters/time_of_day_json_converter.dart';

part 'day_data.g.dart';

@JsonSerializable(converters: [ TimeOfDayJsonConverter() ])
class DayData {
  final TimeOfDay arriveTime;
  final TimeOfDay amountTime;
  final String note;

  DayData(this.arriveTime, this.amountTime, this.note);

  TimeOfDay get elapsedTime => TimeOfDay.now().subtract(arriveTime);

  TimeOfDay get leftTime => amountTime.subtract(elapsedTime);

  DayData.newArriveTime(this.arriveTime, DayData data)
      : amountTime = data.amountTime, note = data.note;

  DayData.newAmountTime(this.amountTime, DayData data)
      : arriveTime = data.arriveTime, note = data.note;

  DayData.newNote(this.note, DayData data)
      : arriveTime = data.arriveTime, amountTime = data.amountTime;

  @override
  bool operator == (Object other) =>
      other is DayData &&
      other.runtimeType == runtimeType &&
      other.arriveTime == arriveTime &&
      other.amountTime == amountTime &&
      other.note == note;

  @override
  int get hashCode => hash3(arriveTime, amountTime, note);

  factory DayData.fromJson(Map<String, dynamic> json) => _$DayDataFromJson(json);

  Map<String, dynamic> toJson() => _$DayDataToJson(this);
}