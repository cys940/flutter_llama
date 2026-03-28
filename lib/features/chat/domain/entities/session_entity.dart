import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_entity.dart';

part 'session_entity.freezed.dart';
part 'session_entity.g.dart';

@freezed
abstract class SessionEntity with _$SessionEntity {
  const factory SessionEntity({
    @JsonKey(name: 'id') required String sessionId,
    required String title,
    required DateTime createdAt,
    required DateTime lastMessageAt,
    @Default([]) List<MessageEntity> messages,
  }) = _SessionEntity;

  factory SessionEntity.fromJson(Map<String, dynamic> json) => _$SessionEntityFromJson(json);
}
