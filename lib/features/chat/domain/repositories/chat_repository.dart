import '../entities/chat_message.dart';
import '../entities/chat_session.dart';

abstract interface class ChatRepository {
  /// 로컬 LLM 모델을 로드합니다.
  Future<void> loadModel(String modelPath);

  /// 메시지를 전송하고 응답 스트림을 반환합니다.
  Stream<String> sendMessageStream(String message);

  /// 현재 세션의 메시지 목록을 가져옵니다.
  Future<List<ChatMessage>> getMessages();

  /// 새로운 채팅 세션을 생성합니다.
  Future<ChatSession> createSession();
}
