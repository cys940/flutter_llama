// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageEntity _$MessageEntityFromJson(Map<String, dynamic> json) =>
    _MessageEntity(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String?,
      text: json['text'] as String,
      isUser: const BoolIntConverter().fromJson(json['isUser']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$MessageEntityToJson(_MessageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'text': instance.text,
      'isUser': const BoolIntConverter().toJson(instance.isUser),
      'timestamp': instance.timestamp.toIso8601String(),
    };
