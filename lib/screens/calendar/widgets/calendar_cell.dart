import 'package:flutter/material.dart';
import '../../../theme.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({
    Key? key,
    required this.text,
    this.color,
    this.textColor,
    this.taskNumber = 0,
    this.onTap
  }) : super(key: key);

  final String text;
  final Color? color;
  final Color? textColor;
  final int taskNumber;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: AppThemeConstants.bodyFontSize,
                ),
              ),
            ),
            if (taskNumber != 0)
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: Container(
                  alignment: Alignment.center,
                  width: 18.0,
                  height: 18.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    taskNumber.toString(),
                    style: TextStyle(
                      fontSize: 10.0,
                      color: AppThemeConstants.primaryColor,
                    ),
                  ),
                )
              )
          ],
        )
      )
    );
  }
}
