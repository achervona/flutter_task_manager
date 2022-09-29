import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'day_task_form_cubit.dart';

class DayTaskForm extends StatefulWidget  {
  final void Function(String time, String description)? onSubmit;

  const DayTaskForm({
    Key? key,
    this.onSubmit,
  }) : super(key: key);

  @override
  State<DayTaskForm> createState() => _DayTaskFormState();
}

class _DayTaskFormState extends State<DayTaskForm> {
  final DayTaskFormCubit _cubit = DayTaskFormCubit();
  //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  late final List<String> _timeDropdownOptions;

  @override
  void initState() {
    super.initState();
    _timeDropdownOptions = getTimeOptions();
    _cubit.setSelectedTime(_timeDropdownOptions.first);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      //key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<DayTaskFormCubit, DayTaskFormState>(
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
                ),
                ElevatedButton(
                  onPressed: widget.onSubmit != null 
                    ? () => widget.onSubmit!(state.selectedTime!, _descriptionController.value.text) 
                    : null,
                  child: const Text('Add task'),
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  List<String> getTimeOptions() {
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