// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayInfo _$DayInfoFromJson(Map<String, dynamic> json) => DayInfo(
      DateTime.parse(json['arriveTime'] as String),
      const TimeOfDayJsonConverter()
          .fromJson(json['amountTime'] as Map<String, dynamic>),
      const TimeOfDayJsonConverter()
          .fromJson(json['workTime'] as Map<String, dynamic>),
      json['note'] as String,
    );

Map<String, dynamic> _$DayInfoToJson(DayInfo instance) => <String, dynamic>{
      'arriveTime': instance.arriveTime.toIso8601String(),
      'amountTime': const TimeOfDayJsonConverter().toJson(instance.amountTime),
      'workTime': const TimeOfDayJsonConverter().toJson(instance.workTime),
      'note': instance.note,
    };
