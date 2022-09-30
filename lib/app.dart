import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/screens/calendar/calendar_screen.dart';
import 'repositories/tasks_repository.dart';
import 'screens/calendar/calendar_cubit.dart';

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
          // theme: ThemeData(
          //   primaryColor: const Color.fromRGBO(109, 234, 255, 1),
          //   colorScheme: const ColorScheme.light(
          //     secondary: Color.fromRGBO(72, 74, 126, 1),
          //   ),
          // ),
          home: BlocProvider(
            create: (BuildContext context) => CalendarCubit(tasksRepository: tasksRepository),
            child: CalendarScreen()
          )
        )
    );
  }
}