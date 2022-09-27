import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/screens/calendar/widgets/calendar_cell_widget.dart';
import 'package:flutter_test_app/screens/day/day_cubit.dart';
import 'package:flutter_test_app/screens/day/day_screen.dart';

import 'calendar_cubit.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    Key? key,
  }) : super(key: key);


  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final List<String> days = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];

 @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, DateTime>(
        builder: (BuildContext context, DateTime state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.year.toString() + ' ' + state.month.toString()),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 24
              ),
              onPressed: () => context.read<CalendarCubit>().prevMonth(),
            ),
            actions: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 24
              ),
              onPressed: () => context.read<CalendarCubit>().nextMonth(),
            )],
          ),
          body: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 7,
            children: [
              ...days.map((day) { 
                  return CalendarCell(
                    text: day,
                    color: Colors.blueAccent,
                  );
              }).toList(),
              ...getDayCells(state, context)
            ]
          )
         );
      }
    );
  }

  List getDayCells (date, context) {
    final int firstWeekdayOfMonth = DateTime(date.year, date.month, 1).weekday;
    final DateTime lastDateOfMonth = DateTime(date.year, date.month + 1, 0);
    final DateTime nowDate = DateTime.now();
    final List cells = [];

    if (firstWeekdayOfMonth != 1) {
      int lastDayOfPrevMonth = DateTime(date.year, date.month, 0).day;

      for (int i = firstWeekdayOfMonth - 1; i >= 1; i--) {
        cells.add(
          CalendarCell(
            text: (lastDayOfPrevMonth - i + 1).toString(),
            color: Colors.grey
          ));
      }
    }

    for (int i = 1; i <= lastDateOfMonth.day; i++) {
      cells.add(
        CalendarCell(
          text: i.toString(),
          color: i == nowDate.day && date.month == nowDate.month && date.year == nowDate.year ? Colors.greenAccent : Colors.red,
          onTap: () => navigateToDayScreen(DateTime(date.year, date.month, i), context)
        ));
    }

    if (lastDateOfMonth.weekday != 7) {
      final int remainingDays = 7 - lastDateOfMonth.weekday;

      for (int i = 1; i <= remainingDays; i++) {
        cells.add(
          CalendarCell(
            text: i.toString(),
            color: Colors.grey,
          ));
      }
    }

    return cells;
  }

  void navigateToDayScreen(date, context) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return BlocProvider(
                  create: (_) => DayCubit(),
                  child: DayScreen(date: date),
                );
                })
            );
  }

  @override
  void dispose() {
    context.read<CalendarCubit>().close();
    super.dispose();
  }
}
