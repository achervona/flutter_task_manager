import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/models/task.dart';

class DayTaskList extends StatelessWidget  {
  final List<Task> tasks;
  final void Function(String)? onTaskDismiss;

  const DayTaskList({
    Key? key,
    this.tasks = const [],
    this.onTaskDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text('There are no tasks')
      );
    }
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          background: Container(
            color: Colors.redAccent.shade400,
          ),
          key: ValueKey<String>(tasks[index].id),
          onDismissed: onTaskDismiss != null ? (_) => onTaskDismiss!(tasks[index].id) : null,
          child: ListTile(
            title: Text(getTimeFromDate(tasks[index].dateTime)),
            subtitle: Text(tasks[index].description),
          ),
        );
      },
    );
  }

  String getTimeFromDate(DateTime date) {
    final String hours = date.hour.toString().padLeft(2, '0');
    final String minutes = date.minute.toString().padLeft(2, '0');
    return hours + ':' + minutes;
  }
}