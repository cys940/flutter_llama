// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeetingMetadata _$MeetingMetadataFromJson(Map<String, dynamic> json) =>
    _MeetingMetadata(
      summary: json['summary'] as String,
      actionItems: (json['actionItems'] as List<dynamic>)
          .map((e) => ActionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      fullTranscript: json['fullTranscript'] as String,
      duration: Duration(microseconds: (json['duration'] as num).toInt()),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$MeetingMetadataToJson(_MeetingMetadata instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'actionItems': instance.actionItems,
      'fullTranscript': instance.fullTranscript,
      'duration': instance.duration.inMicroseconds,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
    };
