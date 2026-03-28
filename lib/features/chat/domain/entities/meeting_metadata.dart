import 'package:freezed_annotation/freezed_annotation.dart';
import 'action_item.dart';

part 'meeting_metadata.freezed.dart';
part 'meeting_metadata.g.dart';

@freezed
abstract class MeetingMetadata with _$MeetingMetadata {
  const factory MeetingMetadata({
    required String summary,
    required List<ActionItem> actionItems,
    required String fullTranscript,
    required Duration duration,
    required DateTime? startTime,
    required DateTime? endTime,
  }) = _MeetingMetadata;

  factory MeetingMetadata.fromJson(Map<String, dynamic> json) => _$MeetingMetadataFromJson(json);
}
