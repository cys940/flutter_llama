import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_entity.dart';
import 'meeting_metadata.dart';
import '../../../../core/utils/json_converters.dart';

part 'session_entity.freezed.dart';
part 'session_entity.g.dart';

@freezed
abstract class SessionEntity with _$SessionEntity {
  const factory SessionEntity({
    @JsonKey(name: 'id') required String sessionId,
    required String title,
    required DateTime createdAt,
    required DateTime lastMessageAt,
    @JsonKey(includeToJson: false) @Default([]) List<MessageEntity> messages,
    @BoolIntConverter() @Default(false) bool isMeeting,
    @MeetingMetadataConverter() MeetingMetadata? meetingMetadata,
  }) = _SessionEntity;

  factory SessionEntity.fromJson(Map<String, dynamic> json) => _$SessionEntityFromJson(json);
}

class MeetingMetadataConverter implements JsonConverter<MeetingMetadata?, String?> {
  const MeetingMetadataConverter();

  @override
  MeetingMetadata? fromJson(String? json) {
    if (json == null) return null;
    return MeetingMetadata.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  @override
  String? toJson(MeetingMetadata? object) {
    if (object == null) return null;
    return jsonEncode(object.toJson());
  }
}
