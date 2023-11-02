import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:work_time_manager/domain/converters/time_of_day_json_converter.dart';
import 'package:work_time_manager/domain/extensions/time_of_day_extensions.dart';

part 'time_interval.g.dart';

@JsonSerializable(converters: [ TimeOfDayJsonConverter() ])
class TimeInterval {
  TimeOfDay start;
  TimeOfDay end;

  TimeInterval(this.start, this.end) {
    TimeOfDay diff = end.subtract(start);
    if (diff.hour < 0 || (diff.hour == 0 && diff.minute == 0)) {
      throw Exception("End can't be before start");
    }
  }

  TimeOfDay interval({List<TimeInterval>? skips}) {
    TimeOfDay result = end.subtract(start);

    if (skips != null) {
      for (var skip in skips) {
        // Если интервал начинается за концом текущего,
        // или заканчивается за его началом - пропускаем его
        if (skip.start >= end || skip.end < start) {
          continue;
        }

        // Если пропускаемый интервал заканчивается после текущего
        if (skip.end > end) {
          result.subtract(TimeInterval(skip.start, end).interval());
        // Если пропускаемый интервал начинается до текущего
        } else if (skip.start < start) {
          result.subtract(TimeInterval(start, skip.end).interval());
        // Если пропускаемый интервал полностью попадает в текущий
        } else {
          result.subtract(skip.interval());
        }
      }
    }

    if (result.hour < 0) {
      result = const TimeOfDay(hour: 0, minute: 0);
    }

    return result;
  }

  factory TimeInterval.fromJson(Map<String, dynamic> json) => _$TimeIntervalFromJson(json);

  Map<String, dynamic> toJson() => _$TimeIntervalToJson(this);
}