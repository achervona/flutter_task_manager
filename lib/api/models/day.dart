import 'package:equatable/equatable.dart';

class Day extends Equatable {
  const Day({
    required this.date,
    this.taskNumber = 0,
    this.isToday = false,
    this.isActive = true,
  });

  final DateTime date;
  final int taskNumber;
  final bool isToday;
  final bool isActive;

  @override
  List<Object> get props => [date, taskNumber, isToday, isActive];
}
