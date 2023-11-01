import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_time_manager/presentation/widgets/horizontal_bar.dart';
import 'package:work_time_manager/presentation/widgets/item_container.dart';

class DayStatistics extends StatefulWidget {
  final void Function(TimeOfDay) _savePressed;
  final ValueNotifier<bool> _saveNotifier;

  const DayStatistics(
      {super.key, required void Function(TimeOfDay) savePressed, required ValueNotifier<bool> saveNotifier})
      : _savePressed = savePressed, _saveNotifier = saveNotifier;

  @override
  State<DayStatistics> createState() => _DayStatisticsState();
}

class _DayStatisticsState extends State<DayStatistics> {
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();
  Text ost = const Text("Осталось:          2:30",
      style: TextStyle(fontSize: 20, color: Colors.red));
  Text per = const Text("Переработка:   2:30",
      style: TextStyle(fontSize: 20, color: Colors.green));
  bool isOst = true;
  bool isStateEdit = false;
  Color boxesColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    Text text = isOst ? ost : per;
    Row allRow = !isStateEdit
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Всего:                8:45",
                  style: TextStyle(fontSize: 20)),
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
                    HorizontalBarComponent(200, Colors.blue),
                    HorizontalBarComponent(70, Colors.red.withOpacity(0.3)),
                    HorizontalBarComponent(70, Colors.green.withOpacity(0.3))
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 3)),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Прошло:           5:30",
                        style: TextStyle(fontSize: 20, color: Colors.blue))),
                const Padding(padding: EdgeInsets.only(top: 3)),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        text,
                        const Padding(padding: EdgeInsets.only(left: 25)),
                        TextButton(
                            onPressed: () => setState(() {
                                  isOst = !isOst;
                                }),
                            child: const Text(""))
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
