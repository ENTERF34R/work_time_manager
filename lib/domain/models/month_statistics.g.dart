// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonthStatistics _$MonthStatisticsFromJson(Map<String, dynamic> json) =>
    MonthStatistics(
      year: json['year'] as int,
      month: json['month'] as int,
      statistics: (json['statistics'] as List<dynamic>)
          .map((e) => DayInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MonthStatisticsToJson(MonthStatistics instance) =>
    <String, dynamic>{
      'year': instance.year,
      'month': instance.month,
      'statistics': instance.statistics,
    };
