import 'package:work_time_manager/domain/models/app_settings.dart';

/*
  Интерфес, описывающий сервис, предоставляющий доступ к объекту AppSettings,
  представляющему настройки приложения
*/
abstract class IAppSettingsService {
  Future<AppSettings?> load();
  Future<bool> save(AppSettings appSettings);
}