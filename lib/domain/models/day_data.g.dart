// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayData _$DayDataFromJson(Map<String, dynamic> json) => DayData(
      const TimeOfDayJsonConverter()
          .fromJson(json['arriveTime'] as Map<String, dynamic>),
      const TimeOfDayJsonConverter()
          .fromJson(json['amountTime'] as Map<String, dynamic>),
      json['note'] as String,
    );

Map<String, dynamic> _$DayDataToJson(DayData instance) => <String, dynamic>{
      'arriveTime': const TimeOfDayJsonConverter().toJson(instance.arriveTime),
      'amountTime': const TimeOfDayJsonConverter().toJson(instance.amountTime),
      'note': instance.note,
    };
