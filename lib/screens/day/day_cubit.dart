import 'package:bloc/bloc.dart';
import 'package:flutter_test_app/api/models/task.dart';
import 'package:flutter_test_app/repositories/tasks_repository.dart';
import 'day_state.dart';

class DayCubit extends Cubit<DayState> {
  DayCubit({
    required TasksRepository tasksRepository,
  }) : _tasksRepository = tasksRepository, super(const DayState());

  final TasksRepository _tasksRepository;

  void getTasks(DateTime date) {
    emit(
      const DayState(
        status: Status.loading
      )
    );

    try {
      final tasks = _tasksRepository.getTasks(date);
      emit(
        DayState(
          tasks: tasks,
          status: Status.success
        )
      );
    } catch (error) {
      emit(
        const DayState(
          status: Status.error
        )
      );
    }
  }

  Future<void> deleteTask(String id) async {
    final tasks = [...state.tasks];

    try {
      await _tasksRepository.deleteTask(id);
      tasks.removeWhere((task) => task.id == id);
      emit(
        DayState(
          tasks: tasks,
          status: Status.success
        )
      );
    } catch (error) {
      emit(
        DayState(
          tasks: tasks,
          status: Status.error
        )
      );
    }
  }

  Future<void> addTask(Task task) async {
    await _tasksRepository.addTask(task);
    final tasks = [...state.tasks, task];
    tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    emit(DayState(tasks: tasks));
  }
}