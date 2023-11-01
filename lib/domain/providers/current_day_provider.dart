import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:work_time_manager/data_access/data_accessor.dart';

import '../models/day_data.dart';

class CurrentDayProvider with ChangeNotifier {
  final DataAccessor _dataAccessor;
  DayData? _currentDay;

  CurrentDayProvider(this._dataAccessor);

  Future<bool> initialize() async {
    DateTime now = DateTime.now();
    String filename = "${now.day}_${now.month}_${now.year}.wtm";
    String? data = await _dataAccessor.loadData(filename);
    DayData? result;

    if (data != null) {
      try {
        var json = jsonDecode(data);
        result = DayData.fromJson(json);
      } catch (_) {}
    }

    if (result == null) {
      _currentDay = DayData(TimeOfDay.now(), const TimeOfDay(hour: 8, minute: 45), "");
      await _dataAccessor.saveData(filename, jsonEncode(_currentDay));
    } else {
      _currentDay = result;
    }

    return true;
  }

  DayData get currentDay => _currentDay!;

  // todo: upgrade logic
  Future updateCurrentDay(DayData newDay) async {
    DateTime now = DateTime.now();
    String filename = "${now.day}_${now.month}_${now.year}.wtm";

    try {
      if (await _dataAccessor.saveData(filename, jsonEncode(newDay.toJson()))) {
        _currentDay = newDay;
      }
    } catch (_) {}
  }
}