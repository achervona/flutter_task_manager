import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@immutable
@JsonSerializable()
class Task extends Equatable {
  Task({
    String? id,
    required this.dateTime,
    this.description = '',
  }) : id = id ?? const Uuid().v4();

  final String id;
  @JsonKey(
    toJson: dateTimeToJson,
    fromJson: dateTimeFromJson,
  )
  final DateTime dateTime;
  final String description;

  static Task fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  static int dateTimeToJson(DateTime value) => value.millisecondsSinceEpoch;
  static DateTime dateTimeFromJson(int value) => DateTime.fromMillisecondsSinceEpoch(value);

  @override
  List<Object> get props => [id, dateTime, description];
}
