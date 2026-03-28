import '../../domain/entities/message_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/session_entity.dart';

part 'chat_state.freezed.dart';

@freezed
abstract class ChatState with _$ChatState {
  const factory ChatState({
    @Default([]) List<MessageEntity> messages,
    @Default([]) List<SessionEntity> sessions,
    @Default(false) bool isLoading,
    @Default(false) bool isModelLoaded,
    String? modelError,
    String? error,
    String? modelPath,
    String? sessionId,
  }) = _ChatState;
}
