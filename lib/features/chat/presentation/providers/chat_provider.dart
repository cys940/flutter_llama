import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/di/injection.dart';
import '../../data/datasources/llama_data_source.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/model_repository.dart';
import 'chat_state.dart';
import 'settings_provider.dart';

part 'chat_provider.g.dart';

@riverpod
LlamaDataSource llamaDataSource(Ref ref) => getIt<LlamaDataSource>();

@riverpod
ChatRepository chatRepository(Ref ref) => getIt<ChatRepository>();

@riverpod
ModelRepository modelRepository(Ref ref) => getIt<ModelRepository>();

@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  ChatState build() {
    // 앱 시작 시 초기 데이터 로드
    Future.microtask(() async {
      await initializeModel();
      await fetchSessions();
    });
    return const ChatState();
  }

  /// 기기 내 세선 목록을 불러옵니다.
  Future<void> fetchSessions() async {
    try {
      final sessions = await ref.read(chatRepositoryProvider).getSessions();
      state = state.copyWith(sessions: sessions);
    } catch (e) {
      // 에러 처리 (로그 출력 등)
    }
  }

  /// 기기 내 표준 경로에서 모델을 찾아 로드합니다.
  Future<void> initializeModel() async {
    state = state.copyWith(isLoading: true, modelError: null);
    try {
      final modelRepository = ref.read(modelRepositoryProvider);
      final modelPath = await modelRepository.getModelPath();

      if (modelPath != null) {
        await ref.read(chatRepositoryProvider).loadModel(modelPath);
        state = state.copyWith(
          isModelLoaded: true,
          modelPath: modelPath,
          isLoading: false,
        );
      } else {
        final modelsDir = await modelRepository.getModelsDirectory();
        state = state.copyWith(
          isModelLoaded: false,
          modelError: '모델 파일을 찾을 수 없습니다. \n다음 경로에 .gguf 파일을 넣어주세요: \n${modelsDir.path}',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isModelLoaded: false,
        modelError: '모델 로드 중 오류 발생: $e',
        isLoading: false,
      );
    }
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
    
    // 엔진의 대화 세션 초기화
    ref.read(chatRepositoryProvider).resetSession();
    
    await ref.read(chatRepositoryProvider).createSession(newSession);
    await fetchSessions(); // 목록 갱신
    
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
      
      // 엔진 세션 초기화 (현재는 새 컨텍스트로 시작)
      ref.read(chatRepositoryProvider).resetSession();
      
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
      state = state.copyWith(isLoading: false, isModelLoaded: true, modelPath: modelPath);
      
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

    // [New Chat] 제목일 경우 첫 메시지로 제목 업데이트
    final currentSession = state.sessions.firstWhere((s) => s.sessionId == sessionId);
    if (currentSession.title == 'New Chat') {
      final newTitle = text.length > 20 ? '${text.substring(0, 20)}...' : text;
      final updatedSession = currentSession.copyWith(title: newTitle);
      await ref.read(chatRepositoryProvider).createSession(updatedSession);
      await fetchSessions();
    }

    try {
      final repository = ref.read(chatRepositoryProvider);
      final settings = ref.read(settingsProvider).value;
      
      final responseStream = repository.sendMessageStream(
        text,
        temperature: settings?.temperature,
        maxTokens: settings?.maxTokens,
      );

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
      if (state.messages.isNotEmpty) {
        final finalAiMessage = state.messages.last;
        await ref.read(chatRepositoryProvider).saveMessage(sessionId, finalAiMessage);
      }
      
    } catch (e) {
      state = state.copyWith(
        messages: [...state.messages, MessageEntity(
          id: const Uuid().v4(),
          text: 'Error generating response: $e',
          isUser: false,
          timestamp: DateTime.now(),
        )],
      );
    } finally {
      state = state.copyWith(isLoading: false);
      await fetchSessions(); // 마지막 메시지 시간 업데이트 반영
    }
  }

  void deleteSession(String sessionId) async {
    await ref.read(chatRepositoryProvider).deleteSession(sessionId);
    await fetchSessions();
    if (state.sessionId == sessionId) {
      state = state.copyWith(sessionId: null, messages: []);
    }
  }

  void clearChat() async {
    if (state.sessionId != null) {
      await ref.read(chatRepositoryProvider).deleteSession(state.sessionId!);
    }
    await startNewSession();
  }

  Future<void> clearAll() async {
    state = state.copyWith(isLoading: true);
    for (final session in state.sessions) {
      await ref.read(chatRepositoryProvider).deleteSession(session.sessionId);
    }
    await fetchSessions();
    state = state.copyWith(
      sessionId: null,
      messages: [],
      isLoading: false,
    );
  }
}
