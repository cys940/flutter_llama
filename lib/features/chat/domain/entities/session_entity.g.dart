// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionEntity _$SessionEntityFromJson(Map<String, dynamic> json) =>
    _SessionEntity(
      sessionId: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageEntity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isMeeting: json['isMeeting'] == null
          ? false
          : const BoolIntConverter().fromJson(json['isMeeting']),
      meetingMetadata: const MeetingMetadataConverter().fromJson(
        json['meetingMetadata'] as String?,
      ),
    );

Map<String, dynamic> _$SessionEntityToJson(_SessionEntity instance) =>
    <String, dynamic>{
      'id': instance.sessionId,
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastMessageAt': instance.lastMessageAt.toIso8601String(),
      'isMeeting': const BoolIntConverter().toJson(instance.isMeeting),
      'meetingMetadata': const MeetingMetadataConverter().toJson(
        instance.meetingMetadata,
      ),
    };
