import 'package:flutter/material.dart';

class CalendarCell extends StatelessWidget  {
  final String text;
  final Color? color;
  final void Function()? onTap;

  const CalendarCell({
    Key? key,
    required this.text,
    this.color,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 32,
          width: 32,
          color: color ?? Colors.blue,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          )
        )
      );
  }
}