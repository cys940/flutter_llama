import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:llamadart/llamadart.dart';
import 'package:local_ai_chat/features/chat/data/datasources/llama_data_source.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'llama_data_source_test.mocks.dart';

@GenerateMocks([LlamaEngine, ChatSession])
void main() {
  late LlamaDataSource dataSource;
  late MockLlamaEngine mockEngine;

  setUpAll(() {
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<Talker>()) {
      getIt.registerSingleton<Talker>(Talker());
    }
  });

  setUp(() {
    mockEngine = MockLlamaEngine();
    dataSource = LlamaDataSource(mockEngine);
  });

  group('LlamaDataSource TDD Tests', () {
    test('init should load model successfully', () async {
      // Arrange
      const modelPath = 'path/to/model.gguf';
      when(mockEngine.loadModel(modelPath)).thenAnswer((_) async {});

      // Act
      await dataSource.init(modelPath);

      // Assert
      verify(mockEngine.loadModel(modelPath)).called(1);
    });

    test('init should throw exception if engine fails to load model', () async {
      // Arrange
      const modelPath = 'invalid/path/model.gguf';
      when(mockEngine.loadModel(modelPath)).thenThrow(Exception('Engine Load Error'));

      // Act & Assert
      expect(
        () => dataSource.init(modelPath),
        throwsA(isA<Exception>()),
      );
    });
  });
}
