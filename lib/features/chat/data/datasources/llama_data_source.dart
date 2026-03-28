import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:llamadart/llamadart.dart';

@lazySingleton
class LlamaDataSource {
  final LlamaEngine _engine;
  ChatSession? _session;

  LlamaDataSource(this._engine);

  /// 모델 파일의 경로를 기반으로 로컬 LLM을 초기화합니다.
  Future<void> init(String modelPath) async {
    await _engine.loadModel(modelPath);
    
    // 기본 세션 시작 (시스템 프롬프트 설정 가능)
    _session = ChatSession(_engine, systemPrompt: 'You are a helpful AI assistant.');
  }

  /// 새로운 대화 세션을 시작합니다. (이전 대화 맥락 초기화)
  void startNewSession() {
    _session?.reset(keepSystemPrompt: true);
  }

  /// 사용자의 메시지를 입력받아 AI의 응답을 스트림으로 반환합니다.
  Stream<String> generateResponse(
    String prompt, {
    double? temperature,
    int? maxTokens,
  }) async* {
    if (_session == null) {
      throw Exception('LlamaEngine/ChatSession is not initialized. Please load a model first.');
    }

    final responseStream = _session!.create(
      [LlamaTextContent(prompt)],
      params: GenerationParams(
        temp: temperature ?? 0.8,
        maxTokens: maxTokens ?? 2048,
      ),
    );

    await for (final chunk in responseStream) {
      final text = chunk.choices.first.delta.content;
      if (text != null) {
        yield text;
      }
    }
  }

  /// 리소스를 해제합니다.
  Future<void> dispose() async {
    await _engine.dispose();
    _session = null;
  }
}
