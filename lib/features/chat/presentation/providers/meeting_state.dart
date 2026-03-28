import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/meeting_metadata.dart';

part 'meeting_state.freezed.dart';

@freezed
abstract class MeetingState with _$MeetingState {
  const factory MeetingState({
    @Default(false) bool isRecording,
    @Default('') String transcript,
    DateTime? startTime,
    @Default(false) bool isAnalyzing,
    MeetingMetadata? metadata,
    String? error,
  }) = _MeetingState;
}
