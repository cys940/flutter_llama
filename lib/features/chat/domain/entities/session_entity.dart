import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_entity.dart';
import 'meeting_metadata.dart';

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
    @Default(false) bool isMeeting,
    MeetingMetadata? meetingMetadata,
  }) = _SessionEntity;

  factory SessionEntity.fromJson(Map<String, dynamic> json) => _$SessionEntityFromJson(json);
}
