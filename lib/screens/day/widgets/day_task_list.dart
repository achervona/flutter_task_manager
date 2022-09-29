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
    return ListView.builder(
      itemCount: tasks.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          background: Container(
            color: Colors.red,
          ),
          key: ValueKey<String>(tasks[index].id),
          onDismissed: onTaskDismiss != null ? (_) => onTaskDismiss!(tasks[index].id) : null,
          child: ListTile(
            title: Text(tasks[index].time),
            subtitle: Text(tasks[index].description),
          ),
        );
      },
    );
  }
}