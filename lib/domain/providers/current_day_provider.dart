import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:work_time_manager/data_access/data_accessor.dart';
import 'package:work_time_manager/domain/models/current_day_info.dart';


class CurrentDayProvider with ChangeNotifier {
  final DataAccessor _dataAccessor;
  CurrentDayInfo? _currentDay;

  CurrentDayProvider(this._dataAccessor);

  Future<bool> initialize() async {
    DateTime now = DateTime.now();
    String filename = "${now.day}_${now.month}_${now.year}.wtm";
    String? data = await _dataAccessor.loadData(filename);
    CurrentDayInfo? result;

    if (data != null) {
      try {
        var json = jsonDecode(data);
        result = CurrentDayInfo.fromJson(json);
      } catch (_) {}
    }

    if (result == null) {
      _currentDay = CurrentDayInfo(TimeOfDay.now(), const TimeOfDay(hour: 8, minute: 45), "");
      await _dataAccessor.saveData(filename, jsonEncode(_currentDay));
    } else {
      _currentDay = result;
    }

    return true;
  }

  CurrentDayInfo get currentDay => _currentDay!;

  // todo: upgrade logic
  Future save() async {
    DateTime now = DateTime.now();
    String filename = "${now.day}_${now.month}_${now.year}.wtm";

    try {
      await _dataAccessor.saveData(filename, jsonEncode(_currentDay?.toJson()));
    } catch (_) {}
  }
}