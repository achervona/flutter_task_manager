import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/models/task.dart';
import 'day_cubit.dart';
import 'day_state.dart';
import 'widgets/day_task_list.dart';
import 'widgets/day_form/day_form.dart';
import 'widgets/day_form/day_form_cubit.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({
    Key? key,
    required this.date,
  }) : super(key: key);

  final DateTime date;

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DayCubit>().getTasks(
      widget.date, 
      widget.date.add(const Duration(days: 1))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(formatDate(widget.date, [dd, '.', mm, '.', yyyy])),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: BlocConsumer<DayCubit, DayState>(
              listener: (BuildContext context, DayState state) {
                if (state.status == Status.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error occurred')
                    )
                  );
                }
              },
              builder: (_, DayState state) {
                if (state.status == Status.initial) {
                  return const SizedBox.shrink();
                }
                if (state.status == Status.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return DayTaskList(
                  tasks: state.tasks,
                  onTaskDismissed: deleteTask
                );
              }
            ),
          ),
          BlocProvider(
            create: (_) => DayFormCubit(),
            child: DayTaskForm(
              onSubmit: addTask,
              date: widget.date
            )
          )
        ],
      )
    );
  }

  void addTask(DateTime dateTime, String description) {
    final Task task = Task(
      dateTime: dateTime,
      description: description
    );
    context.read<DayCubit>().addTask(task);
  }

  void deleteTask(String id) {
    context.read<DayCubit>().deleteTask(id);
  }
}
