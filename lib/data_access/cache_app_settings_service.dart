import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as path;
import 'package:work_time_manager/domain/dependencies/i_app_settings_service.dart';
import 'package:work_time_manager/domain/models/app_settings.dart';

/*
  Реализация интерфейса IAppSettingsService на основе локального кэша
*/
class CacheAppSettingsService implements IAppSettingsService {
  @override
  Future<AppSettings?> load() async {
    Directory dir = await path.getApplicationCacheDirectory();
    File file = File("${dir.absolute.path}/app_settings.wtm");

    try {
      if (await file.exists()) {
        String raw = await file.readAsString();
        Map<String, dynamic> json = jsonDecode(raw);
        AppSettings appSettings = AppSettings.fromJson(json);

        return appSettings;
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  @override
  Future<bool> save(AppSettings appSettings) async {
    Directory dir = await path.getApplicationCacheDirectory();
    File file = File("${dir.absolute.path}/app_settings.wtm");

    try {
      if (await file.exists()) {
        await file.delete();
      }

      Map<String, dynamic> json = appSettings.toJson();
      String raw = jsonEncode(json);
      await file.writeAsString(raw);
      return true;
    } catch (_) {
      return false;
    }
  }
}
