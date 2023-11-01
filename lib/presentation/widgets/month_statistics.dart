import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:work_time_manager/presentation/widgets/item_container.dart';

class MonthStatisticsController {}

class MonthStatistics extends StatefulWidget {
  const MonthStatistics({super.key});

  @override
  State<MonthStatistics> createState() => _MonthStatisticsState();
}

class _MonthStatisticsState extends State<MonthStatistics> {
  late int showingTooltip = -1;
  Text ost = const Text("Недоработка:   2:30",
      style: TextStyle(fontSize: 20, color: Colors.red));
  Text per = const Text("Переработка:   2:30",
      style: TextStyle(fontSize: 20, color: Colors.green));
  bool isOst = true;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

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
                  child: getHistogram(showingTooltip)),
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

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 11, color: Colors.black);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: DefaultTextStyle(
        style: style,
        child: Text(value.toInt().toString()),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value > 10) {
      return Container();
    }
    const style = TextStyle(fontSize: 16, color: Colors.black);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: DefaultTextStyle(style: style, child: Text(meta.formattedValue)),
    );
  }

  Widget getHistogram(int showingTooltip) {
    return Container(
        width: 735,
        height: 225,
        child: Center(
            child: ConstrainedBox(
                constraints:
                    const BoxConstraints.tightFor(width: 750, height: 300),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.center,
                    maxY: 10.1,
                    barTouchData: BarTouchData(
                        enabled: true,
                        handleBuiltInTouches: false,
                        touchCallback: (event, response) {
                          if (response != null &&
                              response.spot != null &&
                              event is FlTapUpEvent) {
                            setState(() {
                              final x = response.spot!.touchedBarGroup.x;
                              final isShowing = showingTooltip == x;
                              if (isShowing) {
                                showingTooltip = -1;
                              } else {
                                showingTooltip = x;
                              }
                            });
                          }
                        }),
                    titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 6,
                            //reservedSize: 150,
                            getTitlesWidget: bottomTitles,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            interval: 2,
                            getTitlesWidget: leftTitles,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false))),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 2,
                      checkToShowHorizontalLine: (value) => true,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: Colors.black.withOpacity(0.25),
                        strokeWidth: 1,
                      ),
                      drawVerticalLine: false,
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    groupsSpace: 5,
                    barGroups: getData(16, 0, showingTooltip),
                  ),
                ))));
  }

  List<BarChartGroupData> getData(
      double barsWidth, double barsSpace, int showingTooltip) {
    List<BarChartGroupData> barRodGroups = [];
    Random rand = Random();

    for (int i = 1; i <= 31; i++) {
      int hours = rand.nextInt(8);

      barRodGroups.add(BarChartGroupData(
          x: i,
          barsSpace: barsSpace,
          showingTooltipIndicators: showingTooltip == i ? [0] : [],
          barRods: [
            BarChartRodData(
                toY: 10,
                color: Colors.transparent,
                rodStackItems: [
                  BarChartRodStackItem(0, hours.floorToDouble(), Colors.blue),
                  BarChartRodStackItem(
                      hours.floorToDouble(), 8, Colors.red.withOpacity(0.25)),
                ],
                width: barsWidth,
                borderRadius: BorderRadius.circular(3))
          ]));
    }

    int hours = 10;
    barRodGroups.add(BarChartGroupData(x: 31, barsSpace: barsSpace, barRods: [
      BarChartRodData(
          toY: 10,
          color: Colors.transparent,
          rodStackItems: [
            BarChartRodStackItem(0, 8, Colors.blue),
            BarChartRodStackItem(
                8, hours.floorToDouble(), Colors.green.withOpacity(0.25)),
          ],
          width: barsWidth,
          borderRadius: BorderRadius.circular(3))
    ]));

    return barRodGroups;
  }
}
