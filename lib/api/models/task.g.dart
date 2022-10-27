// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String?,
      dateTime: Task.dateTimeFromJson(json['dateTime'] as int),
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'dateTime': Task.dateTimeToJson(instance.dateTime),
      'description': instance.description,
    };
