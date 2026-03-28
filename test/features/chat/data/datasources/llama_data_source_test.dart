import 'package:flutter_test/flutter_test.dart';
import 'package:llamadart/llamadart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:local_ai_chat/features/chat/data/datasources/llama_data_source.dart';

import 'llama_data_source_test.mocks.dart';

@GenerateMocks([LlamaEngine, ChatSession])
void main() {
  late MockChatSession mockSession;
  late MockLlamaEngine mockEngine;
  late LlamaDataSource dataSource;

  setUp(() {
    mockSession = MockChatSession();
    mockEngine = MockLlamaEngine();
    
    dataSource = LlamaDataSource(mockEngine);
  });

  group('LlamaDataSource TDD Tests', () {
    test('init should load model using the provided path', () async {
      // Arrange
      const modelPath = 'path/to/model.gguf';
      when(mockEngine.loadModel(modelPath)).thenAnswer((_) async => {});

      // Act
      await dataSource.init(modelPath);

      // Assert
      verify(mockEngine.loadModel(modelPath)).called(1);
    });

    test('generateResponse should throw exception if not initialized', () {
      // Act & Assert
      expect(
        () => dataSource.generateResponse('Hello').first,
        throwsA(isA<Exception>()),
      );
    });

    // Note: ChatSession initialization is internal to LlamaDataSource.
    // In actual tests, we might need a more injectable session factory or use a more integration-oriented approach.
    // However, since we're fixing the current test structure:
  });
}
