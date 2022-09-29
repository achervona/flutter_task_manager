import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class CalendarCubit extends Cubit<CalendarState> {
  static final DateTime _initialDate = DateTime.now();

  CalendarCubit() : super(CalendarState(
    year: _initialDate.year,
    month: _initialDate.month
  ));

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