import 'package:injectable/injectable.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/llama_data_source.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDataSource localDataSource;
  final LlamaDataSource llamaDataSource;

  ChatRepositoryImpl({
    required this.localDataSource,
    required this.llamaDataSource,
  });

  @override
  Future<void> loadModel(String modelPath) async {
    return llamaDataSource.init(modelPath);
  }

  @override
  Stream<String> sendMessageStream(
    String text, {
    double? temperature,
    int? maxTokens,
  }) {
    return llamaDataSource.generateResponse(
      text,
      temperature: temperature,
      maxTokens: maxTokens,
    );
  }

  @override
  Future<void> createSession(SessionEntity session) async {
    return localDataSource.createOrUpdateSession(session);
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    return localDataSource.deleteSession(sessionId);
  }

  @override
  Future<List<MessageEntity>> getMessages(String sessionId) async {
    return localDataSource.getMessages(sessionId);
  }

  @override
  Future<List<SessionEntity>> getSessions() async {
    return localDataSource.getSessions();
  }

  @override
  Future<void> saveMessage(String sessionId, MessageEntity message) async {
    return localDataSource.saveMessage(sessionId, message);
  }

  @override
  void resetSession() {
    llamaDataSource.startNewSession();
  }
}
