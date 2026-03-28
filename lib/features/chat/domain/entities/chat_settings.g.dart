// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatSettings _$ChatSettingsFromJson(Map<String, dynamic> json) =>
    _ChatSettings(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      maxTokens: (json['maxTokens'] as num?)?.toInt() ?? 2048,
      systemPrompt:
          json['systemPrompt'] as String? ?? 'You are a helpful AI assistant.',
      autoTitle: json['autoTitle'] as bool? ?? true,
    );

Map<String, dynamic> _$ChatSettingsToJson(_ChatSettings instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'maxTokens': instance.maxTokens,
      'systemPrompt': instance.systemPrompt,
      'autoTitle': instance.autoTitle,
    };
