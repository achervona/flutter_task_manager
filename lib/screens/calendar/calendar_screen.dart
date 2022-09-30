import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/repositories/tasks_repository.dart';
import 'package:flutter_test_app/screens/day/day_cubit.dart';
import 'package:flutter_test_app/screens/day/day_screen.dart';
import 'calendar_cubit.dart';
import 'calendar_state.dart';
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
            centerTitle: true,
            title: Text(_getMonthName(state.month) + ' ' + state.year.toString()),
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
            padding: const EdgeInsets.all(10.0),
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
            crossAxisCount: 7,
            children: [
              ...days.map((day) { 
                  return CalendarCell(
                    text: day,
                    textColor: Colors.purple.shade800,
                    color: Colors.white,
                    //border: true,
                  );
              }).toList(),
              ..._getDayCells(state.year, state.month, context)
            ]
          )
         );
      }
    );
  }

  List _getDayCells (int year, int month, context) {
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
            color: Colors.purple.shade200,
          ));
      }
    }

    for (int i = 1; i <= lastDateOfMonth.day; i++) {
      cells.add(
        CalendarCell(
          text: i.toString(),
          color: i == nowDate.day && month == nowDate.month && year == nowDate.year ? Colors.redAccent.shade400 : Colors.purple.shade800,
          onTap: () => _navigateToDayScreen(DateTime(year, month, i), context)
        ));
    }

    if (lastDateOfMonth.weekday != 7) {
      final int remainingDays = 7 - lastDateOfMonth.weekday;

      for (int i = 1; i <= remainingDays; i++) {
        cells.add(
          CalendarCell(
            text: i.toString(),
            color: Colors.purple.shade200,
          ));
      }
    }

    return cells;
  }

  void _navigateToDayScreen(DateTime date, BuildContext context) {
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

  String _getMonthName(int month) {
    final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month - 1];
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
