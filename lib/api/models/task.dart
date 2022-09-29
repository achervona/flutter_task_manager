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
    required this.time,
    this.description = '',
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String time;
  final String description;

  Task copyWith({
    String? id,
    String? time,
    String? description,
  }) {
    return Task(
      id: id ?? this.id,
      time: time ?? this.time,
      description: description ?? this.description,
    );
  }

  static Task fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  List<Object> get props => [id, time, description];
}
