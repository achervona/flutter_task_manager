import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/task.dart';
import '../../api/models/day.dart';
import '../../repositories/tasks_repository.dart';
import '../../screens/day/day_cubit.dart';
import '../../screens/day/day_screen.dart';
import '../../theme.dart';
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
        if (state.status == CalendarStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error occurred')
            )
          );
        }
      },
      builder: (_, CalendarState state) {
        return Scaffold(
          backgroundColor: AppConstants.primaryColor,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text(months[state.month - 1] + ' ' + state.year.toString()),
            leading: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_left,
                size: 24
              ),
              splashRadius: 24,
              onPressed: () => context.read<CalendarCubit>().goToPrevMonth(),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.keyboard_arrow_right,
                  size: 24
                ),
                splashRadius: 24,
                onPressed: () => context.read<CalendarCubit>().goToNextMonth(),
              )
            ],
          ),
          body: (state.status == CalendarStatus.loading)
            ? const Center(child: CircularProgressIndicator())
              : (state.status == CalendarStatus.success)
              ? GridView.count(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10.0),
                crossAxisCount: 7,
                children: [
                  ...daysOfWeek.map((String day) =>
                    CalendarCell(
                      text: day,
                      textColor: AppConstants.bodyTextColor
                    )
                  ).toList(),
                  ...state.days.map((Day day) => 
                    CalendarCell(
                      text: day.date.day.toString(),
                      color: day.isToday ? AppConstants.secondaryColor : null,
                      textColor: day.isActive || day.isToday ? AppConstants.bodyTextColor : AppConstants.bodyTextColor.withOpacity(0.5),
                      taskNumber: day.tasks.length,
                      onTap: () => _navigateToDayScreen(day)
                    )
                  ).toList(),
                ]
              )
              : const SizedBox.shrink()
        );
      }
    );
  }

  void _navigateToDayScreen(Day day) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return BlocProvider(
            create: (BuildContext context) => DayCubit(
              tasksRepository: context.read<TasksRepository>()
            ),
            child: DayScreen(
              date: day.date,
              tasks: day.tasks,
              onTaskListUpdate: updateDayTasks
            )
          );
        }
      )
    );
  }

  void updateDayTasks(DateTime date, List<Task> tasks) {
    context.read<CalendarCubit>().updateDayTasks(date, tasks);
  }
}
