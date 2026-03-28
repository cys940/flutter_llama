import '../entities/session_entity.dart';

/// 채팅 데이터 영속성을 관리하기 위한 레포지토리 인터페이스입니다.
/// TDD를 위해 추상 클래스로 정의하여 Mocking이 가능하도록 합니다.
abstract class ChatRepository {
  /// 모델 파일을 로드합니다.
  Future<void> loadModel(String modelPath);

  /// 메시지를 전송하고 응답 스트림을 반환합니다.
  Stream<String> sendMessageStream(String text);

  /// 모든 채팅 세션 목록을 반환합니다.
  Future<List<SessionEntity>> getSessions();

  /// 특정 세션의 모든 메시지 목록을 반환합니다.
  Future<List<MessageEntity>> getMessages(String sessionId);

  /// 특정 세션에 새로운 메시지를 저장합니다.
  Future<void> saveMessage(String sessionId, MessageEntity message);

  /// 특정 세션을 삭제합니다.
  Future<void> deleteSession(String sessionId);

  /// 새로운 세션을 생성합니다. (기본 정보 저장)
  Future<void> createSession(SessionEntity session);
}
