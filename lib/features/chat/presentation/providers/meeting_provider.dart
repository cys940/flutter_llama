import 'dart:async' show StreamSubscription, unawaited;
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

    unawaited(_sttSubscription?.cancel());
    _sttSubscription = _sttService.textStream.listen((text) {
      state = state.copyWith(transcript: text);
    });

    await _sttService.startListening();
  }

  Future<void> stopMeeting() async {
    if (!state.isRecording) return;

    final finalTranscript = state.transcript;
    final startTime = state.startTime;
    if (startTime == null) {
      state = state.copyWith(
        isRecording: false,
        error: '회의 시작 시간이 기록되지 않았습니다.',
      );
      return;
    }
    final duration = DateTime.now().difference(startTime);

    state = state.copyWith(isRecording: false, isAnalyzing: true);
    await _sttService.stopListening();
    unawaited(_sttSubscription?.cancel());

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

      // 분석 완료 후 채팅 세션에 결과 저장
      await ref.read(chatProvider.notifier).saveMeetingResult(metadata);
      
    } catch (e) {
      state = state.copyWith(
        isAnalyzing: false,
        error: '회의 분석 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 액션 아이템의 완료 상태를 토글합니다.
  /// NOTE: 현재 in-memory only로 동작하며, 앱 재시작 시 상태가 초기화됩니다.
  /// 영속성이 필요할 경우 ChatRepository를 통한 저장 로직 추가가 필요합니다.
  void toggleActionItem(String itemId) {
    final metadata = state.metadata;
    if (metadata == null) return;

    final updatedItems = metadata.actionItems.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    state = state.copyWith(
      metadata: metadata.copyWith(actionItems: updatedItems),
    );
  }

  void resetMeeting() {
    state = const MeetingState();
  }
}
