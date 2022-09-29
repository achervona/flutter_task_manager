import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/api/models/task.dart';
import 'package:flutter_test_app/screens/day/widgets/day_task_list.dart';
import 'day_cubit.dart';
import 'widgets/day_task_form/day_task_form.dart';

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
    //context.read<DayCubit>().addTask(Task(time: 'vdfv', description: 'dvdfvdfv'));
    context.read<DayCubit>().getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.date.toString()),
      ),
      body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: BlocBuilder<DayCubit, DayState>(
                  builder: (BuildContext context, DayState state) {
                    return DayTaskList(
                      tasks: state.tasks,
                      onTaskDismiss: onTaskDismiss
                    );
                  }
                ),
              ),
              Expanded(
                child: DayTaskForm(
                  onSubmit: addTask
                )
              )
            ],
          )
    );
  }

  void onTaskDismiss(String id) {
    context.read<DayCubit>().deleteTask(id);
  }

  void addTask(String time, String description) {
    //widget.date;
    final Task task = Task(
      time: time,
      description: description
    );
    context.read<DayCubit>().addTask(task)
     .then((value) => {
      
     });
  }

  // @override
  // void dispose() {
  //   _cubit.close();
  //   super.dispose();
  // }
}
