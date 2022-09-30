import 'package:flutter_test_app/api/models/task.dart';
import 'package:flutter_test_app/api/tasks_api.dart';

class TasksRepository {
  const TasksRepository({
    required TasksApi tasksApi,
  }) : _tasksApi = tasksApi;

  final TasksApi _tasksApi;

  //Stream<List<Task>> getTasks() => _tasksApi.getTasks('dfgdf');
  Map getTaskCountsForMonth(int year, int month) => _tasksApi.getTaskCountsForMonth(year, month);

  List<Task> getTasks(DateTime date) => _tasksApi.getTasks(date);

  Future<void> addTask(Task task) => _tasksApi.addTask(task);

  Future<void> deleteTask(String id) => _tasksApi.deleteTask(id);
}
