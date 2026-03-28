import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/utils/responsive_helper.dart';

/// 채팅 히스토리 목록을 표시하는 반응형 사이드바 위젯입니다.
/// 모바일에서는 Drawer로, 태블릿/데스크탑에서는 고정 사이드바로 사용됩니다.
class ChatHistorySidebar extends StatelessWidget {
  const ChatHistorySidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;
    
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
                onPressed: () {},
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
            
            // 채팅 목록 (Placeholder)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.s),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.chat_bubble_outline, size: 20),
                    title: Text(
                      'Chat Session ${index + 1}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: const Text('Last message snippet...', maxLines: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusS),
                    ),
                    onTap: () {
                      if (isMobile) Navigator.pop(context); // Close drawer on mobile
                    },
                  );
                },
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
