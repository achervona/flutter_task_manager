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
        theme: ThemeData(
          primaryColor: Colors.purple.shade800,
          colorScheme: ColorScheme.light(
            primary: Colors.purple.shade800,
            secondary: Colors.purple.shade400
          ),
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.resolveWith<TextStyle?>((_) => const TextStyle(fontSize: 16.0)),
              padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>((_) => const EdgeInsets.all(16.0))
            ),
          )
        ),
        home: BlocProvider(
          create: (_) => CalendarCubit(tasksRepository: tasksRepository),
          child: const CalendarScreen()
        )
      )
    );
  }
}
