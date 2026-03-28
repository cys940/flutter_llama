import 'dart:async';
import 'package:llamadart/llamadart.dart';

class LlamaDataSource {
  LlamaEngine? _engine;

  /// 모델 파일의 경로를 기반으로 로컬 LLM을 초기화합니다.
  Future<void> init(String modelPath) async {
    _engine = LlamaEngine(LlamaBackend());
    await _engine!.loadModel(modelPath);
  }

  /// 사용자의 메시지를 입력받아 AI의 응답을 스트림으로 반환합니다.
  Stream<String> generateResponse(String prompt) async* {
    if (_engine == null) {
      throw Exception('LlamaEngine is not initialized. Please load a model first.');
    }

    await for (final token in _engine!.generate(prompt)) {
      yield token;
    }
  }

  /// 리소스를 해제합니다.
  Future<void> dispose() async {
    await _engine?.dispose();
    _engine = null;
  }
}
