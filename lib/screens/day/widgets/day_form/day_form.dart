import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../theme.dart';
import 'day_form_cubit.dart';
import 'day_form_state.dart';

class DayTaskForm extends StatefulWidget  {
  const DayTaskForm({
    Key? key,
    required this.date,
    required this.onSubmit,
  }) : super(key: key);

  final void Function(DateTime dateTime, String description) onSubmit;
  final DateTime date;

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
        padding: const EdgeInsets.symmetric(
          vertical: 24.0, 
          horizontal: 16.0
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: AppThemeConstants.mainBorderRadius
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BlocBuilder<DayFormCubit, DayFormState>(
              builder: (_, DayFormState state) {
                return GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14.0,
                      horizontal: 16.0
                    ),
                    decoration: BoxDecoration(
                      color: AppThemeConstants.fieldColor,
                      borderRadius: const BorderRadius.all(AppThemeConstants.fieldBorderRadius),
                    ),
                    child: Text(
                      formatDate(state.selectedDateTime!, [HH, ':', nn]),
                      style: const TextStyle(
                        fontSize: AppThemeConstants.bodyFontSize
                      ),
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
                );
              }
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              validator: _descriptionValidator,
              decoration: const InputDecoration(
                hintText: 'New task'
              )
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _onSubmit(
                context.read<DayFormCubit>().state.selectedDateTime!,
                _descriptionController.value.text
              ),
              child: const Text('Save')
            )
          ]
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
        height: 236,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: AppThemeConstants.mainBorderRadius
          )
        ),
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
    if (value.length > 256) {
      return 'Field length must be less than 256 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
