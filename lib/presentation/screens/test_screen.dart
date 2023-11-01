import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int showingTooltip;

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: showingTooltip == x ? [0] : [],
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
                maxY: 20,
                barGroups: [
                  generateGroupData(31, 10),
                  generateGroupData(2, 18),
                  generateGroupData(3, 4),
                  generateGroupData(4, 11),
                  generateGroupData(5, 11),
                  generateGroupData(6, 11),
                  generateGroupData(7, 11),
                  generateGroupData(8, 11),
                  generateGroupData(9, 11),
                  generateGroupData(10, 11),
                  generateGroupData(11, 11),
                  generateGroupData(12, 10),
                  generateGroupData(13, 18),
                  generateGroupData(14, 4),
                  generateGroupData(15, 11),
                  generateGroupData(16, 11),
                  generateGroupData(17, 11),
                  generateGroupData(18, 11),
                  generateGroupData(19, 11),
                  generateGroupData(20, 11),
                  generateGroupData(21, 11),
                  generateGroupData(22, 11),
                  generateGroupData(23, 10),
                  generateGroupData(24, 18),
                  generateGroupData(25, 4),
                  generateGroupData(26, 11),
                  generateGroupData(27, 11),
                  generateGroupData(28, 11),
                  generateGroupData(29, 11),
                  generateGroupData(30, 11),
                  generateGroupData(31, 11),
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