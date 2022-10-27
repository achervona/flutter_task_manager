import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'day_form_cubit.dart';
import 'day_form_state.dart';

class DayTaskForm extends StatefulWidget  {
  final void Function(DateTime dateTime, String description) onSubmit;
  final DateTime date;

  const DayTaskForm({
    Key? key,
    required this.date,
    required this.onSubmit,
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
    context.read<DayFormCubit>().setSelectedDateTime(widget.date);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.purple.shade800)
          ),
        ),
        child: BlocBuilder<DayFormCubit, DayFormState>(
          builder: (_, DayFormState state) {
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
                        context.read<DayFormCubit>().setSelectedDateTime(newDateTime);
                      },
                    )
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  validator: _descriptionValidator,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.redAccent.shade400),
                    errorBorder: UnderlineInputBorder (
                      borderSide: BorderSide(color: Colors.redAccent.shade400)
                    )
                  )
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _onSubmit(state.selectedDateTime!, _descriptionController.value.text),
                  child: const Text('Add task'),
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
    widget.onSubmit(dateTime, description);
    context.read<DayFormCubit>().setSelectedDateTime(widget.date);
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

  String? _descriptionValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field is required';
    }
    if (value.length > 512) {
      return 'Field length must be less than 512 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
