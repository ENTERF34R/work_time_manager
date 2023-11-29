import 'package:flutter/material.dart';

class TimeEditWidget extends StatefulWidget {
  final double width;
  final TextEditingController hourController;
  final TextEditingController minuteController;

  const TimeEditWidget(
      {super.key,
      required this.width,
      required this.hourController,
      required this.minuteController});

  @override
  State<TimeEditWidget> createState() => _TimeEditWidgetState();
}

//48-22-4
class _TimeEditWidgetState extends State<TimeEditWidget> {
  @override
  Widget build(BuildContext context) {
    //todo: Implement build
    throw UnimplementedError();
    /*
    return Container(
        width: 80,
        height: 80,
        decoration:
        BoxDecoration(border: Border.all(color: Colors.blue, width: 1)),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          // cursorHeight: 60,
          cursorColor: Colors.blue,
          style: const TextStyle(fontSize: 50, height: 1.3),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 10)),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(2)
          ],
        ));
     */
  }
}
