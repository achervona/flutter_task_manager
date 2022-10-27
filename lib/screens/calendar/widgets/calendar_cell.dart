import 'package:flutter/material.dart';

class CalendarCell extends StatelessWidget  {
  final String text;
  final Color? color;
  final Color? textColor;
  final int taskNumber;
  final void Function()? onTap;

  const CalendarCell({
    Key? key,
    required this.text,
    this.color,
    this.textColor,
    this.taskNumber = 0,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: color ?? Colors.purple.shade800,
            borderRadius: const BorderRadius.all(Radius.circular(4.0))
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              if (taskNumber != 0)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    alignment: Alignment.center,
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      taskNumber.toString(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                    ),
                  )
                ),
            ],
          )
        )
      );
  }
}
