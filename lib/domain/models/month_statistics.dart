import '../models/day_info.dart';

class MonthStatistics {
  int year;
  int month;
  final List<DayInfo> statistics;

  MonthStatistics({ required this.year, required this.month, required this.statistics});
}