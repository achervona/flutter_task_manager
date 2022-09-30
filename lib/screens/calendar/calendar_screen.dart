import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/repositories/tasks_repository.dart';
import 'package:flutter_test_app/screens/day/day_cubit.dart';
import 'package:flutter_test_app/screens/day/day_screen.dart';
import 'calendar_cubit.dart';
import 'widgets/calendar_cell.dart';

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
  void initState() {
    super.initState();
    //context.read<CalendarCubit>().getTaskCountsForMonth(2022, 9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (BuildContext context, CalendarState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.year.toString() + ' ' + state.month.toString()),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_left,
                size: 24
              ),
              onPressed: () => context.read<CalendarCubit>().prevMonth(),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_right,
                  size: 24
                ),
                onPressed: () => context.read<CalendarCubit>().nextMonth(),
              )
            ],
          ),
          body: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            crossAxisCount: 7,
            children: [
              ...days.map((day) { 
                  return CalendarCell(
                    text: day,
                    color: Colors.blueAccent,
                  );
              }).toList(),
              ...getDayCells(state.year, state.month, context)
            ]
          )
         );
      }
    );
  }

  List getDayCells (int year, int month, context) {
    final int firstWeekdayOfMonth = DateTime(year, month, 1).weekday;
    final DateTime lastDateOfMonth = DateTime(year, month + 1, 0);
    final DateTime nowDate = DateTime.now();
    final List cells = [];

    if (firstWeekdayOfMonth != 1) {
      int lastDayOfPrevMonth = DateTime(year, month, 0).day;

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
          color: i == nowDate.day && month == nowDate.month && year == nowDate.year ? Colors.greenAccent : Colors.red,
          onTap: () => navigateToDayScreen(DateTime(year, month, i), context)
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

  void navigateToDayScreen(DateTime date, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return BlocProvider(
          create: (BuildContext context) => DayCubit(tasksRepository: context.read<TasksRepository>()),
          child: DayScreen(date: date)
        );
      })
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
