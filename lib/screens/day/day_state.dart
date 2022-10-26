
import 'package:equatable/equatable.dart';
import 'package:flutter_test_app/api/models/task.dart';

enum Status { initial, loading, success, error }

class DayState extends Equatable {
  const DayState({
    this.tasks = const <Task>[],
    this.status = Status.initial
  });

  final List<Task> tasks;
  final Status status;

  @override
  List<Object?> get props => [tasks, status];

  DayState copyWith({
   List<Task>? tasks,
   Status? status
  }) {
    return DayState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status
    );
  }
}
