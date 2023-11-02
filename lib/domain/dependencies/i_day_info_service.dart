import 'package:work_time_manager/domain/models/current_day_info.dart';
import 'package:work_time_manager/domain/models/day_info.dart';

abstract class IDayInfoService {
  Future<DayInfo?> getCurrentDay();
  Future<bool> saveCurrentDay(DayInfo dayInfo);
}