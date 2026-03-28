import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:local_ai_chat/features/chat/domain/entities/message_entity.dart';
import 'package:local_ai_chat/features/chat/domain/entities/session_entity.dart';
import 'package:local_ai_chat/features/chat/domain/repositories/chat_repository.dart';

@GenerateMocks([ChatRepository])
import 'chat_repository_test.mocks.dart';

void main() {
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
  });

  final tMessage = MessageEntity(
    id: '1',
    text: 'Hello world',
    isUser: true,
    timestamp: DateTime.now(),
  );
  const tSessionId = 'session_1';

  group('saveMessage', () {
    test('should call saveMessage on the repository with correct parameters', () async {
      // arrange
      when(mockChatRepository.saveMessage(any, any))
          .thenAnswer((_) async => Future.value());

      // act
      await mockChatRepository.saveMessage(tSessionId, tMessage);

      // assert
      verify(mockChatRepository.saveMessage(tSessionId, tMessage));
      verifyNoMoreInteractions(mockChatRepository);
    });
  });

  group('getSessions', () {
    test('should return a list of current chat sessions', () async {
      // arrange
      when(mockChatRepository.getSessions())
          .thenAnswer((_) async => []);

      // act
      final result = await mockChatRepository.getSessions();

      // assert
      expect(result, isA<List>());
      verify(mockChatRepository.getSessions());
    });
  });
}
