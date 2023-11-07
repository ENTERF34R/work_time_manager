import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time_manager/data_access/day_info_service.dart';
import 'package:work_time_manager/data_access/month_info_service.dart';
import 'package:work_time_manager/domain/dependencies/i_day_info_service.dart';
import 'package:work_time_manager/domain/dependencies/i_month_info_service.dart';
import 'package:work_time_manager/domain/providers/current_day_provider.dart';
import 'package:work_time_manager/domain/providers/month_statistics_provider.dart';
import 'package:work_time_manager/presentation/screens/main_screen.dart';
import 'package:window_size/window_size.dart' as window_size;

void main() {
  IDayInfoService dayInfoService = DayInfoService();
  IMonthInfoService monthInfoService = MonthInfoService();

  var provider = MultiProvider(providers: [
    ChangeNotifierProvider(create: (ctx) => CurrentDayProvider(dayInfoService, monthInfoService, const TimeOfDay(hour: 8, minute: 45))),
    Provider(create: (ctx) => MonthStatisticsProvider(monthInfoService))
  ], child: const MyApp());

  runApp(provider);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    window_size.setWindowMaxSize(const Size(1130, 730));
    window_size.setWindowMinSize(const Size(1130, 730));

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen()
    );
  }
}
