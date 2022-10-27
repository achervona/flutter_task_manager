import '../api/models/task.dart';
import '../api/tasks_api.dart';

class TasksRepository {
  const TasksRepository({
    required TasksApi tasksApi,
  }) : _tasksApi = tasksApi;

  final TasksApi _tasksApi;

  Future<List<Task>> getTasks(DateTime startDate, DateTime? endDate) => _tasksApi.getTasks(startDate, endDate);

  Future<void> addTask(Task task) => _tasksApi.addTask(task);

  Future<void> deleteTask(String id) => _tasksApi.deleteTask(id);
}
