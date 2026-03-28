import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:local_ai_chat/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:local_ai_chat/features/chat/data/datasources/llama_data_source.dart';
import 'package:local_ai_chat/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:local_ai_chat/features/chat/domain/entities/session_entity.dart';
import 'package:local_ai_chat/features/chat/domain/entities/message_entity.dart';

import 'chat_repository_impl_test.mocks.dart';

@GenerateMocks([ChatLocalDataSource, LlamaDataSource])
void main() {
  late MockChatLocalDataSource mockLocalDataSource;
  late MockLlamaDataSource mockLlamaDataSource;
  late ChatRepositoryImpl repository;

  setUp(() {
    mockLocalDataSource = MockChatLocalDataSource();
    mockLlamaDataSource = MockLlamaDataSource();
    repository = ChatRepositoryImpl(
      localDataSource: mockLocalDataSource,
      llamaDataSource: mockLlamaDataSource,
    );
  });

  group('ChatRepositoryImpl TDD Tests', () {
    test('loadModel should delegate to llamaDataSource.init', () async {
      // Arrange
      const modelPath = 'test_path';
      when(mockLlamaDataSource.init(modelPath)).thenAnswer((_) async => {});

      // Act
      await repository.loadModel(modelPath);

      // Assert
      verify(mockLlamaDataSource.init(modelPath)).called(1);
    });

    test('sendMessageStream should delegate to llamaDataSource.generateResponse', () {
      // Arrange
      const text = 'hello';
      final stream = Stream.fromIterable(['hi']);
      when(mockLlamaDataSource.generateResponse(text)).thenAnswer((_) => stream);

      // Act
      final result = repository.sendMessageStream(text);

      // Assert
      expect(result, equals(stream));
      verify(mockLlamaDataSource.generateResponse(text)).called(1);
    });

    test('createSession should delegate to localDataSource', () async {
      // Arrange
      final session = SessionEntity(
        sessionId: '1',
        title: 'test',
        createdAt: DateTime.now(),
        lastMessageAt: DateTime.now(),
      );
      when(mockLocalDataSource.createOrUpdateSession(session)).thenAnswer((_) async => {});

      // Act
      await repository.createSession(session);

      // Assert
      verify(mockLocalDataSource.createOrUpdateSession(session)).called(1);
    });

    test('saveMessage should delegate to localDataSource', () async {
      // Arrange
      const sessionId = '1';
      final message = MessageEntity(
        id: '1',
        text: 'hi',
        isUser: true,
        timestamp: DateTime.now(),
      );
      when(mockLocalDataSource.saveMessage(sessionId, message)).thenAnswer((_) async => {});

      // Act
      await repository.saveMessage(sessionId, message);

      // Assert
      verify(mockLocalDataSource.saveMessage(sessionId, message)).called(1);
    });

    test('getMessages should delegate to localDataSource', () async {
      // Arrange
      const sessionId = '1';
      final messages = [
        MessageEntity(
          id: '1',
          text: 'hi',
          isUser: true,
          timestamp: DateTime.now(),
        )
      ];
      when(mockLocalDataSource.getMessages(sessionId)).thenAnswer((_) async => messages);

      // Act
      final result = await repository.getMessages(sessionId);

      // Assert
      expect(result, equals(messages));
      verify(mockLocalDataSource.getMessages(sessionId)).called(1);
    });
  });
}
