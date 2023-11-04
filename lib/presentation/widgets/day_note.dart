import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_time_manager/domain/models/current_day_info.dart';
import 'package:work_time_manager/presentation/widgets/item_container.dart';

class DayNote extends StatefulWidget {
  final void Function(String) _savePressed;
  final ValueNotifier<bool> _saveNotifier;
  final CurrentDayInfo _currentDayInfo;

  const DayNote({super.key, required void Function(String) savePressed, required ValueNotifier<bool> saveNotifier, required CurrentDayInfo currentDayInfo})
      : _savePressed = savePressed, _saveNotifier = saveNotifier, _currentDayInfo = currentDayInfo;

  @override
  State<DayNote> createState() => _DayNoteState();
}

class _DayNoteState extends State<DayNote> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.text = widget._currentDayInfo.note;

    return ItemContainer(
        child: Container(
            width: 250,
            height: 400,
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 15),
            child: Column(
              children: [
                const Text("Заметка дня", style: TextStyle(fontSize: 22, color: Colors.blueAccent)),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(fontSize: 16),
                    cursorColor: Colors.blue,
                    maxLines: 10,
                      maxLength: 140,
                      maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                      expands: false,

                      decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2
                      )
                    ),
                    hintText: 'Введите заметку',
                  )),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ValueListenableBuilder(
                    valueListenable: widget._saveNotifier,
                    builder: (ctx, value, _) {
                      if (value) {
                        return TextButton(
                            onPressed: null,
                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.deepPurpleAccent.withOpacity(0.1))),
                            child: const Text("Сохранить", style: TextStyle(fontSize: 20, color: Colors.grey))
                        );
                      } else {
                        return TextButton(
                            onPressed: () => widget._savePressed(controller.text),
                            style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.deepPurpleAccent.withOpacity(0.1))),
                            child: const Text("Сохранить", style: TextStyle(fontSize: 20, color: Colors.blueAccent))
                        );
                      }
                    }
                  )
                )
              ],
            )));
  }
}
