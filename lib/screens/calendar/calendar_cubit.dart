import 'package:bloc/bloc.dart';

class CalendarCubit extends Cubit<DateTime> {
  static final DateTime _initialDate = DateTime.now();

  CalendarCubit() : super(_initialDate);

  void nextMonth() {
    if (state.month < 12) {
      emit(DateTime(state.year, state.month + 1, 1));
    } else {
      emit(DateTime(state.year + 1, 1, 1));
    }
  }

  void prevMonth() {
    if (state.month > 1) {
      emit(DateTime(state.year, state.month - 1, 1));
    } else {
      emit(DateTime(state.year - 1, 12, 1));
    }
  }
}