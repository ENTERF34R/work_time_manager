import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synchronized/synchronized.dart';
import 'package:work_time_manager/domain/dependencies/i_day_info_service.dart';
import 'package:work_time_manager/domain/dependencies/i_month_info_service.dart';
import 'package:work_time_manager/domain/extensions/date_time_extensions.dart';
import 'package:work_time_manager/domain/external/i_current_day_provider.dart';
import 'package:work_time_manager/domain/models/app_settings.dart';
import 'package:work_time_manager/domain/models/current_day_info.dart';
import 'package:work_time_manager/domain/models/day_info.dart';
import 'package:work_time_manager/domain/models/month_statistics.dart';
import 'package:work_time_manager/domain/models/time_interval.dart';

class CurrentDayProvider with ChangeNotifier implements ICurrentDayProvider {
  final IDayInfoService _dayInfoService;
  final IMonthInfoService _monthInfoService;
  CurrentDayInfo? _currentDay;
  Timer? _timer;

  CurrentDayProvider(
      this._dayInfoService, this._monthInfoService);

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Future<CurrentDayInfo> getCurrentDay(AppSettings settings) async {
    _timer ??= Timer.periodic(const Duration(seconds: 15), (timer) async {
      await saveCurrentDay();
    });

    if (_currentDay == null) {
      try {
        DayInfo? dayInfo = await _dayInfoService.getCurrentDay();
        if (dayInfo == null) {
          _currentDay = CurrentDayInfo(
              arriveTime: DateTime.now(), amountTime: settings.defaultWorkTime);
          _currentDay!.skips = Map.from(settings.defaultSkips);
        } else {
          DateTime now = DateTime.now();
          if (dayInfo.arriveTime.sameDate(now)) {
            _currentDay = dayInfo.toCurrentDayInfo();
          } else {
            MonthStatistics? month = await _monthInfoService.getMonth(
                dayInfo.arriveTime.year, dayInfo.arriveTime.month);
            if (month == null) {
              month = MonthStatistics(
                  year: dayInfo.arriveTime.year,
                  month: dayInfo.arriveTime.month,
                  statistics: [dayInfo]);
            } else {
              month.statistics.add(dayInfo);
            }

            await _monthInfoService.saveMonth(month);

            _currentDay =
                CurrentDayInfo(arriveTime: now, amountTime: settings.defaultWorkTime);
          }
        }
      } catch (_) {
        _currentDay = _currentDay;
      }
    }

    return _currentDay!;
  }

  @override
  Future<bool> saveCurrentDay() async {
    if (_currentDay != null) {
      var lock = Lock();
      return await lock.synchronized<bool>(() async {
        bool res = await _dayInfoService.saveCurrentDay(_currentDay!.toDayInfo());
        notifyListeners();
        return res;
      });
    }

    return false;
  }
}
