import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:llamadart/llamadart.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/di/injection.dart';

@lazySingleton
class LlamaDataSource {
  final LlamaEngine _engine;
  final Talker _talker = getIt<Talker>();
  ChatSession? _session;

  LlamaDataSource(this._engine);

  /// 모델 파일의 경로를 기반으로 로컬 LLM을 초기화합니다.
  Future<void> init(String modelPath) async {
    try {
      _talker.debug('[LlamaDataSource] Loading model from $modelPath');
      await _engine.loadModel(modelPath);
      
      // 기본 세션 시작 (시스템 프롬프트 설정 가능)
      _session = ChatSession(_engine, systemPrompt: 'You are a helpful AI assistant.');
      _talker.info('[LlamaDataSource] Model loaded and session initialized');
    } catch (e, st) {
      _talker.handle(e, st, '[LlamaDataSource] Failed to initialize model at $modelPath');
      rethrow;
    }
  }

  /// 새로운 대화 세션을 시작합니다. (이전 대화 맥락 초기화)
  void startNewSession() {
    try {
       _session?.reset(keepSystemPrompt: true);
       _talker.debug('[LlamaDataSource] Session reset');
    } catch (e, st) {
       _talker.handle(e, st, '[LlamaDataSource] Error resetting session');
    }
  }

  /// 사용자의 메시지를 입력받아 AI의 응답을 스트림으로 반환합니다.
  Stream<String> generateResponse(
    String prompt, {
    double? temperature,
    int? maxTokens,
  }) async* {
    if (_session == null) {
      final error = Exception('LlamaEngine/ChatSession is not initialized. Please load a model first.');
      _talker.error('[LlamaDataSource] $error');
      throw error;
    }

    try {
      final responseStream = _session!.create(
        [LlamaTextContent(prompt)],
        params: GenerationParams(
          // ChatSettings 기본값(0.7)과 일치시킵니다.
          temp: temperature ?? 0.7,
          maxTokens: maxTokens ?? 2048,
          topP: 0.9,
          topK: 40,
        ),
      );

      await for (final chunk in responseStream) {
        if (chunk.choices.isNotEmpty) {
          final text = chunk.choices.first.delta.content;
          if (text != null) {
            yield text;
          }
        }
      }
    } catch (e, st) {
      _talker.handle(e, st, '[LlamaDataSource] Error generating response for prompt: $prompt');
      rethrow;
    }
  }

  /// 리소스를 해제합니다.
  Future<void> dispose() async {
    try {
      await _engine.dispose();
      _session = null;
      _talker.debug('[LlamaDataSource] Resources disposed');
    } catch (e, st) {
       _talker.handle(e, st, '[LlamaDataSource] Error during disposal');
    }
  }
}
