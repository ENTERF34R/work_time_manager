import 'dart:convert';
import 'dart:io';

import 'package:work_time_manager/domain/dependencies/i_month_info_service.dart';
import 'package:work_time_manager/domain/models/month_statistics.dart';
import 'package:path_provider/path_provider.dart' as path;

import '../domain/models/day_info.dart';

class MonthInfoService implements IMonthInfoService {
  @override
  Future<MonthStatistics?> getMonth(int year, int month) async {
    Directory dir = await path.getApplicationCacheDirectory();
    File file = File("${dir.absolute.path}/${year}_$month.wtm");

    try {
      if (await file.exists()) {
        String raw = await file.readAsString();
        Map<String, dynamic> json = jsonDecode(raw);
        return MonthStatistics.fromJson(json);
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  @override
  Future<bool> saveMonth(MonthStatistics month) async {
    Directory dir = await path.getApplicationCacheDirectory();
    File file = File("${dir.absolute.path}/${month.year}_${month.month}.wtm");

    try {
      if (await file.exists()) {
        file.delete();
      }

      Map<String, dynamic> json = month.toJson();
      String raw = jsonEncode(json);
      file.writeAsString(raw);
      return true;
    } catch (_) {
      return false;
    }
  }
}
