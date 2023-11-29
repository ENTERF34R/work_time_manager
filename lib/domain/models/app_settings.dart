import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:work_time_manager/domain/converters/time_of_day_json_converter.dart';
import 'package:work_time_manager/domain/models/time_interval.dart';

part 'app_settings.g.dart';

@JsonSerializable(converters: [ TimeOfDayJsonConverter() ])
class AppSettings {
  TimeOfDay defaultWorkTime;
  TimeOfDay addTime;
  Map<String, TimeInterval> defaultSkips;

  AppSettings(this.defaultWorkTime, this.addTime, this.defaultSkips);

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);
}