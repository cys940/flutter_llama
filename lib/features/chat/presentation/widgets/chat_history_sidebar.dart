import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../providers/chat_provider.dart';
import '../providers/sessions_provider.dart';

/// 채팅 히스토리 목록을 표시하는 반응형 사이드바 위젯입니다.
class ChatHistorySidebar extends ConsumerWidget {
  const ChatHistorySidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isMobile = context.isMobile;
    final sessionsAsync = ref.watch(sessionsProvider);
    final currentSessionId = ref.watch(chatProvider).sessionId;
    
    return Container(
      width: isMobile ? null : AppSizes.responsiveSidebarWidth(context),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: isMobile 
            ? null 
            : const Border(right: BorderSide(color: AppColors.surface, width: 1)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사이드바 헤더
            Padding(
              padding: const EdgeInsets.all(AppSizes.m),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.primary),
                  const SizedBox(width: AppSizes.s),
                  Text(
                    'Sessions',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                ],
              ),
            ),
            
            const Divider(color: AppColors.surface, height: 1),
            
            // 새 채팅 버튼
            Padding(
              padding: const EdgeInsets.all(AppSizes.m),
              child: OutlinedButton.icon(
                onPressed: () => ref.read(sessionsProvider.notifier).createNewSession(),
                icon: const Icon(Icons.add),
                label: const Text('New Chat'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.surface),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                ),
              ),
            ),
            
            // 채팅 목록
            Expanded(
              child: sessionsAsync.when(
                data: (sessions) => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    final isSelected = session.sessionId == currentSessionId;

                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: AppColors.surface,
                      leading: Icon(
                        Icons.chat_bubble_outline, 
                        size: 20,
                        color: isSelected ? AppColors.primary : null,
                      ),
                      title: Text(
                        session.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : null,
                        ),
                      ),
                      subtitle: Text(
                        '${session.lastMessageAt.month}/${session.lastMessageAt.day}', 
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: isSelected 
                          ? IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20),
                              onPressed: () => ref.read(sessionsProvider.notifier).deleteSession(session.sessionId),
                            )
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radiusS),
                      ),
                      onTap: () {
                        ref.read(chatProvider.notifier).loadSession(session.sessionId);
                        if (isMobile) Navigator.pop(context);
                      },
                    );
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
            
            // 설정/사용자 프로필 하단 영역
            const Divider(color: AppColors.surface, height: 1),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.surface,
                child: Icon(Icons.person, size: 20),
              ),
              title: const Text('User Name'),
              trailing: const Icon(Icons.settings, size: 20),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
