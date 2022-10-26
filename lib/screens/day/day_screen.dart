import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/api/models/task.dart';
import 'package:flutter_test_app/screens/day/widgets/day_task_list.dart';
import 'day_cubit.dart';
import 'day_state.dart';
import 'widgets/day_task_form/day_task_form.dart';
import 'widgets/day_task_form/day_task_form_cubit.dart';

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
    context.read<DayCubit>().getTasks(widget.date);
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
                      content: Text('Error')
                    )
                  );
                }
              },
              builder: (_, DayState state) {
                return state.status == Status.loading
                  ? const Center(
                      child: CircularProgressIndicator()
                    )
                  : DayTaskList(
                    tasks: state.tasks,
                    onTaskDismiss: onTaskDismiss
                  );
              }
            ),
          ),
          BlocProvider(
            create: (_) => DayTaskFormCubit(),
            child: DayTaskForm(
              addTask: addTask,
              date: widget.date
            )
          )
        ],
      )
    );
  }

  void onTaskDismiss(String id) {
    context.read<DayCubit>().deleteTask(id);
  }

  void addTask(DateTime dateTime, String description) {
    final Task task = Task(
      dateTime: dateTime,
      description: description
    );
    context.read<DayCubit>().addTask(task);
  }
}
