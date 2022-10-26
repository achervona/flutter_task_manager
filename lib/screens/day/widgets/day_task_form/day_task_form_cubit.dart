import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class DayTaskFormCubit extends Cubit<DayTaskFormState> {
  DayTaskFormCubit() : super(const DayTaskFormState());

  void setSelectedDateTime(DateTime? dateTime) {
    emit( 
      DayTaskFormState(
        selectedDateTime: dateTime
      )
    );
  }
}

class DayTaskFormState extends Equatable {
  const DayTaskFormState({
    this.selectedDateTime,
  });

  final DateTime? selectedDateTime;

  @override
  List<Object?> get props => [selectedDateTime];
}
