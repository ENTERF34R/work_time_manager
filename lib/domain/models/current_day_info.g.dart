// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_day_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrentDayInfo _$CurrentDayInfoFromJson(Map<String, dynamic> json) =>
    CurrentDayInfo(
      const TimeOfDayJsonConverter()
          .fromJson(json['arriveTime'] as Map<String, dynamic>),
      const TimeOfDayJsonConverter()
          .fromJson(json['amountTime'] as Map<String, dynamic>),
      json['note'] as String,
    );

Map<String, dynamic> _$CurrentDayInfoToJson(CurrentDayInfo instance) =>
    <String, dynamic>{
      'arriveTime': const TimeOfDayJsonConverter().toJson(instance.arriveTime),
      'amountTime': const TimeOfDayJsonConverter().toJson(instance.amountTime),
      'note': instance.note,
    };
