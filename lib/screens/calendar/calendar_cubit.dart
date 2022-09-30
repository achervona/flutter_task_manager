import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test_app/repositories/tasks_repository.dart';

class CalendarCubit extends Cubit<CalendarState> {
  static final DateTime _initialDate = DateTime.now();

  CalendarCubit({
    required TasksRepository tasksRepository,
  }) : _tasksRepository = tasksRepository, super(CalendarState(
    year: _initialDate.year,
    month: _initialDate.month
  ));

  final TasksRepository _tasksRepository;

  void nextMonth() {
    emit( 
      state.month < 12 ?
        CalendarState(
          year: state.year,
          month: state.month + 1
        ) :
        CalendarState(
          year: state.year + 1,
          month: 1
        )
    );

    //getTaskCountsForMonth(2022, 9);
  }

  void prevMonth() {
    emit( 
      state.month > 1 ?
        CalendarState(
          year: state.year,
          month: state.month - 1
        ) :
        CalendarState(
          year: state.year - 1,
          month: 12
        )
    );
  }

  Map getTaskCountsForMonth(int year, int month) => _tasksRepository.getTaskCountsForMonth(year, month);
}

class CalendarState extends Equatable {
  const CalendarState({
    required this.year,
    required this.month
  });

  final int year;
  final int month;

  @override
  List<Object?> get props => [year, month];
}