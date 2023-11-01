import 'package:flutter/material.dart';

class ItemContainer extends StatelessWidget {
  final Widget _child;
  //final double _width;
  //final double _height;

  const ItemContainer({super.key, required Widget child})//, required double width, required double height})
      // : _child = child, _width = width, _height = height;
      : _child = child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow:  [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 4,
            offset: const Offset(2,4)
          )
        ]
      ),
      child: _child,
    );
  }
}