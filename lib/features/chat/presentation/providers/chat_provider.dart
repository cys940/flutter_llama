import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/di/injection.dart';
import '../../data/datasources/llama_data_source.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_state.dart';

part 'chat_provider.g.dart';

@riverpod
LlamaDataSource llamaDataSource(Ref ref) => getIt<LlamaDataSource>();

@riverpod
ChatRepository chatRepository(Ref ref) => getIt<ChatRepository>();

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  ChatState build() {
    return const ChatState();
  }

  /// 새로운 세션을 시작합니다.
  Future<void> startNewSession() async {
    final sessionId = const Uuid().v4();
    final newSession = SessionEntity(
      sessionId: sessionId,
      title: 'New Chat',
      createdAt: DateTime.now(),
      lastMessageAt: DateTime.now(),
    );
    
    await ref.read(chatRepositoryProvider).createSession(newSession);
    state = state.copyWith(
      messages: [],
      sessionId: sessionId,
    );
  }

  /// 기존 세션을 로드합니다.
  Future<void> loadSession(String sessionId) async {
    state = state.copyWith(isLoading: true);
    try {
      final messages = await ref.read(chatRepositoryProvider).getMessages(sessionId);
      state = state.copyWith(
        messages: messages,
        sessionId: sessionId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> loadModel(String modelPath) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(chatRepositoryProvider).loadModel(modelPath);
      state = state.copyWith(isLoading: false, isModelLoaded: true);
      
      // 모델 로드 시 세션이 없다면 새로 시작
      if (state.sessionId == null) {
        await startNewSession();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.sessionId == null) return;

    final sessionId = state.sessionId!;
    final userMessage = MessageEntity(
      id: const Uuid().v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // 유저 메시지UI 반영 및 저장
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );
    await ref.read(chatRepositoryProvider).saveMessage(sessionId, userMessage);

    try {
      final repository = ref.read(chatRepositoryProvider);
      final responseStream = repository.sendMessageStream(text);

      var currentAiResponse = '';
      final aiMessageId = const Uuid().v4();

      await for (final chunk in responseStream) {
        currentAiResponse += chunk;
        
        final aiMessage = MessageEntity(
          id: aiMessageId,
          text: currentAiResponse,
          isUser: false,
          timestamp: DateTime.now(),
        );

        final updatedMessages = List<MessageEntity>.from(state.messages);
        final existingIndex = updatedMessages.indexWhere((m) => m.id == aiMessageId);
        
        if (existingIndex != -1) {
          updatedMessages[existingIndex] = aiMessage;
        } else {
          updatedMessages.add(aiMessage);
        }

        state = state.copyWith(messages: updatedMessages);
      }

      // 최종 AI 메시지 저장
      final finalAiMessage = state.messages.last;
      await ref.read(chatRepositoryProvider).saveMessage(sessionId, finalAiMessage);
      
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void clearChat() async {
    if (state.sessionId != null) {
      await ref.read(chatRepositoryProvider).deleteSession(state.sessionId!);
    }
    await startNewSession();
  }
}
