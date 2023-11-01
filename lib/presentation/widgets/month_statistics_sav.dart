import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthStatistics extends StatefulWidget {
  const MonthStatistics({Key? key}) : super(key: key);

  @override
  State<MonthStatistics> createState() => _MonthStatisticsState();
}

class _MonthStatisticsState extends State<MonthStatistics> {
  late int showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      //showingTooltipIndicators: showingTooltip == x ? [0] : [],
      barRods: [
        BarChartRodData(toY: y.toDouble(),
        rodStackItems: [
          BarChartRodStackItem(0, y.toDouble() - 2, Colors.blue),
          BarChartRodStackItem(y.toDouble() - 2, y.toDouble(), Colors.red)
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                barGroups: [
                  generateGroupData(1, 10),
                  generateGroupData(2, 18),
                  generateGroupData(3, 4),
                  generateGroupData(4, 11),
                ],
                barTouchData: BarTouchData(
                    enabled: true,
                    handleBuiltInTouches: false,
                    touchCallback: (event, response) {
                      if (response != null && response.spot != null && event is FlTapUpEvent) {
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
                    },
                    mouseCursorResolver: (event, response) {
                      return response == null || response.spot == null
                          ? MouseCursor.defer
                          : SystemMouseCursors.click;
                    }
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}