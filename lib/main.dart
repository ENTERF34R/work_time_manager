import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time_manager/data_access/data_accessor.dart';
import 'package:work_time_manager/domain/providers/current_day_provider.dart';
import 'package:work_time_manager/presentation/screens/main_screen.dart';
import 'package:window_size/window_size.dart' as window_size;
import 'package:work_time_manager/presentation/screens/test_screen.dart';

void main() {
  DataAccessor dataAccessor = DataAccessor();
  CurrentDayProvider currentDayProvider = CurrentDayProvider(dataAccessor);

  var provider = ChangeNotifierProvider<CurrentDayProvider>.value(
      value: currentDayProvider, child: const MyApp());

  // runApp(provider);
  runApp(const TestApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //window_size.setWindowMaxSize(const Size(1146, 767));
    //window_size.setWindowMinSize(const Size(1146, 767));

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen()
    );
  }
}
