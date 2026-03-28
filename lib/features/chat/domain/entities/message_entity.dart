import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';

@freezed
abstract class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    required String id,
    required String text,
    required bool isUser,
    required DateTime timestamp,
  }) = _MessageEntity;

  factory MessageEntity.fromMap(Map<String, dynamic> map) {
    return MessageEntity(
      id: map['id'] as String,
      text: map['text'] as String,
      isUser: (map['isUser'] as int) == 1,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  static Map<String, dynamic> toMap(MessageEntity message, String sessionId) {
    return {
      'id': message.id,
      'sessionId': sessionId,
      'text': message.text,
      'isUser': message.isUser ? 1 : 0,
      'timestamp': message.timestamp.toIso8601String(),
    };
  }
}
