import 'package:work_time_manager/domain/models/day_info.dart';

/*
  Интерфес, описывающий сервис, предоставляющий доступ к объекту DayInfo,
  представляющему текущий рабочий день
*/
abstract class IDayInfoService {
  Future<DayInfo?> getCurrentDay();
  Future<bool> saveCurrentDay(DayInfo dayInfo);
}