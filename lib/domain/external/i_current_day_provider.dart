import 'package:work_time_manager/domain/models/current_day_info.dart';

abstract class ICurrentDayProvider {
  Future<CurrentDayInfo> getCurrentDay();
  Future<bool> saveCurrentDay();
}