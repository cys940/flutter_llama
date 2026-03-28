import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/meeting_summary_service.dart';
import '../../../../core/services/stt_service.dart';
import 'chat_provider.dart';
import 'meeting_state.dart';

part 'meeting_provider.g.dart';

@riverpod
class MeetingNotifier extends _$MeetingNotifier {
  late final SttService _sttService;
  late final MeetingSummaryService _summaryService;
  StreamSubscription<String>? _sttSubscription;

  @override
  MeetingState build() {
    _sttService = getIt<SttService>();
    _summaryService = getIt<MeetingSummaryService>();
    
    ref.onDispose(() {
      _sttSubscription?.cancel();
    });

    return const MeetingState();
  }

  Future<void> startMeeting() async {
    final hasPermission = await _sttService.initialize();
    if (!hasPermission) {
      state = state.copyWith(error: '마이크 권한이 필요합니다.');
      return;
    }

    state = MeetingState(
      isRecording: true,
      startTime: DateTime.now(),
      transcript: '',
    );

    _sttSubscription?.cancel();
    _sttSubscription = _sttService.textStream.listen((text) {
      state = state.copyWith(transcript: text);
    });

    await _sttService.startListening();
  }

  Future<void> stopMeeting() async {
    if (!state.isRecording) return;

    final finalTranscript = state.transcript;
    final startTime = state.startTime!;
    final duration = DateTime.now().difference(startTime);

    state = state.copyWith(isRecording: false, isAnalyzing: true);
    await _sttService.stopListening();
    _sttSubscription?.cancel();

    try {
      final metadata = await _summaryService.summarize(
        finalTranscript,
        duration,
        startTime,
      );

      state = state.copyWith(
        isAnalyzing: false,
        metadata: metadata,
      );

      // 분석 완료 후 현재 채팅 세션에 결과 저장 (필요 시)
      // ref.read(chatNotifierProvider.notifier).saveMeetingResult(metadata);
      
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        error: '회의 분석 중 오류가 발생했습니다: $e',
      );
    }
  }

  void resetMeeting() {
    state = const MeetingState();
  }
}
