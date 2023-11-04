import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteWidget extends StatelessWidget {
  final DateTime _date;
  final String _note;
  final double _width;

  const NoteWidget({super.key, required DateTime date, required String note, required double width})
      : _date = date, _note = note, _width = width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black
        )
      ),
      child: Text("${DateFormat("yyyy.MM.dd").format(_date)} : $_note")
    );
  }
}