import '../../domain/entities/session_entity.dart';

/// 로컬 데이터베이스(sqflite)와의 직접적인 상호작용을 담당하는 데이터 소스 인터페이스입니다.
abstract class ChatLocalDataSource {
  /// 모든 채팅 세션을 DB에서 조회합니다.
  Future<List<SessionEntity>> getSessions();

  /// 특정 세션의 메시지들을 DB에서 조회합니다.
  Future<List<MessageEntity>> getMessages(String sessionId);

  /// 메시지를 DB에 저장합니다.
  Future<void> saveMessage(String sessionId, MessageEntity message);

  /// 세션을 생성하거나 업데이트합니다.
  Future<void> createOrUpdateSession(SessionEntity session);

  /// 세션을 DB에서 삭제합니다.
  Future<void> deleteSession(String sessionId);
}
