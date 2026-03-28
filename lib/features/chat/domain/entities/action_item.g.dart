// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActionItem _$ActionItemFromJson(Map<String, dynamic> json) => _ActionItem(
  id: json['id'] as String,
  task: json['task'] as String,
  assignee: json['assignee'] as String?,
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  isCompleted: json['isCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$ActionItemToJson(_ActionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task': instance.task,
      'assignee': instance.assignee,
      'dueDate': instance.dueDate?.toIso8601String(),
      'isCompleted': instance.isCompleted,
    };
