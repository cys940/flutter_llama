import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:talker_flutter/talker_flutter.dart';
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
  final Talker _talker = getIt<Talker>();

  @override
  ChatState build() {
    // 앱 시작 시 초기 데이터 로드
    Future.microtask(() async {
      await initializeModel();
      await fetchSessions();
    });
    return const ChatState();
  }

  /// 기기 내 세션 목록을 불러옵니다.
  Future<void> fetchSessions() async {
    try {
      final sessions = await ref.read(chatRepositoryProvider).getSessions();
      state = state.copyWith(sessions: sessions, error: null);
    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Failed to fetch sessions');
      state = state.copyWith(error: '채팅 기록을 불러오는 중 오류가 발생했습니다: $e');
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
        _talker.info('[ChatNotifier] Model initialized at $modelPath');
      } else {
        final modelsDir = await modelRepository.getModelsDirectory();
        final errorMsg = '모델 파일을 찾을 수 없습니다. \n다음 경로에 .gguf 파일을 넣어주세요: \n${modelsDir.path}';
        state = state.copyWith(
          isModelLoaded: false,
          modelError: errorMsg,
          isLoading: false,
        );
        _talker.warning('[ChatNotifier] $errorMsg');
      }
    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Error during model initialization');
      state = state.copyWith(
        isModelLoaded: false,
        modelError: '모델 로드 중 오류 발생: $e',
        isLoading: false,
      );
    }
  }

  /// 새로운 세션을 시작합니다.
  Future<void> startNewSession() async {
    try {
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
      
      state = state.copyWith(
        messages: [],
        sessionId: sessionId,
        sessions: [newSession, ...state.sessions],
        error: null,
      );
      
      // 백그라운드에서 최신 정렬 순서등을 반영하기 위해 목록 갱신
      fetchSessions();
    } catch (e, st) {
       _talker.handle(e, st, '[ChatNotifier] Failed to start new session');
       state = state.copyWith(error: '새 대화를 시작할 수 없습니다: $e');
    }
  }

  /// 기존 세션을 로드합니다.
  Future<void> loadSession(String sessionId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final messages = await ref.read(chatRepositoryProvider).getMessages(sessionId);
      
      // 엔진 세션 초기화 (현재는 새 컨텍스트로 시작)
      ref.read(chatRepositoryProvider).resetSession();
      
      state = state.copyWith(
        messages: messages,
        sessionId: sessionId,
        isLoading: false,
      );
    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Failed to load session $sessionId');
      state = state.copyWith(
        isLoading: false,
        error: '대화 내용을 불러올 수 없습니다: $e',
      );
    }
  }

  Future<void> loadModel(String modelPath) async {
    state = state.copyWith(isLoading: true, modelError: null);
    try {
      await ref.read(chatRepositoryProvider).loadModel(modelPath);
      state = state.copyWith(isLoading: false, isModelLoaded: true, modelPath: modelPath);
      _talker.info('[ChatNotifier] Manual model load success: $modelPath');
      
      // 모델 로드 시 세션이 없다면 새로 시작
      if (state.sessionId == null) {
        await startNewSession();
      }
    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Manual model load failed');
      state = state.copyWith(
        isLoading: false,
        modelError: '모델 로드 실패: $e',
      );
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

    try {
      // 유저 메시지 UI 반영 및 저장
      state = state.copyWith(
        messages: [...state.messages, userMessage],
        error: null,
      );
      await ref.read(chatRepositoryProvider).saveMessage(sessionId, userMessage);

      // [New Chat] 제목일 경우 첫 메시지로 제목 업데이트
      // 세션 제목 업데이트를 위해 현재 세션 정보 조회
      final sessionIndex = state.sessions.indexWhere((s) => s.sessionId == sessionId);
      final currentSession = sessionIndex != -1 ? state.sessions[sessionIndex] : null;

      if (currentSession != null && currentSession.title == 'New Chat') {
        final newTitle = text.length > 20 ? '${text.substring(0, 20)}...' : text;
        final updatedSession = currentSession.copyWith(title: newTitle);
        await ref.read(chatRepositoryProvider).createSession(updatedSession);
        await fetchSessions();
      }

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
    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Error sending message');
      state = state.copyWith(
        messages: [...state.messages, MessageEntity(
          id: const Uuid().v4(),
          text: 'Error generating response: $e',
          isUser: false,
          timestamp: DateTime.now(),
        )],
      );
    } finally {
      await fetchSessions(); // 마지막 메시지 시간 업데이트 반영
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await ref.read(chatRepositoryProvider).deleteSession(sessionId);
      await fetchSessions();
      if (state.sessionId == sessionId) {
        state = state.copyWith(sessionId: null, messages: [], error: null);
      }
      _talker.info('[ChatNotifier] Session deleted: $sessionId');
    } catch (e, st) {
       _talker.handle(e, st, '[ChatNotifier] Failed to delete session');
       state = state.copyWith(error: '세션을 삭제할 수 없습니다: $e');
    }
  }

  Future<void> clearChat() async {
    if (state.sessionId != null) {
      await deleteSession(state.sessionId!);
    }
    await startNewSession();
  }

  Future<void> clearAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      for (final session in state.sessions) {
        await ref.read(chatRepositoryProvider).deleteSession(session.sessionId);
      }
      await fetchSessions();
      state = state.copyWith(
        sessionId: null,
        messages: [],
        isLoading: false,
      );
      _talker.info('[ChatNotifier] All sessions cleared');
    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Failed to clear all sessions');
      state = state.copyWith(isLoading: false, error: '모든 세션을 삭제하는 중 오류가 발생했습니다: $e');
    }
  }
}
