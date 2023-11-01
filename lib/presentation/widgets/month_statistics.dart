import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:work_time_manager/domain/models/month_statistics.dart';
import 'package:work_time_manager/presentation/widgets/item_container.dart';

class MonthStatisticsController {}

class MonthStatisticsWidget extends StatefulWidget {
  final MonthStatistics _monthStatistics;

  const MonthStatisticsWidget(
      {super.key, required MonthStatistics monthStatistics})
      : _monthStatistics = monthStatistics;

  @override
  State<MonthStatisticsWidget> createState() => _MonthStatisticsWidgetState();
}

class _MonthStatisticsWidgetState extends State<MonthStatisticsWidget> {
  Color color = Colors.blue;
  double value = 0.0;
  Text ost = const Text("Недоработка:   2:30",
      style: TextStyle(fontSize: 20, color: Colors.red));
  Text per = const Text("Переработка:   2:30",
      style: TextStyle(fontSize: 20, color: Colors.green));
  bool isOst = true;

  @override
  Widget build(BuildContext context) {
    Text text = isOst ? ost : per;

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
                  child: getHistogram(widget._monthStatistics)),
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
  }

  Widget getHistogram(MonthStatistics monthStatistics) {
      return Container(
          width: 700,
          height: 225,
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
                                  value = 8;
                                } else {
                                  value = rod.rodStackItems[1].toY;
                                }
                              } else {
                                value = rod.rodStackItems[0].toY;
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
                      barGroups: [
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(
                            borderRadius: BorderRadius.zero,
                            color: Colors.transparent,
                              toY: 10, rodStackItems: [
                            BarChartRodStackItem(0, 6, Colors.blue),
                            BarChartRodStackItem(6, 8, Colors.red.shade200)
                          ])
                        ]),
                        BarChartGroupData(
                            x: 2, barRods: [
                          BarChartRodData(
                              borderRadius: BorderRadius.zero,
                              color: Colors.transparent,
                          toY: 10, rodStackItems: [
                            BarChartRodStackItem(0, 8, Colors.blue),
                            BarChartRodStackItem(8, 9.31, Colors.green.shade200)
                          ])
                        ]),
                        BarChartGroupData(x: 3, barRods: [
                          BarChartRodData(
                              borderRadius: BorderRadius.zero,
                              color: Colors.transparent,
                              toY: 10, rodStackItems: [
                            BarChartRodStackItem(0, 8, Colors.blue),
                          ])
                        ])
                      ])))));
  }
  /*
  BarChartGroupData getBarChartGroupData(DayData data) {

  }
  */
}
