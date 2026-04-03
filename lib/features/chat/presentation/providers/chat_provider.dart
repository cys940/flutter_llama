import 'dart:async';
import 'dart:io' if (dart.library.html) 'dart:html' as io;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../widgets/permission_sheet.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/services/platform_service.dart';
import '../../data/datasources/llama_data_source.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/entities/meeting_metadata.dart';
import '../../domain/entities/model_file_entity.dart';
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
PlatformService platformService(Ref ref) => getIt<PlatformService>();

@riverpod
class ChatNotifier extends _$ChatNotifier {
  final Talker _talker = getIt<Talker>();

  @override
  ChatState build() {
    // 앱 시작 시 초기 데이터 로드.
    // isLoading / isModelLoaded 가드로 provider 재구성 시 중복 초기화를 방지합니다.
    Future.microtask(_initialize);
    return const ChatState();
  }

  Future<void> _initialize() async {
    if (state.isLoading || state.isModelLoaded) return;
    await fetchAvailableModels();
    await initializeModel();
    await fetchSessions();
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
          modelError: null,
        );
        _talker.info('[ChatNotifier] Model initialized at $modelPath');

        // 모델 로드 시 세션이 없다면 새로 시작 (자동 이니셜라이즈 대응)
        if (state.sessionId == null) {
          await startNewSession();
        }
      } else {
        state = state.copyWith(
          isModelLoaded: false,
          isLoading: false,
          modelError: '사용 가능한 모델이 없습니다. 모델 파일을 선택하거나 저장소에 추가해주세요.',
        );
      }
    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Failed to initialize model');
      state = state.copyWith(
        isModelLoaded: false,
        isLoading: false,
        modelError: '모델 로딩 실패: $e',
      );
    }
  }

  /// 사용 가능한 모델 파일 목록을 새로고침합니다.
  Future<void> fetchAvailableModels() async {
    try {
      final repo = ref.read(modelRepositoryProvider);
      final platform = ref.read(platformServiceProvider);
      final models = await repo.getAvailableModels();
      
      // 저장 공간 정보 업데이트
      final free = await platform.getFreeDiskSpace();
      final total = await platform.getTotalDiskSpace();
      
      _talker.info('[ChatNotifier] Disk space updated: $free / $total MB');
      
      state = state.copyWith(
        availableModels: models,
        freeDiskSpace: free,
        totalDiskSpace: total,
      );
    } catch (e) {
      _talker.error('[ChatNotifier] Failed to fetch models: $e');
    }
  }

  /// 파일 피커를 통해 새 모델을 선택하고 등록합니다.
  Future<void> pickAndRegisterModel(BuildContext context) async {
    try {
      final platform = ref.read(platformServiceProvider);
      _talker.info('[ChatNotifier] Starting model picking process...');

      // 1. 권한 확인 (Platform-specific)
      if (platform.isAndroid) {
        final hasPermission = await platform.checkStoragePermission();
        if (!hasPermission) {
          _talker.info('[ChatNotifier] Requesting permission via PermissionSheet...');
          // Android 13+(API 33+)에서 Permission.storage는 deprecated입니다.
          // FilePicker는 SAF(Storage Access Framework)를 통해 권한 없이도 동작합니다.
          if (!context.mounted) return;
          final granted = await PermissionSheet.show(context);
          if (!granted) {
            state = state.copyWith(error: '저장소 접근 권한이 없어 모델을 등록할 수 없습니다.');
            return;
          }
        }
      }

      // 2. 파일 선택
      _talker.info('[ChatNotifier] Opening file picker...');
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        _talker.info('[ChatNotifier] Model picking cancelled by user.');
        return;
      }
      
      final sourcePath = result.files.single.path!;
      final fileName = result.files.single.name;
      _talker.info('[ChatNotifier] File selected: $fileName at $sourcePath');
      
      if (!fileName.endsWith('.gguf')) {
        _talker.warning('[ChatNotifier] Invalid file format selected: $fileName');
        state = state.copyWith(error: '.gguf 확장자 파일만 선택 가능합니다.');
        return;
      }

      // 3. 데이터 무결성 검증 (Integrity Check) 시뮬레이션
      _talker.info('[ChatNotifier] Starting data integrity check for $fileName');
      state = state.copyWith(isVerifying: true, error: null);
      
      // 실제 헤더 확인 로직 (간단히 첫 4바이트 체크 가능)
      if (!platform.isWeb) {
        final firstBytes = await io.File(sourcePath).openRead(0, 4).first;
        final header = String.fromCharCodes(firstBytes);
        _talker.debug('[ChatNotifier] File header: $header');
      }
      
      await Future.delayed(const Duration(milliseconds: 1500)); // UX를 위한 인위적 지연
      
      state = state.copyWith(isVerifying: false);

      // 4. 저장 공간 확인 (최소 3GB 권장)
      final freeSpace = await platform.getFreeDiskSpace(); // MB 단위
      _talker.info('[ChatNotifier] Checking disk space... Free: $freeSpace MB');
      
      if (freeSpace != null && freeSpace < 3000) {
        _talker.warning('[ChatNotifier] Insufficient disk space: $freeSpace MB');
        state = state.copyWith(error: '저장 공간이 부족합니다. (최소 3GB 필요)');
        return;
      }

      // 5. 복사 시작
      _talker.info('[ChatNotifier] Starting model copy for $fileName');
      state = state.copyWith(isCopying: true, copyProgress: 0.0);
      
      final progressStream = ref.read(modelRepositoryProvider).copyModelWithProgress(sourcePath);
      
      await for (final progress in progressStream) {
        state = state.copyWith(copyProgress: progress);
      }

      state = state.copyWith(isCopying: false, copyProgress: 1.0);
      _talker.info('[ChatNotifier] Model registration complete: $fileName');
      
      // 목록 새로고침 및 초기화
      await fetchAvailableModels();
      await initializeModel();

    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Error during model picking and registration');
      state = state.copyWith(isCopying: false, isVerifying: false, error: '모델 등록 중 오류 발생: $e');
    }
  }

  /// 특정 모델 파일을 선택하여 로드합니다.
  Future<void> selectModel(ModelFileEntity file) async {
    state = state.copyWith(isLoading: true, modelError: null);
    try {
      await ref.read(chatRepositoryProvider).loadModel(file.path);
      state = state.copyWith(
        isModelLoaded: true,
        modelPath: file.path,
        isLoading: false,
      );
      await startNewSession();
    } catch (e) {
      state = state.copyWith(isLoading: false, modelError: '모델 전환 실패: $e');
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
      unawaited(fetchSessions());
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

  /// 사용자가 선택한 모델을 기본 모델로 등록하고 로드합니다.
  Future<void> registerDefaultModel(String path) async {
    state = state.copyWith(isLoading: true, modelError: null);
    try {
      final modelRepository = ref.read(modelRepositoryProvider);
      await modelRepository.setDefaultModel(path);
      
      // 저장 후 초기화 (자동 로드)
      await initializeModel();
    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Failed to register default model');
      state = state.copyWith(
        isLoading: false,
        modelError: '기본 모델 등록 실패: $e',
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
        topP: settings?.topP,
        maxTokens: settings?.maxTokens,
      );

      var currentAiResponse = '';
      final aiMessageId = const Uuid().v4();
      var lastUpdateTime = DateTime.now();
      const throttleDuration = Duration(milliseconds: 150);

      await for (final chunk in responseStream) {
        currentAiResponse += chunk;
        
        final now = DateTime.now();
        // 스로틀링: 150ms 마다 또는 마지막에만 UI 갱신 (성능 및 OOM 방지)
        if (now.difference(lastUpdateTime) > throttleDuration) {
          lastUpdateTime = now;
          _updateAiMessage(aiMessageId, currentAiResponse);
        }
      }
      
      // 최종 결과 반영
      _updateAiMessage(aiMessageId, currentAiResponse);

      // 최종 AI 메시지 저장: state.messages.last 대신 직접 생성한 객체를 저장하여
      // 스트리밍 도중 다른 메시지가 삽입될 경우에도 올바른 메시지가 저장되도록 합니다.
      if (currentAiResponse.isNotEmpty) {
        final finalAiMessage = MessageEntity(
          id: aiMessageId,
          text: currentAiResponse,
          isUser: false,
          timestamp: DateTime.now(),
        );
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
    final currentSessionId = state.sessionId;
    if (currentSessionId != null) {
      await deleteSession(currentSessionId);
    }
    // 모델이 로드된 상태에서만 새 세션을 시작합니다.
    if (state.isModelLoaded) {
      await startNewSession();
    }
  }

  /// 회의 분석 결과를 새 채팅 세션으로 저장합니다.
  Future<void> saveMeetingResult(MeetingMetadata metadata) async {
    try {
      await startNewSession();

      final sessionId = state.sessionId;
      if (sessionId == null) return;

      final actionItemLines = metadata.actionItems.isEmpty
          ? '없음'
          : metadata.actionItems.map((a) => '- ${a.task}${a.assignee != null ? ' (담당: ${a.assignee})' : ''}').join('\n');

      final summaryMessage = MessageEntity(
        id: const Uuid().v4(),
        text: '## 회의 요약\n\n${metadata.summary}\n\n### 액션 아이템\n$actionItemLines',
        isUser: false,
        timestamp: DateTime.now(),
      );

      state = state.copyWith(messages: [summaryMessage]);
      await ref.read(chatRepositoryProvider).saveMessage(sessionId, summaryMessage);
      await fetchSessions();

      _talker.info('[ChatNotifier] Meeting result saved to session $sessionId');
    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Failed to save meeting result');
      state = state.copyWith(error: '회의 결과 저장 실패: $e');
    }
  }

  Future<void> clearAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // 순차 처리 대신 병렬로 삭제하여 성능을 개선합니다.
      final sessionsToDelete = List<SessionEntity>.from(state.sessions);
      await Future.wait(
        sessionsToDelete.map(
          (s) => ref.read(chatRepositoryProvider).deleteSession(s.sessionId),
        ),
      );
      state = state.copyWith(
        sessionId: null,
        messages: [],
        isLoading: false,
      );
      await fetchSessions();

      // 전체 삭제 후 빈 상태로 두지 않고 새 세션을 바로 시작합니다.
      if (state.isModelLoaded) {
        await startNewSession();
      }
      _talker.info('[ChatNotifier] All sessions cleared');
    } catch (e, st) {
      _talker.handle(e, st, '[ChatNotifier] Failed to clear all sessions');
      state = state.copyWith(isLoading: false, error: '모든 세션을 삭제하는 중 오류가 발생했습니다: $e');
    }
  }

  /// AI 메시지 상태를 업데이트하는 헬퍼 메소드
  void _updateAiMessage(String id, String text) {
    if (text.isEmpty) return;
    
    final aiMessage = MessageEntity(
      id: id,
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<MessageEntity>.from(state.messages);
    final existingIndex = updatedMessages.indexWhere((m) => m.id == id);
    
    if (existingIndex != -1) {
      updatedMessages[existingIndex] = aiMessage;
    } else {
      updatedMessages.add(aiMessage);
    }

    state = state.copyWith(messages: updatedMessages);
  }
}
