import 'package:equatable/equatable.dart';
import '../../api/models/day.dart';

enum CalendarStatus { initial, loading, success, error }

class CalendarState extends Equatable {
  const CalendarState({
    required this.year,
    required this.month,
    this.days = const <Day>[],
    this.status = CalendarStatus.initial
  });

  final int year;
  final int month;
  final List<Day> days;
  final CalendarStatus status;

  @override
  List<Object?> get props => [year, month, days, status];

  CalendarState copyWith({
   int? year,
   int? month,
   List<Day>? days,
   CalendarStatus? status
  }) {
    return CalendarState(
      year: year ?? this.year,
      month: month ?? this.month,
      days: days ?? this.days,
      status: status ?? this.status
    );
  }
}
