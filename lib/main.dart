import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time_manager/data_access/cache_app_settings_service.dart';
import 'package:work_time_manager/data_access/cache_day_info_service.dart';
import 'package:work_time_manager/data_access/cache_month_info_service.dart';
import 'package:work_time_manager/domain/dependencies/i_app_settings_service.dart';
import 'package:work_time_manager/domain/dependencies/i_day_info_service.dart';
import 'package:work_time_manager/domain/dependencies/i_month_info_service.dart';
import 'package:work_time_manager/domain/external/i_app_settings_provider.dart';
import 'package:work_time_manager/domain/external/i_current_day_provider.dart';
import 'package:work_time_manager/domain/providers/app_settings_provider.dart';
import 'package:work_time_manager/domain/providers/current_day_provider.dart';
import 'package:work_time_manager/domain/providers/month_statistics_provider.dart';
import 'package:work_time_manager/presentation/screens/main_screen.dart';

void main() {
  IDayInfoService dayInfoService = CacheDayInfoService();
  IMonthInfoService monthInfoService = CacheMonthInfoService();
  IAppSettingsService appSettingsService = CacheAppSettingsService();

  var provider = MultiProvider(providers: [
    ChangeNotifierProvider<ICurrentDayProvider>(create: (ctx) => CurrentDayProvider(dayInfoService, monthInfoService)),
    ChangeNotifierProvider<IAppSettingsProvider>(create: (ctx) => AppSettingProvider(service: appSettingsService)),
    Provider(create: (ctx) => MonthStatisticsProvider(monthInfoService))
  ], child: const MyApp());

  runApp(provider);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen()
    );
  }
}
