import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/llama_data_source.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_state.dart';

part 'chat_provider.g.dart';

@riverpod
LlamaDataSource llamaDataSource(Ref ref) {
  final dataSource = LlamaDataSource();
  ref.onDispose(() => dataSource.dispose());
  return dataSource;
}

@riverpod
ChatRepository chatRepository(Ref ref) {
  final dataSource = ref.watch(llamaDataSourceProvider);
  return ChatRepositoryImpl(dataSource);
}

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  ChatState build() {
    return const ChatState();
  }

  Future<void> loadModel(String modelPath) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(chatRepositoryProvider).loadModel(modelPath);
      state = state.copyWith(isLoading: false, isModelLoaded: true);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      final repository = ref.read(chatRepositoryProvider);
      final responseStream = repository.sendMessageStream(text);

      var currentAiResponse = '';
      final aiMessageId = const Uuid().v4();

      await for (final chunk in responseStream) {
        currentAiResponse += chunk;
        
        // 실시간 스트리밍 UI 업데이트
        final aiMessage = ChatMessage(
          id: aiMessageId,
          text: currentAiResponse,
          isUser: false,
          timestamp: DateTime.now(),
        );

        // 이전 AI 메시지가 있다면 교체, 없으면 추가
        final updatedMessages = List<ChatMessage>.from(state.messages);
        final existingIndex = updatedMessages.indexWhere((m) => m.id == aiMessageId);
        
        if (existingIndex != -1) {
          updatedMessages[existingIndex] = aiMessage;
        } else {
          updatedMessages.add(aiMessage);
        }

        state = state.copyWith(messages: updatedMessages);
      }
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearChat() async {
    await ref.read(chatRepositoryProvider).createSession();
    state = state.copyWith(messages: []);
  }
}
