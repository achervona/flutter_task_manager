import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'models/task.dart';

class TasksApi {
  final String tableName = 'tasks';
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

 // final _tasksStreamController = BehaviorSubject<List<Task>>.seeded(const []);
 // static const kTasksCollectionKey = '__tasks_collection_key__';

  // String? _getValue(String key) => _plugin.getString(key);

  // Future<void> _setValue(String key, String value) => _plugin.setString(key, value);

  // void _init() {
  //   final tasksJson = _getValue(kTasksCollectionKey);
  //   if (tasksJson != null) {
  //     final tasks = List<Map<dynamic, dynamic>>.from(
  //       json.decode(tasksJson) as List,
  //     )
  //       .map((jsonMap) => Task.fromJson(Map<String, dynamic>.from(jsonMap)))
  //       .toList();
  //     _tasksStreamController.add(tasks);
  //   } else {
  //     _tasksStreamController.add(const []);
  //   }
  // }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'tasks_database.db'),
      onCreate: (Database db, int version) {
        return db.execute(
          'CREATE TABLE $tableName(id TEXT PRIMARY KEY, dateTime INTEGER, description TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<Task>> getTasks(DateTime startDate, DateTime? endDate) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      tableName, 
      where: 'dateTime >= ? ${endDate != null ? "AND dateTime < ?" : ""}', 
      whereArgs: [Task.dateTimeToJson(startDate), if (endDate != null) Task.dateTimeToJson(endDate)], 
      orderBy: 'dateTime'
    );

    final List<Task> tasks = List.generate(
      maps.length, 
      (index) => Task.fromJson(Map<String, dynamic>.from(maps[index]))
    );

    return tasks;
  }

  Future<int> addTask(Task task) async {
    final Database db = await database;

    return db.insert(
      tableName,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteTask(String id) async {
    final Database db = await database;

    return db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
