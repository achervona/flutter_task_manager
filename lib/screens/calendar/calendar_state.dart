import 'package:equatable/equatable.dart';

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