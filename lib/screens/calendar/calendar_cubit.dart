import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_app/api/models/day.dart';
import 'package:flutter_test_app/api/models/task.dart';
import 'package:flutter_test_app/repositories/tasks_repository.dart';
import 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  static final DateTime _initialDate = DateTime.now();

  CalendarCubit({
    required TasksRepository tasksRepository,
  }) : _tasksRepository = tasksRepository, super(CalendarState(
    year: _initialDate.year,
    month: _initialDate.month
  ));

  final TasksRepository _tasksRepository;

  void load() {
    _generateDays(state.year, state.month);
  }

  void nextMonth() {
    final int year = state.month < 12 ? state.year : state.year + 1;
    final int month = state.month < 12 ? state.month + 1 : 1;
    _generateDays(year, month);
  }

  void prevMonth() {
    final int year = state.month > 1 ? state.year : state.year - 1;
    final int month = state.month > 1 ? state.month - 1 : 12;
    _generateDays(year, month);
  }

  void _generateDays(int year, int month) {
    emit(state.copyWith(status: Status.loading));

    try {
      final DateTimeRange range = _getDateTimeRange(year, month);
      final List<Task> tasks = _tasksRepository.getTasks(range.start, range.end);

      final days = List<Day>.generate(
        range.duration.inDays,
        (index) {
          final DateTime date = range.start.add(Duration(days: index));
          return Day(
            date: date,
            taskNumber: tasks.where((task) => _compareDate(task.dateTime, date)).length,
            isToday: _compareDate(date, DateTime.now()),
            isActive: date.month == month,
          );
        } 
      );
      emit(state.copyWith(
          year: year,
          month: month,
          days: days,
          status: Status.success
        )
      );
    } catch (error) {
      emit(state.copyWith(
          year: year,
          month: month,
          status: Status.error
        )
      );
    }
  }

  DateTimeRange _getDateTimeRange(int year, int month) {
    final DateTime firstDateOfMonth = DateTime(year, month);
    final DateTime start = firstDateOfMonth.subtract(Duration(days: firstDateOfMonth.weekday - 1));
    
    return DateTimeRange(
      start: start,
      end: start.add(const Duration(days: 42)),
    );
  }

  bool _compareDate(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year && firstDate.month == secondDate.month && firstDate.day == secondDate.day;
  }
}
