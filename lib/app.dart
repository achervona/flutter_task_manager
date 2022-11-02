import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/tasks_repository.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/calendar/calendar_cubit.dart';
import 'theme.dart';

class TaskManagerApp extends StatelessWidget  {
  const TaskManagerApp({
    Key? key,
    required this.tasksRepository
  }) : super(key: key);

  final TasksRepository tasksRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: tasksRepository,
      child: MaterialApp(
        title: 'Task Manager',
        debugShowCheckedModeBanner: false,
        theme: appThemeData,
        home: BlocProvider(
          create: (_) => CalendarCubit(tasksRepository: tasksRepository),
          child: const CalendarScreen()
        )
      )
    );
  }
}
