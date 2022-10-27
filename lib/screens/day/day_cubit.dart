import 'package:bloc/bloc.dart';
import '../../api/models/task.dart';
import '../../repositories/tasks_repository.dart';
import 'day_state.dart';

class DayCubit extends Cubit<DayState> {
  DayCubit({
    required TasksRepository tasksRepository,
  }) : _tasksRepository = tasksRepository, super(const DayState());

  final TasksRepository _tasksRepository;

  void getTasks(DateTime startDate, [DateTime? endDate]) async {
    emit(state.copyWith(status: Status.loading));

    try {
      final List<Task> tasks = await _tasksRepository.getTasks(startDate, endDate);
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

  Future<void> addTask(Task task) async {
    try {
      await _tasksRepository.addTask(task);
      final List<Task> tasks = [...state.tasks];
      tasks.add(task);
      tasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      
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
        state.copyWith(
          tasks: tasks,
          status: Status.success
        )
      );
    } catch (error) {
      emit(state.copyWith(status: Status.error));
    }
  }
}
