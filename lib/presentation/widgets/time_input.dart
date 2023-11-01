import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_time_manager/presentation/widgets/item_container.dart';

class TimeInput extends StatefulWidget {
  final void Function(int hour, int minute) _savePressed;
  final ValueNotifier<bool> _saveNotifier;

  const TimeInput({super.key, required void Function(int hour, int minute) savePressed, required ValueNotifier<bool> saveNotifier})
      : _savePressed = savePressed, _saveNotifier = saveNotifier;

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  String errText = "";
  TextEditingController hourController = TextEditingController();
  TextEditingController minuteController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return ItemContainer(child: Container(
      width: 250,
      height: 200,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Text("Время прихода", style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
          const Padding(padding: EdgeInsets.only(top: 11)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getTimeInput(hourController),
              const Text(":", style: TextStyle(fontSize: 60)),
              getTimeInput(minuteController)
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 5)),
          // const Text("Введите верное время", style: TextStyle(color: Colors.red, fontSize: 12)),
          Text(errText, style: const TextStyle(color: Colors.red, fontSize: 12)),
          Align(
            alignment: Alignment.centerRight,
            child: ValueListenableBuilder(
              valueListenable: widget._saveNotifier,
              builder: (ctx, value, _) {
                if (value) {
                  return TextButton(
                      onPressed: null,
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.deepPurpleAccent.withOpacity(0.1))),
                      child: const Text("OK", style: TextStyle(fontSize: 20, color: Colors.grey))
                  );
                } else {
                  return TextButton(
                      onPressed: () {
                        if (hourController.text.isEmpty || minuteController.text.isEmpty) {
                          setState(() {
                            errText = "Введите верное время";
                          });
                          return;
                        }

                        int? hour = int.tryParse(hourController.text);
                        int? minute = int.tryParse(minuteController.text);
                        if (hour == null || minute == null || hour > 23 || minute > 59) {
                          setState(() {
                            errText = "Введите верное время";
                          });
                          return;
                        }

                        setState(() {
                          errText = "";
                          widget._savePressed.call(hour, minute);
                        });
                      },
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.deepPurpleAccent.withOpacity(0.1))),
                      child: const Text("OK", style: TextStyle(fontSize: 20, color: Colors.blueAccent))
                  );
                }
              }
            )
          )
        ],
      )
    ));
  }

  Widget getTimeInput(TextEditingController controller) {
    return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.blue,
                width: 1
            )
        ),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          // cursorHeight: 60,
          cursorColor: Colors.blue,
          style: const TextStyle(fontSize: 50, height: 1.3),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 10)
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2)
          ],
        )
    );
  }
}
