import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/chat_settings.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  static const _key = 'chat_settings';

  @override
  Future<ChatSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    
    if (jsonString != null) {
      try {
        return ChatSettings.fromJson(jsonDecode(jsonString));
      } catch (_) {
        return const ChatSettings();
      }
    }
    return const ChatSettings();
  }

  Future<void> updateSettings(ChatSettings settings) async {
    state = AsyncValue.data(settings);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }

  Future<void> updateTemperature(double value) async {
    final current = state.value ?? const ChatSettings();
    await updateSettings(current.copyWith(temperature: value));
  }

  Future<void> updateMaxTokens(int value) async {
    final current = state.value ?? const ChatSettings();
    await updateSettings(current.copyWith(maxTokens: value));
  }

  Future<void> updateTopP(double value) async {
    final current = state.value ?? const ChatSettings();
    await updateSettings(current.copyWith(topP: value));
  }

  Future<void> updateSystemPrompt(String value) async {
    final current = state.value ?? const ChatSettings();
    await updateSettings(current.copyWith(systemPrompt: value));
  }
}
