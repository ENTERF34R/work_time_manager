import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';
import 'package:work_time_manager/domain/dependencies/i_day_info_service.dart';
import 'package:work_time_manager/domain/dependencies/i_month_info_service.dart';
import 'package:work_time_manager/domain/extensions/date_time_extensions.dart';
import 'package:work_time_manager/domain/external/i_current_day_provider.dart';
import 'package:work_time_manager/domain/models/current_day_info.dart';
import 'package:work_time_manager/domain/models/day_info.dart';
import 'package:work_time_manager/domain/models/month_statistics.dart';

class CurrentDayProvider implements ICurrentDayProvider {
  final IDayInfoService _dayInfoService;
  final IMonthInfoService _monthInfoService;
  final TimeOfDay _amountTime;
  CurrentDayInfo? _currentDay;


  CurrentDayProvider(this._dayInfoService, this._monthInfoService, this._amountTime);

  @override
  Future<CurrentDayInfo> getCurrentDay() async {
    if (_currentDay == null) {
      try {
        DayInfo? dayInfo = await _dayInfoService.getCurrentDay();
        if (dayInfo == null) {
          _currentDay = CurrentDayInfo(
              arriveTime: DateTime.now(), amountTime: _amountTime);
        } else {
          DateTime now = DateTime.now();
          if (dayInfo.arriveTime.sameDate(now)) {
            _currentDay = dayInfo.toCurrentDayInfo();
          } else {
            MonthStatistics? month = await _monthInfoService.getMonth(dayInfo.arriveTime.year, dayInfo.arriveTime.month);
            if (month == null) {
              month = MonthStatistics(year: dayInfo.arriveTime.year, month: dayInfo.arriveTime.month, statistics: [
                dayInfo
              ]);
            } else {
              month.statistics.add(dayInfo);
            }

            await _monthInfoService.saveMonth(month);

            _currentDay = CurrentDayInfo(arriveTime: now, amountTime: _amountTime);
          }
        }
      } catch(_) {
        _currentDay = _currentDay;
      }
    }

    return _currentDay!;
  }

  @override
  Future<bool> saveCurrentDay() async {
    if (_currentDay != null) {
      var lock = Lock();
      lock.synchronized(() => {

      });
      return await _dayInfoService.saveCurrentDay(_currentDay!.toDayInfo());
    }

    return false;
  }
}