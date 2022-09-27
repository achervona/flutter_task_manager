import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/screens/calendar/calendar_cubit.dart';
import 'package:flutter_test_app/screens/calendar/calendar_screen.dart';

class TaskManagerApp extends StatelessWidget  {
  const TaskManagerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      // theme: ThemeData(
      //   primaryColor: const Color.fromRGBO(109, 234, 255, 1),
      //   colorScheme: const ColorScheme.light(
      //     secondary: Color.fromRGBO(72, 74, 126, 1),
      //   ),
      // ),
      home: BlocProvider(
        create: (_) => CalendarCubit(),
        child: const CalendarScreen(),
      )
    );
  }
}