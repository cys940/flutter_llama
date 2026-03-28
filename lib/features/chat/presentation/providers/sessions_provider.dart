import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/session_entity.dart';
import 'chat_provider.dart';

part 'sessions_provider.g.dart';

@riverpod
class Sessions extends _$Sessions {
  @override
  Future<List<SessionEntity>> build() async {
    return _fetchSessions();
  }

  Future<List<SessionEntity>> _fetchSessions() async {
    final repository = ref.read(chatRepositoryProvider);
    return repository.getSessions();
  }

  /// 새로운 세션을 시작하고 목록을 갱신합니다.
  Future<void> createNewSession() async {
    await ref.read(chatProvider.notifier).startNewSession();
    state = AsyncValue.data(await _fetchSessions());
  }

  /// 세션을 삭제하고 목록을 갱신합니다.
  Future<void> deleteSession(String sessionId) async {
    await ref.read(chatRepositoryProvider).deleteSession(sessionId);
    
    // 현재 세션이 삭제된 것이라면 세션 초기화
    final currentChatState = ref.read(chatProvider);
    if (currentChatState.sessionId == sessionId) {
      await ref.read(chatProvider.notifier).startNewSession();
    }
    
    state = AsyncValue.data(await _fetchSessions());
  }

  /// 세션 목록을 강제 새로고침합니다.
  void refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchSessions());
  }
}
