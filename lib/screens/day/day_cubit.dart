import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test_app/api/models/task.dart';
import 'package:flutter_test_app/repositories/tasks_repository.dart';

class DayCubit extends Cubit<DayState> {
  DayCubit({
    required TasksRepository tasksRepository,
  }) : _tasksRepository = tasksRepository, super(const DayState());

  final TasksRepository _tasksRepository;

  void getTasks() {
    final tasks = _tasksRepository.getTasks();
    emit(DayState(tasks: tasks));
  }

  Future<void> deleteTask(String id) async {
    await _tasksRepository.deleteTask(id);
    final tasks = [...state.tasks];
    tasks.removeWhere((task) => task.id == id);
    emit(DayState(tasks: tasks));
  }

  Future<void> addTask(Task task) async {
    await _tasksRepository.addTask(task);
    final tasks = [...state.tasks];
    tasks.add(task);
    emit(DayState(tasks: tasks));
  }
}

enum Status { initial, loading, loaded, error }

class DayState extends Equatable {
  const DayState({
    this.tasks = const <Task>[],
  });

  final List<Task> tasks;

  @override
  List<Object?> get props => [tasks];
}