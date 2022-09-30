import 'dart:async';
import 'dart:convert';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/task.dart';
import "package:collection/collection.dart";

class TasksApi {
  TasksApi({
    required SharedPreferences plugin,
  }) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;
  final _tasksStreamController = BehaviorSubject<List<Task>>.seeded(const []);
  static const kTasksCollectionKey = '__tasks_collection_key__';

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) => _plugin.setString(key, value);

  void _init() {
    final tasksJson = _getValue(kTasksCollectionKey);
    if (tasksJson != null) {
      final tasks = List<Map<dynamic, dynamic>>.from(
        json.decode(tasksJson) as List,
      )
        .map((jsonMap) => Task.fromJson(Map<String, dynamic>.from(jsonMap)))
        .toList();
      _tasksStreamController.add(tasks);
    } else {
      _tasksStreamController.add(const []);
    }
  }

  //Stream<List<Task>> getTasks(String time) => _tasksStreamController.asBroadcastStream().where((event) => false);

  Map getTaskCountsForMonth(int year, int month) {
    final monthTasks = [..._tasksStreamController.value].where((task) => task.dateTime.year == year && task.dateTime.month == month).toList();

    final Map releaseDateMap = groupBy(monthTasks, (Task task) => task.dateTime.day);
    

    releaseDateMap.forEach((key, value) {releaseDateMap[key] = releaseDateMap[key].length;});


    print(releaseDateMap);
    return releaseDateMap;
  }

  List<Task> getTasks(DateTime date) {
    return [..._tasksStreamController.value].where((task) => _isDateEqual(task.dateTime, date)).sortedBy((Task task) => task.dateTime).toList();
  }

  Future<void> addTask(Task task) {
    final tasks = [..._tasksStreamController.value];
    tasks.add(task);
    _tasksStreamController.add(tasks);
    return _setValue(kTasksCollectionKey, json.encode(tasks));
  }

  Future<void> deleteTask(String id) async {
    final tasks = [..._tasksStreamController.value];
    final taskIndex = tasks.indexWhere((t) => t.id == id);
    if (taskIndex != -1) {
      tasks.removeAt(taskIndex);
      _tasksStreamController.add(tasks);
      return _setValue(kTasksCollectionKey, json.encode(tasks));
    }
  }

  bool _isDateEqual(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year && firstDate.month == secondDate.month && firstDate.day == secondDate.day;
  }
}
