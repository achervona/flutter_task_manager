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
  final DateTime dateTime;
  final String description;

  Task copyWith({
    String? id,
    DateTime? dateTime,
    String? description,
  }) {
    return Task(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
    );
  }

  static Task fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  List<Object> get props => [id, dateTime, description];
}
