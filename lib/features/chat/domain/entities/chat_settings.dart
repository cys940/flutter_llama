import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_settings.freezed.dart';
part 'chat_settings.g.dart';

@freezed
abstract class ChatSettings with _$ChatSettings {
  const factory ChatSettings({
    @Default(0.7) double temperature,
    @Default(0.9) double topP,
    @Default(2048) int maxTokens,
    @Default('You are a helpful AI assistant.') String systemPrompt,
    @Default(true) bool autoTitle,
  }) = _ChatSettings;

  factory ChatSettings.fromJson(Map<String, dynamic> json) =>
      _$ChatSettingsFromJson(json);
}
