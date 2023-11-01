import 'package:flutter/material.dart';

class HorizontalBarComponent {
  final double width;
  final Color color;

  HorizontalBarComponent(this.width, this.color);
}

class HorizontalBar extends StatelessWidget {
  final double _height;
  final List<HorizontalBarComponent> _components;

  const HorizontalBar({super.key, required double height, required List<HorizontalBarComponent> components})
    : _height = height, _components = components;

  @override
  Widget build(BuildContext context) {
    List<Widget> bars = [];

    _components.forEach((element) {
      bars.add(
        SizedBox(
          height: _height,
          width: element.width,
          child: ColoredBox(
            color: element.color
          )
        )
      );
    });

    return Row(children: bars);
  }
}