// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_interval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeInterval _$TimeIntervalFromJson(Map<String, dynamic> json) => TimeInterval(
      const TimeOfDayJsonConverter()
          .fromJson(json['start'] as Map<String, dynamic>),
      const TimeOfDayJsonConverter()
          .fromJson(json['end'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimeIntervalToJson(TimeInterval instance) =>
    <String, dynamic>{
      'start': const TimeOfDayJsonConverter().toJson(instance.start),
      'end': const TimeOfDayJsonConverter().toJson(instance.end),
    };
