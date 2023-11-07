import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:work_time_manager/domain/extensions/time_of_day_extensions.dart';
import 'package:work_time_manager/domain/models/current_day_info.dart';
import 'package:work_time_manager/domain/providers/current_day_provider.dart';
import 'package:work_time_manager/presentation/widgets/horizontal_bar.dart';
import 'package:work_time_manager/presentation/widgets/item_container.dart';

class DayStatistics extends StatefulWidget {
  static const _barMaxLength = 340;
  static const _barMinuteLength = 270 / (8 * 60 + 45);
  final void Function(TimeOfDay) _savePressed;
  final ValueNotifier<bool> _saveNotifier;
  final CurrentDayInfo _currentDayInfo;

  const DayStatistics(
      {super.key, required void Function(TimeOfDay) savePressed, required ValueNotifier<bool> saveNotifier, required CurrentDayInfo currentDayInfo})
      : _savePressed = savePressed, _saveNotifier = saveNotifier, _currentDayInfo = currentDayInfo;

  @override
  State<DayStatistics> createState() => _DayStatisticsState();
}

class _DayStatisticsState extends State<DayStatistics> {
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();
  bool isOst = true;
  bool isStateEdit = false;
  Color boxesColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    Provider.of<CurrentDayProvider>(context);
    hourController.text = widget._currentDayInfo.amountTime.hourToString();
    minuteController.text = widget._currentDayInfo.amountTime.minuteToString();

    Text divText;
    double allWorkLen = DayStatistics._barMinuteLength * widget._currentDayInfo.amountTime.hour * 60 + widget._currentDayInfo.amountTime.minute;
    double workLineLen, leftLineLen, overLineLen;
    TimeOfDay div = widget._currentDayInfo.amountTime.subtract(widget._currentDayInfo.workTime);
    if (div < const TimeOfDay(hour: 0, minute: 0)) {
      divText = Text("Переработка:    ${div.hourToString()}:${div.minuteToString()}",
          style: const TextStyle(fontSize: 20, color: Colors.green));
    } else {
      divText = Text("Осталось:            ${div.hourToString()}:${div.minuteToString()}",
          style: const TextStyle(fontSize: 20, color: Colors.red));
    }

    if (div == const TimeOfDay(hour: 0, minute: 0)) {
      workLineLen = allWorkLen;
      leftLineLen = 0;
      overLineLen = 0;
    } else if (div > const TimeOfDay(hour: 0, minute: 0)) {
      print("${div.toString()} > ${const TimeOfDay(hour: 0, minute: 0)}");
      workLineLen = allWorkLen * (widget._currentDayInfo.workTime / widget._currentDayInfo.amountTime);
      leftLineLen = allWorkLen - workLineLen;
      overLineLen = 0;
    } else {
      print("${div.toString()} < ${const TimeOfDay(hour: 0, minute: 0)}");
      workLineLen = allWorkLen;
      overLineLen = ((widget._currentDayInfo.workTime / widget._currentDayInfo.amountTime) - 1) * allWorkLen;
      if (workLineLen + overLineLen > DayStatistics._barMaxLength) {
        overLineLen = DayStatistics._barMaxLength - workLineLen;
      }
      leftLineLen = 0;
    }

    Row allRow = !isStateEdit
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Всего:                   ${widget._currentDayInfo.amountTime.hourToString()}:${widget._currentDayInfo.amountTime.minuteToString()}",
                  style: const TextStyle(fontSize: 20)),
              Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          isStateEdit = true;
                        });
                      },
                      icon: const Icon(Icons.settings, color: Colors.blue))),
            ],
          )
        : Row(
            children: [
              const Text("Всего:", style: TextStyle(fontSize: 20)),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 45)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getTimeInput(hourController, boxesColor),
                  const Text(":", style: TextStyle(fontSize: 24)),
                  getTimeInput(minuteController, boxesColor)
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isStateEdit = false;
                    });
                  },
                  child: const Text("Отмена", style: TextStyle(fontSize: 14))),
              ValueListenableBuilder(
                  valueListenable: widget._saveNotifier,
                  builder: (ctx, value, _) {
                    if (value) {
                      return const TextButton(
                          onPressed: null,
                          child: Text("Ок",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)));
                    } else {
                      return TextButton(
                          onPressed: () {
                            int? hour = int.tryParse(hourController.text);
                            int? minute = int.tryParse(minuteController.text);

                            if (hour == null || minute == null || hour > 23 || minute > 59) {
                              setState(() {
                                boxesColor = Colors.red;
                              });
                            } else {
                              setState(() {
                                isStateEdit = false;
                                boxesColor = Colors.black;
                              });
                              widget._savePressed(TimeOfDay(hour: hour, minute: minute));
                            }
                          },
                          child:
                              const Text("Ок", style: TextStyle(fontSize: 14, color: Colors.blue)));
                    }
                  })
            ],
          );

    return ItemContainer(
        child: Container(
            width: 400,
            height: 200,
            padding: const EdgeInsets.only(top: 10, left: 30),
            child: Column(
              children: [
                const Text("Дневная статистика",
                    style: TextStyle(fontSize: 22, color: Colors.blueAccent)),
                const Padding(padding: EdgeInsets.only(top: 10)),
                HorizontalBar(
                  height: 30,
                  components: [
                    HorizontalBarComponent(workLineLen, Colors.blue),
                    HorizontalBarComponent(leftLineLen, Colors.red.withOpacity(0.3)),
                    HorizontalBarComponent(overLineLen, Colors.green.withOpacity(0.3))
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 3)),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Прошло:              ${widget._currentDayInfo.workTime.hourToString()}:${widget._currentDayInfo.workTime.minuteToString()}",
                        style: const TextStyle(fontSize: 20, color: Colors.blue))),
                const Padding(padding: EdgeInsets.only(top: 3)),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        divText,
                        const Padding(padding: EdgeInsets.only(left: 25)),
                      ],
                    )),
                const Padding(padding: EdgeInsets.only(top: 3)),
                allRow
              ],
            )));
  }

  Widget getTimeInput(TextEditingController controller, Color boxesColor) {
    return Container(
        width: 32,
        height: 34,
        decoration:
            BoxDecoration(border: Border.all(color: boxesColor, width: 1)),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          // cursorHeight: 60,
          cursorColor: Colors.black,
          style: const TextStyle(fontSize: 20, height: 1.3),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(bottom: 18, left: 2)),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2)
          ],
        ));
  }
}
