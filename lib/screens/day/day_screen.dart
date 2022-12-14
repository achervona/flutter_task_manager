import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/task.dart';
import '../../theme.dart';
import 'day_cubit.dart';
import 'day_state.dart';
import 'widgets/day_task_list.dart';
import 'widgets/day_form/day_form.dart';
import 'widgets/day_form/day_form_cubit.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({
    Key? key,
    required this.date,
    required this.onTaskListUpdate,
    this.tasks = const <Task>[]
  }) : super(key: key);

  final DateTime date;
  final List<Task> tasks;
  final void Function(DateTime date, List<Task> tasks) onTaskListUpdate;

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DayCubit>().setTasks(widget.tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeConstants.secondaryColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppThemeConstants.secondaryColor,
        title: Text(formatDate(widget.date, [dd, '.', mm, '.', yyyy])),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: BlocConsumer<DayCubit, DayState>(
              listener: (BuildContext context, DayState state) {
                if (state.status == DayStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error occurred')
                    )
                  );
                }
              },
              builder: (_, DayState state) {
                if (state.status == DayStatus.initial) {
                  return const SizedBox.shrink();
                }
                return DayTaskList(
                  tasks: state.tasks,
                  onTaskDismissed: _deleteTask
                );
              }
            ),
          ),
          BlocProvider(
            create: (_) => DayFormCubit(),
            child: SafeArea(
              child: DayTaskForm(
                onSubmit: _addTask,
                date: widget.date
              ),
            )
          )
        ],
      )
    );
  }

  void _addTask(DateTime dateTime, String description) async {
    final Task task = Task(
      dateTime: dateTime,
      description: description
    );
    final DayCubit cubit = context.read<DayCubit>();
    await cubit.addTask(task);
    widget.onTaskListUpdate(widget.date, cubit.state.tasks);
  }

  void _deleteTask(String id) async {
    final DayCubit cubit = context.read<DayCubit>();
    await cubit.deleteTask(id);
    widget.onTaskListUpdate(widget.date, cubit.state.tasks);
  }
}
