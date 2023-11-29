import 'package:flutter/material.dart';
import 'package:work_time_manager/domain/models/app_settings.dart';
import 'package:work_time_manager/domain/models/current_day_info.dart';

abstract class ICurrentDayProvider with ChangeNotifier {
  Future<CurrentDayInfo> getCurrentDay(AppSettings settings);
  Future<bool> saveCurrentDay();
}