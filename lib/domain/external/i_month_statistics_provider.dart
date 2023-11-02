import 'package:work_time_manager/domain/models/month_statistics.dart';

abstract class IMonthStatisticsProvider {
  Future<MonthStatistics> getMonth(int year, int month);
}