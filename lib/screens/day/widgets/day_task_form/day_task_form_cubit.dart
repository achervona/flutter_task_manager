import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class DayTaskFormCubit extends Cubit<DayTaskFormState> {
  DayTaskFormCubit() : super(const DayTaskFormState());

  void setSelectedTime(String? time) {
    emit( 
      DayTaskFormState(
        selectedTime: time
      )
    );
  }
}

class DayTaskFormState extends Equatable {
  const DayTaskFormState({
    this.selectedTime,
  });

  final String? selectedTime;

  @override
  List<Object?> get props => [selectedTime];
}