import 'package:freezed_annotation/freezed_annotation.dart';
import 'message_entity.dart';
export 'message_entity.dart';

part 'session_entity.freezed.dart';

@freezed
abstract class SessionEntity with _$SessionEntity {
  const factory SessionEntity({
    required String sessionId,
    required String title,
    required DateTime createdAt,
    required DateTime lastMessageAt,
    @Default([]) List<MessageEntity> messages,
  }) = _SessionEntity;

  factory SessionEntity.fromMap(Map<String, dynamic> map) {
    return SessionEntity(
      sessionId: map['id'] as String,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      lastMessageAt: DateTime.parse(map['lastMessageAt'] as String),
    );
  }

  static Map<String, dynamic> toMap(SessionEntity session) {
    return {
      'id': session.sessionId,
      'title': session.title,
      'createdAt': session.createdAt.toIso8601String(),
      'lastMessageAt': session.lastMessageAt.toIso8601String(),
    };
  }
}
