import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_entity.freezed.dart';
part 'message_entity.g.dart';

@freezed
abstract class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    required String id,
    @JsonKey(includeToJson: true) String? sessionId,
    required String text,
    @JsonKey(name: 'isUser', fromJson: _boolFromInt, toJson: _boolToInt) required bool isUser,
    required DateTime timestamp,
  }) = _MessageEntity;

  factory MessageEntity.fromJson(Map<String, dynamic> json) => _$MessageEntityFromJson(json);
}

bool _boolFromInt(dynamic value) {
  if (value is int) return value == 1;
  if (value is bool) return value;
  return false;
}

int _boolToInt(bool value) => value ? 1 : 0;
