import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class TasksApi {
  final String _tableName = 'tasks';
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'tasks_database.db'),
      onCreate: (Database db, int version) {
        return db.execute(
          'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, dateTime INTEGER, description TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<List<Task>> getTasks(DateTime startDate, DateTime endDate) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName, 
      where: 'dateTime >= ? AND dateTime < ?', 
      whereArgs: [Task.dateTimeToJson(startDate), Task.dateTimeToJson(endDate)], 
      orderBy: 'dateTime'
    );

    final List<Task> tasks = List<Task>.generate(
      maps.length, 
      (index) => Task.fromJson(Map<String, dynamic>.from(maps[index]))
    );

    return tasks;
  }

  Future<int> addTask(Task task) async {
    final Database db = await database;

    return db.insert(
      _tableName,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteTask(String id) async {
    final Database db = await database;

    return db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
