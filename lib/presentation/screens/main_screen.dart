import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time_manager/domain/models/day_data.dart';
import 'package:work_time_manager/presentation/widgets/day_note.dart';
import 'package:work_time_manager/presentation/widgets/day_statistics.dart';
import 'package:work_time_manager/presentation/widgets/item_container.dart';
import 'package:work_time_manager/presentation/widgets/month_statistics.dart';
import 'package:work_time_manager/presentation/widgets/time_input.dart';

import '../../domain/providers/current_day_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ValueNotifier<bool> saveNotifier = ValueNotifier(false);
  TextEditingController controller = TextEditingController();
  String txtElapsed = "";
  String txtLeft = "";
  String labelLeft = "Осталось";

  @override
  Widget build(BuildContext context) {
    CurrentDayProvider currentDayProvider =
        Provider.of<CurrentDayProvider>(context);

    String tab2Text = "";
    Random rand = Random();
    switch (rand.nextInt(3)) {
      case 2:
        tab2Text = "Молодой человек, вкладка не для вас расположена";
        break;
      case 1:
        tab2Text = "Дополнительный контент всего за 9.99\$";
        break;
      case 0:
        tab2Text =
            "Заходит как то пользователь во вторую вкладку, а там армяне в нарды играют";
        break;
    }

    return FutureBuilder(future: () async {
      return await currentDayProvider.initialize();
    }(), builder: (context, snapshot) {
      if (snapshot.hasError || (snapshot.hasData && snapshot.data == false)) {
        return const Align(
          alignment: Alignment.center,
          child: Text("Some error occurred",
              style: TextStyle(fontSize: 30, color: Colors.red)),
        );
      } else if (snapshot.hasData && snapshot.data == true) {
        return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                bottom: const TabBar(tabs: [
                  Tab(
                      icon: Icon(Icons.access_alarm, color: Colors.blue),
                      height: 40),
                  Tab(icon: Icon(Icons.settings, color: Colors.blue))
                ]),
              ),
              body: TabBarView(
                children: [
                  Scaffold(
                      backgroundColor: Colors.blueGrey.shade400,
                      body: Container(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                TimeInput(
                                    savePressed: (h, m) => () async {
                                          await saveCurrentDay(
                                              currentDayProvider,
                                              DayData.newArriveTime(
                                                  TimeOfDay(hour: h, minute: m),
                                                  currentDayProvider
                                                      .currentDay));
                                        }(),
                                    saveNotifier: saveNotifier),
                                const Padding(
                                    padding: EdgeInsets.only(left: 30)),
                                DayStatistics(
                                    savePressed: (t) => () async {
                                          await saveCurrentDay(
                                              currentDayProvider,
                                              DayData.newAmountTime(
                                                  t,
                                                  currentDayProvider
                                                      .currentDay));
                                        }(),
                                    saveNotifier: saveNotifier),
                                const Padding(
                                    padding: EdgeInsets.only(left: 30)),
                                SizedBox(
                                  width: 370,
                                  height: 200,
                                  child: ItemContainer(
                                      child: Container(
                                          padding: EdgeInsets.all(15),
                                          child: FittedBox(
                                              fit: BoxFit.fill,
                                              child: IconButton(
                                                  onPressed: () => print(
                                                      MediaQuery.of(context)
                                                          .size),
                                                  icon: Image.file(File(
                                                      "C:/Users/Ayaya/Downloads/naruto.jpg")))))),
                                )
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(top: 30)),
                            Row(
                              children: [
                                DayNote(
                                    savePressed: (s) => () async {
                                          await saveCurrentDay(
                                              currentDayProvider,
                                              DayData.newNote(
                                                  s,
                                                  currentDayProvider
                                                      .currentDay));
                                        }(),
                                    saveNotifier: saveNotifier),
                                const Padding(
                                    padding: EdgeInsets.only(left: 30)),
                                const MonthStatistics(),
                              ],
                            )
                          ],
                        ),
                      )),
                  Align(
                    alignment: Alignment.center,
                    child: Text(tab2Text),
                  )
                ],
              ),
            ));
      }

      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: const Align(
            alignment: Alignment.center, child: CircularProgressIndicator()),
      );
    });
  }

  Future saveCurrentDay(CurrentDayProvider provider, DayData data) async {
    saveNotifier.value = true;
    await provider.updateCurrentDay(data);
    saveNotifier.value = false;
  }
}
