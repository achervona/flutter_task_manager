import 'package:equatable/equatable.dart';
import '../../api/models/task.dart';

enum DayStatus { initial, success, error }

class DayState extends Equatable {
  const DayState({
    this.tasks = const <Task>[],
    this.status = DayStatus.initial
  });

  final List<Task> tasks;
  final DayStatus status;

  @override
  List<Object?> get props => [tasks, status];

  DayState copyWith({
   List<Task>? tasks,
   DayStatus? status
  }) {
    return DayState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status
    );
  }
}
