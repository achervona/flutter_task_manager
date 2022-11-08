import 'package:bloc/bloc.dart';
import 'day_form_state.dart';

class DayFormCubit extends Cubit<DayFormState> {
  DayFormCubit() : super(const DayFormState());

  void setSelectedDateTime(DateTime? dateTime) {
    emit(DayFormState(
      selectedDateTime: dateTime
    ));
  }
}
