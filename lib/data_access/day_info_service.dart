import 'dart:convert';
import 'dart:io';

import 'package:work_time_manager/domain/dependencies/i_day_info_service.dart';
import 'package:work_time_manager/domain/models/current_day_info.dart';
import 'package:work_time_manager/domain/models/day_info.dart';
import 'package:path_provider/path_provider.dart' as path;

class DayInfoService implements IDayInfoService {
  @override
  Future<DayInfo?> getCurrentDay() async {
    Directory dir = await path.getApplicationCacheDirectory();
    File file = File("${dir.absolute.path}/current.wtm");

    try {
      if (await file.exists()) {
        String raw = await file.readAsString();
        Map<String, dynamic> json = jsonDecode(raw);
        DayInfo dayInfo = DayInfo.fromJson(json);
        return dayInfo;
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  @override
  Future<bool> saveCurrentDay(DayInfo dayInfo) async {
    Directory dir = await path.getApplicationCacheDirectory();
    File file = File("${dir.absolute.path}/current.wtm");

    try {
      if (await file.exists()) {
        file.delete();
      }

      Map<String, dynamic> json = dayInfo.toJson();
      String raw = jsonEncode(json);
      file.writeAsString(raw);
      return true;
    } catch (_) {
      return false;
    }
  }
}