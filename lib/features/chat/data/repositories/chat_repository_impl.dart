import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_session.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/llama_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final LlamaDataSource _dataSource;
  final List<ChatMessage> _messages = [];
  final _uuid = const Uuid();

  ChatRepositoryImpl(this._dataSource);

  @override
  Future<void> loadModel(String modelPath) async {
    await _dataSource.init(modelPath);
  }

  @override
  Stream<String> sendMessageStream(String message) async* {
    // 사용자의 메시지를 목록에 추가
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);

    // AI의 응답을 스트림으로 받아오기
    String fullResponse = '';
    await for (final chunk in _dataSource.generateResponse(message)) {
      fullResponse += chunk;
      yield chunk;
    }

    // 최종 응답을 목록에 추가
    final aiMessage = ChatMessage(
      id: _uuid.v4(),
      text: fullResponse,
      isUser: false,
      timestamp: DateTime.now(),
    );
    _messages.add(aiMessage);
  }

  @override
  Future<List<ChatMessage>> getMessages() async {
    return List.unmodifiable(_messages);
  }

  @override
  Future<ChatSession> createSession() async {
    _messages.clear();
    return ChatSession(
      id: _uuid.v4(),
      createdAt: DateTime.now(),
      messages: [],
    );
  }
}
