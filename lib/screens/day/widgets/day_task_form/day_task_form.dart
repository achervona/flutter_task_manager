import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/api/models/task.dart';
import '../../day_cubit.dart';
import '../../day_state.dart';
import 'day_task_form_cubit.dart';

class DayTaskForm extends StatefulWidget  {
  //final void Function(String time, String description)? onSubmit;
  final DateTime date;

  const DayTaskForm({
    Key? key,
    required this.date
    //this.onSubmit,
  }) : super(key: key);

  @override
  State<DayTaskForm> createState() => _DayTaskFormState();
}

class _DayTaskFormState extends State<DayTaskForm> {
  final DayTaskFormCubit _cubit = DayTaskFormCubit();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  late final List<String> _timeDropdownOptions;

  @override
  void initState() {
    super.initState();
    _timeDropdownOptions = _getTimeOptions();
    _cubit.setSelectedTime(_timeDropdownOptions.first);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocConsumer<DayCubit, DayState>(
          listener: (BuildContext dayContext, DayState dayState) {
            if (dayState.status == Status.success) {
              _cubit.setSelectedTime(_timeDropdownOptions.first);
              _descriptionController.clear();
            }
          },
          builder: (BuildContext dayContext, DayState dayState) {
            return BlocBuilder<DayTaskFormCubit, DayTaskFormState>(
              bloc: _cubit,
              builder: (BuildContext context, DayTaskFormState state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButton(
                      value: state.selectedTime,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: _timeDropdownOptions.map((String time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time)
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        _cubit.setSelectedTime(newValue);
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(color: Colors.redAccent.shade400),
                        errorBorder: UnderlineInputBorder (borderSide: BorderSide(color: Colors.redAccent.shade400))
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () => _onSubmit(state.selectedTime!, _descriptionController.value.text),
                          child: const Text('Add task'),
                        )
                      )
                  ],
                );
              }
            );
          }
        ),
      ),
    );
  }

  // void _onSubmit(String time, String description) {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //   if (widget.onSubmit != null) {
  //     widget.onSubmit!(time, description);
  //   }
  // }

  void _onSubmit(String time, String description) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final List<String> timeList = time.split(':');
    final DateTime dateTime = DateTime(
      widget.date.year, 
      widget.date.month, 
      widget.date.day, 
      int.parse(timeList[0]), 
      int.parse(timeList[1])
    );
    final Task task = Task(
      dateTime: dateTime,
      description: description
    );

    context.read<DayCubit>().addTask(task);
  }

  List<String> _getTimeOptions() {
    final List<String> options = [];

    for (int i = 0; i <= 23; i++) {
      final String hours = i.toString().padLeft(2, '0');
      options.add(hours + ':00');
      options.add(hours + ':30');
    }

    return options;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _cubit.close();
    super.dispose();
  }
}