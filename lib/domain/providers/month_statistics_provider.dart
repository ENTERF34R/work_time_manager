import 'package:flutter/material.dart';
import 'package:work_time_manager/domain/dependencies/i_month_info_service.dart';
import 'package:work_time_manager/domain/extensions/time_of_day_extensions.dart';
import 'package:work_time_manager/domain/models/month_statistics.dart';
import 'package:quiver/core.dart';

import '../external/i_month_statistics_provider.dart';

class MonthStatisticsProvider implements IMonthStatisticsProvider {
  final IMonthInfoService _monthInfoService;
  final Map<String, MonthStatistics> _months = {};

  MonthStatisticsProvider(this._monthInfoService);

  @override
  Future<MonthStatistics> getMonth(int year, int month) async {
    if (_months.containsKey("${year}_$month")) {
      return _months["${year}_$month"]!;
    }

    MonthStatistics? m = await _monthInfoService.getMonth(year, month);
    if (m != null) {
      return m;
    } else {
      m = MonthStatistics(year: year, month: month, statistics: []);
      _months["${year}_$month"] = m;
      return m;
    }
  }

  Future<bool> saveMonth(MonthStatistics month) async {
    bool result = await _monthInfoService.saveMonth(month);
    if (result) {
      _months["${month.year}_${month.month}"] = month;
    }

    return result;
  }
}