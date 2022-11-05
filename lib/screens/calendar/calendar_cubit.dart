import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../models/day.dart';
import '../../models/task.dart';
import '../../repositories/tasks_repository.dart';
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

  void init() {
    _generateDays(state.year, state.month);
  }

  void goToNextMonth() {
    state.month < 12
      ? _generateDays(state.year, state.month + 1) 
      : _generateDays(state.year + 1, 1);
  }

  void goToPrevMonth() {
    state.month > 1
      ? _generateDays(state.year, state.month - 1)
      : _generateDays(state.year - 1, 12);
  }

  void _generateDays(int year, int month) async {
    emit(state.copyWith(status: CalendarStatus.loading));

    try {
      final DateTimeRange dateRange = _getDateRange(year, month);
      final List<Task> tasks = await _tasksRepository.getTasks(dateRange.start, dateRange.end);

      final days = List<Day>.generate(
        dateRange.duration.inDays,
        (index) {
          final DateTime date = dateRange.start.add(Duration(days: index));
          return Day(
            date: date,
            tasks: tasks.where((task) => _compareDates(task.dateTime, date)).toList(),
            isToday: _compareDates(date, DateTime.now()),
            isActive: date.month == month,
          );
        } 
      );
      emit(
        state.copyWith(
          year: year,
          month: month,
          days: days,
          status: CalendarStatus.success
        )
      );
    } catch (error) {
      emit(
        state.copyWith(
          year: year,
          month: month,
          status: CalendarStatus.error
        )
      );
    }
  }

  DateTimeRange _getDateRange(int year, int month) {
    final DateTime firstDateOfMonth = DateTime(year, month);
    final DateTime rangeStartDate = firstDateOfMonth.subtract(
      Duration(days: firstDateOfMonth.weekday - 1)
    );
    
    return DateTimeRange(
      start: rangeStartDate,
      end: rangeStartDate.add(const Duration(days: 42)),
    );
  }

  void updateDayTasks(DateTime date, List<Task> tasks) {
    emit(
      state.copyWith(
        days: state.days.map((Day day) => 
          _compareDates(day.date, date) ? day.copyWith(tasks: tasks) : day
        ).toList()
      )
    );
  }

  bool _compareDates(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year && firstDate.month == secondDate.month && firstDate.day == secondDate.day;
  }
}
