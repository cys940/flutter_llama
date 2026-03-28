import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../features/chat/data/datasources/llama_data_source.dart';
import '../../features/chat/domain/entities/action_item.dart';
import '../../features/chat/domain/entities/meeting_metadata.dart';
import '../di/injection.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class MeetingSummaryService {
  final LlamaDataSource _llamaDataSource;
  final Talker _talker = getIt<Talker>();
  final _uuid = const Uuid();

  MeetingSummaryService(this._llamaDataSource);

  Future<MeetingMetadata> summarize(String fullTranscript, Duration duration, DateTime startTime) async {
    _talker.info('[MeetingSummaryService] Starting summarization for transcript length: ${fullTranscript.length}');
    
    final prompt = """
Analyze the following meeting transcript. 
Provide a concise summary and a list of actionable items. 
Return the result in JSON format ONLY:
{
  "summary": "...",
  "actionItems": [
    {"task": "...", "assignee": "...", "dueDate": "YYYY-MM-DD"}
  ]
}

Transcript:
$fullTranscript
""";

    StringBuffer responseBuffer = StringBuffer();
    
    try {
      final responseStream = _llamaDataSource.generateResponse(
        prompt,
        temperature: 0.3, // 명확한 요약을 위해 낮은 온도값 설정
      );

      await for (final chunk in responseStream) {
        responseBuffer.write(chunk);
      }

      final jsonResult = _parseJsonResponse(responseBuffer.toString());
      
      return MeetingMetadata(
        summary: jsonResult['summary'] ?? 'No summary generated.',
        actionItems: (jsonResult['actionItems'] as List? ?? []).map((item) {
          return ActionItem(
            id: _uuid.v4(),
            task: item['task'] ?? 'Unknown task',
            assignee: item['assignee'],
            dueDate: item['dueDate'] != null ? DateTime.tryParse(item['dueDate']) : null,
          );
        }).toList(),
        fullTranscript: fullTranscript,
        duration: duration,
        startTime: startTime,
        endTime: DateTime.now(),
      );
    } catch (e, st) {
      _talker.handle(e, st, '[MeetingSummaryService] Summarization failed');
      return MeetingMetadata(
        summary: 'Failed to generate summary due to an error.',
        actionItems: [],
        fullTranscript: fullTranscript,
        duration: duration,
        startTime: startTime,
        endTime: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> _parseJsonResponse(String rawResponse) {
    try {
      // JSON 시작과 끝 부분을 찾아 파싱 시도 (LLM 보조 텍스트 출력 대비)
      final startIndex = rawResponse.indexOf('{');
      final endIndex = rawResponse.lastIndexOf('}') + 1;
      if (startIndex != -1 && endIndex != -1) {
        final jsonStr = rawResponse.substring(startIndex, endIndex);
        return json.decode(jsonStr) as Map<String, dynamic>;
      }
      return {};
    } catch (e) {
       _talker.error('[MeetingSummaryService] JSON parsing failed: $e');
       return {'summary': rawResponse}; // 실패 시 원문 전체를 요약으로 간주
    }
  }
}
