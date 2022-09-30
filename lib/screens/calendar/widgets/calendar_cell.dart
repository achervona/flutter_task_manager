import 'package:flutter/material.dart';

class CalendarCell extends StatelessWidget  {
  final String text;
  final Color? color;
  final Color? textColor;
  final bool border;
  final void Function()? onTap;

  const CalendarCell({
    Key? key,
    required this.text,
    this.color,
    this.textColor,
    this.border = false,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.purple.shade200,
      child: Container(
          padding: const EdgeInsets.all(4.0),
          //color: color ?? Colors.purple.shade800,
          decoration: BoxDecoration(
            color: color ?? Colors.purple.shade800,
            border: border ? Border.all(color: Colors.purple.shade800, width: 2.0) : null,
            borderRadius: const BorderRadius.all(Radius.circular(4.0))
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
              ),
            ),
          )
        )
      );
  }
}