import 'dart:async';
import 'package:flutter/widgets.dart';
import 'repositories/tasks_repository.dart';
import 'api/tasks_api.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final TasksApi tasksApi = TasksApi();
  final TasksRepository tasksRepository = TasksRepository(
    tasksApi: tasksApi
  );
  
  runApp(
    TaskManagerApp(
      tasksRepository: tasksRepository
    )
  );
}
