import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/day.dart';
import '../../repositories/tasks_repository.dart';
import '../../screens/day/day_cubit.dart';
import '../../screens/day/day_screen.dart';
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
  final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  final List<String> daysOfWeek = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];

  @override
  void initState() {
    super.initState();
    context.read<CalendarCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CalendarCubit, CalendarState>(
      listener: (BuildContext context, CalendarState state) {
        if (state.status == Status.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error occurred')
            )
          );
        }
      },
      builder: (_, CalendarState state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(months[state.month - 1] + ' ' + state.year.toString()),
            leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
                size: 24
              ),
              onPressed: () => context.read<CalendarCubit>().prevMonth(),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_right,
                  size: 24
                ),
                onPressed: () => context.read<CalendarCubit>().nextMonth(),
              )
            ],
          ),
          body: (state.status == Status.loading)
            ? const Center(child: CircularProgressIndicator())
              : (state.status == Status.success)
              ? GridView.count(
                primary: false,
                padding: const EdgeInsets.all(10.0),
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                crossAxisCount: daysOfWeek.length,
                children: [
                  ...daysOfWeek.map((String day) =>
                      CalendarCell(
                        text: day,
                        textColor: Colors.purple.shade800,
                        color: Colors.white,
                      )
                  ).toList(),
                  ...state.days.map((Day day) => 
                      CalendarCell(
                        text: day.date.day.toString(),
                        color: day.isToday ? Colors.redAccent.shade400 : !day.isActive ? Colors.purple.shade100 : null,
                        taskNumber: day.taskNumber,
                        onTap: () => _navigateToDayScreen(day.date),
                      )
                  ).toList(),
                ]
              )
              : const SizedBox.shrink()
        );
      }
    );
  }

  void _navigateToDayScreen(DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return BlocProvider(
            create: (BuildContext context) => DayCubit(tasksRepository: context.read<TasksRepository>()),
            child: DayScreen(date: date)
          );
        }
      )
    );
  }
}
