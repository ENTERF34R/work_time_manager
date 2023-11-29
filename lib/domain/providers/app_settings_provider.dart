import 'package:flutter/material.dart';
import 'package:work_time_manager/domain/dependencies/i_app_settings_service.dart';
import 'package:work_time_manager/domain/external/i_app_settings_provider.dart';
import 'package:work_time_manager/domain/models/app_settings.dart';
import 'package:work_time_manager/domain/models/time_interval.dart';

class AppSettingProvider with ChangeNotifier implements IAppSettingsProvider {
  final IAppSettingsService _appSettingsService;
  AppSettings? _appSettings;

  AppSettingProvider({required IAppSettingsService service})
      : _appSettingsService = service;

  @override
  Future<AppSettings> getAppSettings() async {
    if (_appSettings == null) {
      _appSettings = await _appSettingsService.load();
      _appSettings ??= AppSettings(const TimeOfDay(hour: 8, minute: 45), const TimeOfDay(hour: 0, minute: 10), {
        "Обед": TimeInterval(const TimeOfDay(hour: 12, minute: 45), const TimeOfDay(hour: 13, minute: 30))
      });
    }

    return _appSettings!;
  }

  @override
  Future<bool> saveAppSettings() async {
    if (_appSettings != null) {
      return _appSettingsService.save(_appSettings!);
    } else {
      return false;
    }
  }
}