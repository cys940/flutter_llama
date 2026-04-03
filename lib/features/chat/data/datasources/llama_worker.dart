import 'dart:isolate';
import 'package:llamadart/llamadart.dart';

/// LLM 엔진을 별도 Isolate에서 실행하기 위한 워커 클래스
class LlamaWorker {
  // Isolate 내에서 엔진과 세션을 관리하며, 메인 스레드와 메시지를 주고받습니다.

  /// Isolate 엔트리 포인트
  static void setup(SendPort mainSendPort) async {
    final workerReceivePort = ReceivePort();
    mainSendPort.send(workerReceivePort.sendPort);

    LlamaEngine? engine;
    ChatSession? session;

    await for (final message in workerReceivePort) {
      if (message is Map<String, dynamic>) {
        final command = message['command'] as String;

        try {
          switch (command) {
            case 'load':
              final modelPath = message['modelPath'] as String;
              
              // 기존 리소스 정리
              await engine?.dispose();
              engine = null;
              session = null;

              try {
                engine = LlamaEngine(LlamaBackend());
                await engine.loadModel(modelPath);
                session = ChatSession(engine, systemPrompt: 'You are a helpful AI assistant.');
                mainSendPort.send({'status': 'loaded'});
              } catch (e) {
                await engine?.dispose();
                engine = null;
                rethrow;
              }
              break;

            case 'generate':
              if (session == null) {
                mainSendPort.send({'status': 'error', 'message': 'Engine not initialized'});
                break;
              }

              final prompt = message['prompt'] as String;
              final temp = message['temp'] as double? ?? 0.8;
              final maxTokens = message['maxTokens'] as int? ?? 2048;

              try {
                final responseStream = session.create(
                  [LlamaTextContent(prompt)],
                  params: GenerationParams(
                    temp: temp,
                    maxTokens: maxTokens,
                    topP: 0.9,
                    topK: 40,
                  ),
                );

                await for (final chunk in responseStream) {
                  if (chunk.choices.isNotEmpty) {
                    final text = chunk.choices.first.delta.content;
                    if (text != null) {
                      mainSendPort.send({'status': 'chunk', 'text': text});
                    }
                  }
                }
                mainSendPort.send({'status': 'done'});
              } catch (e) {
                mainSendPort.send({'status': 'error', 'message': 'Generation failed: $e'});
              }
              break;

            case 'reset':
              session?.reset(keepSystemPrompt: true);
              mainSendPort.send({'status': 'reset_done'});
              break;

            case 'dispose':
            case 'kill':
              try {
                await engine?.dispose();
              } finally {
                engine = null;
                session = null;
                mainSendPort.send({'status': 'disposed'});
                if (command == 'kill') {
                  Isolate.exit();
                }
              }
              break;
          }
        } catch (e) {
          mainSendPort.send({'status': 'error', 'message': e.toString()});
        }
      }
    }
  }
}
