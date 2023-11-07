import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_time_manager/domain/extensions/double_extensions.dart';
import 'package:work_time_manager/domain/models/month_statistics.dart';
import 'package:work_time_manager/domain/providers/month_statistics_provider.dart';
import 'package:work_time_manager/presentation/widgets/item_container.dart';
import 'package:quiver/time.dart';
import 'package:work_time_manager/domain/extensions/time_of_day_extensions.dart';

class MonthStatisticsController {}

class MonthStatisticsWidget extends StatefulWidget {
  const MonthStatisticsWidget(
      {super.key});

  @override
  State<MonthStatisticsWidget> createState() => _MonthStatisticsWidgetState();
}

class _MonthStatisticsWidgetState extends State<MonthStatisticsWidget> {
  Color color = Colors.blue;
  Text ost = const Text("Недоработка:   2:30",
      style: TextStyle(fontSize: 20, color: Colors.red));
  Text per = const Text("Переработка:   2:30",
      style: TextStyle(fontSize: 20, color: Colors.green));
  bool isOst = true;
  MonthStatistics? currentMonth;

  @override
  Widget build(BuildContext context) {
    MonthStatisticsProvider monthStatisticsProvider = Provider.of<MonthStatisticsProvider>(context);
    Text text = isOst ? ost : per;

    return FutureBuilder(future: () async {
      if (currentMonth == null) {
        return await monthStatisticsProvider.getMonth(DateTime.now().year, DateTime.now().month);
      } else {
        return currentMonth;
      }
    }.call(),
    builder: (ctx, value) {
      if (value.hasError) {
        return Text("Error occurred! (${value.error!.toString()})");
      }

      if (!value.hasData) {
        return const CircularProgressIndicator();
      }

      return ItemContainer(
          child: SizedBox(
            width: 800,
            height: 400,
            child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Text("Месечная статистика",
                        style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Align(
                        alignment: Alignment.topCenter,
                        child: getHistogram(value.data!)),
                    const Padding(padding: EdgeInsets.only(top: 25)),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 40)),
                        text,
                        const Padding(padding: EdgeInsets.only(left: 25)),
                        TextButton(
                            onPressed: () => setState(() {
                              isOst = !isOst;
                            }),
                            child: const Text(""))
                      ],
                    )
                  ],
                )),
          ));
    });
  }

  Widget getHistogram(MonthStatistics monthStatistics) {
    TimeOfDay value;

      return Container(
          width: 700,
          height: 250,
          child: Center(
              child: ConstrainedBox(
                  constraints:
                  const BoxConstraints.tightFor(width: 750, height: 300),
                  child: BarChart(BarChartData(
                      maxY: 10,
                      groupsSpace: 5,
                      barTouchData: BarTouchData(
                        touchCallback: (event, response) {
                          if (response != null && response.spot != null && event is FlPointerHoverEvent) {
                            setState(() {
                              final group = response.spot!.touchedBarGroup;
                              final rod = group.barRods[0];
                              if (rod.rodStackItems[0].toY.toInt() < 8) {
                                color = Colors.red.shade200;
                              } else {
                                if (rod.rodStackItems.length == 1) {
                                  color = Colors.blue.shade200;
                                } else {
                                  color = Colors.green.shade200;
                                }
                              }

                              if (rod.rodStackItems[0].toY.toInt() == 8) {
                                if (rod.rodStackItems.length == 1) {
                                  value = TimeOfDay(hour: 8, minute: minute);
                                } else {
                                  value = rod.rodStackItems[1].toY.toTimeOfDay();
                                }
                              } else {
                                value = rod.rodStackItems[0].toY.toTimeOfDay();
                              }
                            });
                          }
                        },
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: color,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                  value.toString(),
                                  const TextStyle(fontSize: 18));
                            },
                          )
                      ),
                      barGroups: getGroups(monthStatistics))))));
  }

  List<BarChartGroupData> getGroups(MonthStatistics month) {
    List<BarChartGroupData> result = [];
    int days = daysInMonth(month.year, month.month);
    int currentDay = 1;

    for (var day in month.statistics) {
      List<BarChartRodStackItem> items = [];
      if (day.workTime < day.amountTime) {
        items.add(BarChartRodStackItem(0, day.workTime.toDouble(), Colors.blue));
        items.add(BarChartRodStackItem(day.workTime.toDouble(), day.amountTime.toDouble(), Colors.red.shade200));
      } else if (day.workTime > day.amountTime) {
        items.add(BarChartRodStackItem(0, day.amountTime.toDouble(), Colors.blue));
        items.add(BarChartRodStackItem(day.amountTime.toDouble(), day.workTime.toDouble(), Colors.green.shade200));
      } else {
        items.add(BarChartRodStackItem(0, day.workTime.toDouble(), Colors.blue));
      }

      result.add(
        BarChartGroupData(x: currentDay, barRods: [
          BarChartRodData(toY: 10, color: Colors.transparent, rodStackItems: items)
        ])
      );

      currentDay++;
    }

    for (int i = currentDay; i <= days; i++) {
      result.add(BarChartGroupData(x: i));
    }

    return result;
  }
}
