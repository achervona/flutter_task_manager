import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'day_task_form_cubit.dart';

class DayTaskForm extends StatefulWidget  {
  final void Function(DateTime dateTime, String description) addTask;
  final DateTime date;

  const DayTaskForm({
    Key? key,
    required this.date,
    required this.addTask,
  }) : super(key: key);

  @override
  State<DayTaskForm> createState() => _DayTaskFormState();
}

class _DayTaskFormState extends State<DayTaskForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<DayTaskFormCubit>().setSelectedDateTime(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<DayTaskFormCubit, DayTaskFormState>(
          builder: (_, DayTaskFormState state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  child: Text(
                    formatDate(state.selectedDateTime!, [HH, ':', nn]),
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  ),
                  onTap: () => _showDialog(
                    CupertinoDatePicker(
                      initialDateTime: state.selectedDateTime,
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      minuteInterval: 30,
                      onDateTimeChanged: (DateTime newDateTime) {
                        context.read<DayTaskFormCubit>().setSelectedDateTime(newDateTime);
                      },
                    )
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  validator: (value) => value == null || value.isEmpty ? 'Field is required' : null,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.redAccent.shade400),
                    errorBorder: UnderlineInputBorder (
                      borderSide: BorderSide(color: Colors.redAccent.shade400)
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () => _onSubmit(state.selectedDateTime!, _descriptionController.value.text),
                    child: const Text('Add task'),
                  )
                )
              ],
            );
          }
        )
      ),
    );
  }

  void _onSubmit(DateTime dateTime, String description) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    widget.addTask(dateTime, description);
    context.read<DayTaskFormCubit>().setSelectedDateTime(widget.date);
    _descriptionController.clear();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      )
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
