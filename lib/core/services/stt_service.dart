import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../di/injection.dart';

@lazySingleton
class SttService {
  final SpeechToText _speechToText = SpeechToText();
  final Talker _talker = getIt<Talker>();
  
  bool _isInitialized = false;
  String _lastWords = '';
  final StreamController<String> _textStreamController = StreamController<String>.broadcast();

  Stream<String> get textStream => _textStreamController.stream;

  Future<bool> initialize() async {
    if (_isInitialized) return true;
    
    try {
      _isInitialized = await _speechToText.initialize(
        onStatus: (status) => _talker.debug('[SttService] Status: $status'),
        onError: (errorNotification) => _talker.error('[SttService] Error: $errorNotification'),
      );
      return _isInitialized;
    } catch (e) {
      _talker.error('[SttService] Initialization failed: $e');
      return false;
    }
  }

  Future<void> startListening() async {
    if (!_isInitialized) {
      final success = await initialize();
      if (!success) return;
    }

    _lastWords = '';
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(hours: 1), // 긴 시간 회의 대응
      pauseFor: const Duration(seconds: 10),
      listenOptions: SpeechListenOptions(
        cancelOnError: false,
        partialResults: true,
        listenMode: ListenMode.dictation,
      ),
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;
    _textStreamController.add(_lastWords);
    if (result.finalResult) {
       _talker.debug('[SttService] Final result: $_lastWords');
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  void dispose() {
    _textStreamController.close();
  }
}
