import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../api/models/day.dart';
import '../../api/models/task.dart';
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
    final int year = state.month < 12 ? state.year : state.year + 1;
    final int month = state.month < 12 ? state.month + 1 : 1;
    _generateDays(year, month);
  }

  void goToPrevMonth() {
    final int year = state.month > 1 ? state.year : state.year - 1;
    final int month = state.month > 1 ? state.month - 1 : 12;
    _generateDays(year, month);
  }

  void _generateDays(int year, int month) async {
    emit(state.copyWith(status: CalendarStatus.loading));

    try {
      final DateTimeRange range = _getDateTimeRange(year, month);
      final List<Task> tasks = await _tasksRepository.getTasks(range.start, range.end);

      final days = List<Day>.generate(
        range.duration.inDays,
        (index) {
          final DateTime date = range.start.add(Duration(days: index));
          return Day(
            date: date,
            tasks: tasks.where((task) => _compareDate(task.dateTime, date)).toList(),
            isToday: _compareDate(date, DateTime.now()),
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

  DateTimeRange _getDateTimeRange(int year, int month) {
    final DateTime firstDateOfMonth = DateTime(year, month);
    final DateTime start = firstDateOfMonth.subtract(Duration(days: firstDateOfMonth.weekday - 1));
    
    return DateTimeRange(
      start: start,
      end: start.add(const Duration(days: 42)),
    );
  }

  void updateDayTasks(DateTime date, List<Task> tasks) {
    emit(
      state.copyWith(
        days: state.days.map((Day day) => 
          _compareDate(day.date, date) ? day.copyWith(tasks: tasks) : day
        ).toList()
      )
    );
  }

  bool _compareDate(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year && firstDate.month == secondDate.month && firstDate.day == secondDate.day;
  }
}
