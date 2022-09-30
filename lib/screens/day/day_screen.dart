import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/screens/day/widgets/day_task_list.dart';
import 'day_cubit.dart';
import 'day_state.dart';
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
    context.read<DayCubit>().getTasks(widget.date, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_formatDate(widget.date)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: BlocConsumer<DayCubit, DayState>(
              listenWhen: (DayState prevState, DayState state) {
                return prevState.status != state.status;
              },
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
          BlocProvider.value(
            value: BlocProvider.of<DayCubit>(context),
            child: DayTaskForm(
              //onSubmit: addTask
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

  // void addTask(String time, String description) {
  //   final List<String> timeList = time.split(':');
  //   final DateTime dateTime = DateTime(
  //     widget.date.year, 
  //     widget.date.month, 
  //     widget.date.day, 
  //     int.parse(timeList[0]), 
  //     int.parse(timeList[1])
  //   );
  //   final Task task = Task(
  //     dateTime: dateTime,
  //     description: description
  //   );

  //   context.read<DayCubit>().addTask(task);
  // }

  String _formatDate(DateTime date) {
    return date.day.toString().padLeft(2, '0') + '.' + date.month.toString().padLeft(2, '0') + '.' + date.year.toString();
  }

  // @override
  // void dispose() {
  //   _cubit.close();
  //   super.dispose();
  // }
}
