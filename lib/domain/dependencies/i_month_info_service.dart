import 'package:work_time_manager/domain/models/month_statistics.dart';

abstract class IMonthInfoService {
  Future<MonthStatistics?> getMonth(int year, int month);
  Future<bool> saveMonth(MonthStatistics month);
}