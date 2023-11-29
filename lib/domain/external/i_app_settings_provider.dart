import 'package:flutter/material.dart';
import 'package:work_time_manager/domain/models/app_settings.dart';

abstract class IAppSettingsProvider with ChangeNotifier {
  Future<AppSettings> getAppSettings();
  Future<bool> saveAppSettings();
}