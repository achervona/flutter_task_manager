import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import '../../../models/task.dart';
import '../../../theme.dart';

class DayTaskList extends StatelessWidget  {
  const DayTaskList({
    Key? key,
    required this.onTaskDismissed,
    this.tasks = const <Task>[]
  }) : super(key: key);

  final List<Task> tasks;
  final void Function(String) onTaskDismissed;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'There are no tasks yet',
          style: TextStyle(
            color: AppThemeConstants.bodyTextColor,
            fontSize: AppThemeConstants.bodyFontSize,
          )
        )
      );
    }
    return ListView.builder(
      itemCount: tasks.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        bottom: 16.0
      ),
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          background: Container(
            color: AppThemeConstants.warningColor,
          ),
          key: ValueKey<String>(tasks[index].id),
          onDismissed: (_) => onTaskDismissed(tasks[index].id),
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatDate(tasks[index].dateTime, [HH, ':', nn]),
                    style: const TextStyle(
                      color: AppThemeConstants.bodyTextColor,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    tasks[index].description,
                    style: const TextStyle(
                      color: AppThemeConstants.bodyTextColor,
                      fontSize: AppThemeConstants.bodyFontSize,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ]
              ),
            )
          ),
        );
      },
    );
  }
}
