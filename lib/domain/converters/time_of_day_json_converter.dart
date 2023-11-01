import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class TimeOfDayJsonConverter extends JsonConverter<TimeOfDay, Map<String, dynamic>> {
  const TimeOfDayJsonConverter();

  @override
  TimeOfDay fromJson(Map<String, dynamic> json) {
    int? hour = json['hour'];
    int? minute = json['minute'];

    if (hour == null || minute == null) {
      throw const FormatException();
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay object) {
    return <String, dynamic> {
      "hour": object.hour,
      "minute": object.minute
    };
  }
}