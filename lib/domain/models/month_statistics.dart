import 'package:json_annotation/json_annotation.dart';
import '../models/day_info.dart';

part 'month_statistics.g.dart';

@JsonSerializable()
class MonthStatistics {
  int year;
  int month;
  final List<DayInfo> statistics;

  MonthStatistics({ required this.year, required this.month, required this.statistics});

  factory MonthStatistics.fromJson(Map<String, dynamic> json) => _$MonthStatisticsFromJson(json);

  Map<String, dynamic> toJson() => _$MonthStatisticsToJson(this);
}