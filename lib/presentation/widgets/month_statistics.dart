import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:work_time_manager/domain/models/month_statistics.dart';
import 'package:work_time_manager/domain/providers/month_statistics_provider.dart';
import 'package:work_time_manager/presentation/widgets/item_container.dart';
import 'package:quiver/time.dart';
import 'package:work_time_manager/domain/extensions/time_of_day_extensions.dart';

import '../../domain/models/day_info.dart';

class MonthStatisticsController {}

class MonthStatisticsWidget extends StatefulWidget {
  const MonthStatisticsWidget({super.key});

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
  Text? divText;
  List<BarChartGroupData>? groups;
  String workTimeLabel = "";

  @override
  Widget build(BuildContext context) {
    MonthStatisticsProvider monthStatisticsProvider =
        Provider.of<MonthStatisticsProvider>(context);

    return FutureBuilder(
        future: () async {
          if (currentMonth == null) {
            return await monthStatisticsProvider.getMonth(
                DateTime.now().year, DateTime.now().month);
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

          groups ??= getGroups(value.data!);

          if (divText == null) {
            TimeOfDay divTime = MonthStatistics.getDiv(value.data!);
            if (divTime < const TimeOfDay(hour: 0, minute: 0)) {
              divText = Text("Недоработка:   ${divTime.hourToString()}:${divTime.minuteToString()}",
                  style: const TextStyle(fontSize: 20, color: Colors.red));
            } else {
              divText = Text("Переработка:  ${divTime.hourToString()}:${divTime.minuteToString()}",
                  style: const TextStyle(fontSize: 20, color: Colors.green));
            }
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
                        style:
                            TextStyle(fontSize: 20, color: Colors.blueAccent)),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    Text("${rusMonthName(value.data!.month)} ${value.data!.year}",
                        style:
                        const TextStyle(fontSize: 20, color: Colors.blueAccent)),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Align(
                        alignment: Alignment.topCenter,
                        child: getHistogram(value.data!, groups!)),
                    const Padding(padding: EdgeInsets.only(top: 25)),
                    Row(
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 40)),
                        divText!,
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

  Widget getHistogram(MonthStatistics monthStatistics, List<BarChartGroupData> groups) {

    return SizedBox(
        width: 750,
        height: 225,
        child: Center(
            child: ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 750, height: 300),
                child: BarChart(BarChartData(
                    maxY: 12,
                    groupsSpace: 5,
                    titlesData: FlTitlesData(bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => bottomTitles(monthStatistics, value, meta),
                      )
                    ), rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
                    barTouchData: BarTouchData(
                        touchCallback: (event, response) {
                          if (response != null &&
                              response.spot != null &&
                              event is FlPointerHoverEvent) {
                            final group = response.spot!.touchedBarGroup;
                            final day = group.x;
                            final dayData = monthStatistics.statistics
                                .where(
                                    (element) => element.arriveTime.day == day)
                                .firstOrNull;
                            if (dayData == null) {
                              monthStatistics.statistics.forEach((element) {
                                print("\t${element.arriveTime.day}");
                              });
                              return;
                            }

                            setState(() {
                                workTimeLabel =
                                  "${dayData.workTime.hourToString()}:${dayData.workTime.minuteToString()}";

                              if (dayData.workTime < dayData.amountTime) {
                                color = Colors.red.shade200;
                              } else if (dayData.workTime >
                                  dayData.amountTime) {
                                color = Colors.green.shade200;
                              } else {
                                color = Colors.blue.shade200;
                              }
                            });
                          }
                        },
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: color,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                                workTimeLabel, const TextStyle(fontSize: 18));
                          },
                        )),
                    barGroups: groups)))));
  }

  List<BarChartGroupData> getGroups(MonthStatistics month) {
    List<BarChartGroupData> result = [];
    int days = daysInMonth(month.year, month.month);

    for (int currentDay = 1; currentDay <= days; currentDay++) {
      DayInfo? day = month.statistics
          .where((d) => d.arriveTime.day == currentDay)
          .firstOrNull;
      if (day != null) {
        List<BarChartRodStackItem> items = [];
        if (day.workTime < day.amountTime) {
          items.add(
              BarChartRodStackItem(0, day.workTime.toDouble(), Colors.blue));
          items.add(BarChartRodStackItem(day.workTime.toDouble(),
              day.amountTime.toDouble(), Colors.red.shade200));
        } else if (day.workTime > day.amountTime) {
          items.add(
              BarChartRodStackItem(0, day.amountTime.toDouble(), Colors.blue));
          items.add(BarChartRodStackItem(day.amountTime.toDouble(),
              day.workTime.toDouble(), Colors.green.shade200));
        } else {
          items.add(
              BarChartRodStackItem(0, day.workTime.toDouble(), Colors.blue));
        }

        result.add(BarChartGroupData(x: currentDay,
            barRods: [
          BarChartRodData(
              toY: 10, color: Colors.transparent, rodStackItems: items)
        ]));
      } else {
        result.add(BarChartGroupData(x: currentDay));
      }
    }

    return result;
  }

  Widget bottomTitles(MonthStatistics monthStatistics, double value, TitleMeta meta) {
    DateTime day = DateTime(monthStatistics.year, monthStatistics.month, value.toInt());
    String dayOfTheWeek = DateFormat('EEEE').format(day);
    TextStyle style = const TextStyle(fontSize: 12);

    if (dayOfTheWeek == "Saturday" || dayOfTheWeek == "Sunday") {
      style = const TextStyle(color: Colors.red, fontSize: 12);
    }

    return Text(value.toInt().toString(), style: style);
  }

  String rusMonthName(int month) {
    switch(month) {
      case 1:
        return "Январь";
      case 2:
        return "Февраль";
      case 3:
        return "Март";
      case 4:
        return "Апрель";
      case 5:
        return "Май";
      case 6:
        return "Июнь";
      case 7:
        return "Июль";
      case 8:
        return "Август";
      case 9:
        return "Сентябрь";
      case 10:
        return "Октябрь";
      case 11:
        return "Ноябрь";
      case 12:
        return "Декабрь";
      default:
        return "";
    }
  }
}
