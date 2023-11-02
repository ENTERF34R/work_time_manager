import 'package:work_time_manager/domain/dependencies/i_month_info_service.dart';
import 'package:work_time_manager/domain/models/month_statistics.dart';

class MonthInfoService implements IMonthInfoService {
  @override
  Future<MonthStatistics?> getMonth(int year, int month) {
    // TODO: implement getMonth
    throw UnimplementedError();
  }

  @override
  Future<bool> saveMonth(MonthStatistics month) {
    // TODO: implement saveMonth
    throw UnimplementedError();
  }
}