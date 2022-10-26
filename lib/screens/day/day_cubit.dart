import 'package:bloc/bloc.dart';
import 'package:flutter_test_app/api/models/task.dart';
import 'package:flutter_test_app/repositories/tasks_repository.dart';
import 'day_state.dart';

class DayCubit extends Cubit<DayState> {
  DayCubit({
    required TasksRepository tasksRepository,
  }) : _tasksRepository = tasksRepository, super(const DayState());

  final TasksRepository _tasksRepository;

  void getTasks(DateTime startDate, [DateTime? endDate]) {
    emit(state.copyWith(status: Status.loading));

    try {
      final List<Task> tasks = _tasksRepository.getTasks(startDate, endDate);
      emit(
        state.copyWith(
          tasks: tasks,
          status: Status.success
        )
      );
    } catch (error) {
      emit(state.copyWith(status: Status.error));
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _tasksRepository.deleteTask(id);
      final List<Task> tasks = [...state.tasks];
      tasks.removeWhere((task) => task.id == id);

      emit(
        DayState(
          tasks: tasks,
          status: Status.success
        )
      );
    } catch (error) {
      emit(state.copyWith(status: Status.error));
    }
  }

  Future<void> addTask(Task task) async {
    try {
      final List<Task> tasks = [...state.tasks];
      await _tasksRepository.addTask(task);
      tasks.add(task);
      tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      
      emit(
        DayState(
          tasks: tasks,
          status: Status.success
        )
      );
    } catch (error) {
      emit(state.copyWith(status: Status.error));
    }
  }
}
