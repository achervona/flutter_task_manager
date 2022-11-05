import 'package:equatable/equatable.dart';
import 'task.dart';

class Day extends Equatable {
  const Day({
    required this.date,
    this.tasks = const <Task>[],
    this.isToday = false,
    this.isActive = true,
  });

  final DateTime date;
  final List<Task> tasks;
  final bool isToday;
  final bool isActive;

  Day copyWith({
   List<Task>? tasks,
   bool? isToday,
   bool? isActive
  }) {
    return Day(
      date: date,
      tasks: tasks ?? this.tasks,
      isToday: isToday ?? this.isToday,
      isActive: isActive ?? this.isActive
    );
  }

  @override
  List<Object> get props => [date, tasks, isToday, isActive];
}
