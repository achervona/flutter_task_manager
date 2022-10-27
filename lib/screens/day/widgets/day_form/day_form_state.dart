import 'package:equatable/equatable.dart';

class DayFormState extends Equatable {
  const DayFormState({
    this.selectedDateTime,
  });

  final DateTime? selectedDateTime;

  @override
  List<Object?> get props => [selectedDateTime];
}
