import 'package:flutter/widgets.dart';
import 'package:flutter_test_app/repositories/tasks_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/tasks_api.dart';
import 'app.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();

  final TasksApi tasksApi = TasksApi(
    plugin: await SharedPreferences.getInstance(),
  );

  final tasksRepository = TasksRepository(tasksApi: tasksApi);
  
  runApp(TaskManagerApp(tasksRepository: tasksRepository));
}