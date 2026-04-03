import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_design_system.dart';
import '../../features/chat/presentation/widgets/chat_history_sidebar.dart';
import '../../features/chat/presentation/widgets/chat_utility_sidebar.dart';
import 'responsive_layout.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final design = context.design;

    return Scaffold(
      backgroundColor: AppColors.background,
      // 모바일 및 태블릿에서는 사이드바를 드로어로 제공
      drawer: const ResponsiveLayout(
        mobile: ChatHistorySidebar(),
        tablet: ChatHistorySidebar(),
      ),
      body: ResponsiveLayout(
        // 모바일: 단일 콘텐츠 영역
        mobile: child,

        // 태블릿/데스크탑: 3-Pane 구조 시뮬레이션
        desktop: Row(
          children: [
            // 왼쪽: 세션 히스토리 (고정폭)
            SizedBox(
              width: design.sidebarWidth,
              child: const ChatHistorySidebar(),
            ),

            // 중앙: 메인 채팅 스테이지 (유연한 너비 + 최대 너비 제한)
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: design.editorialMaxWidth,
                  ),
                  child: child,
                ),
              ),
            ),

            // 오른쪽: 유틸리티/상세 정보 (데스크탑 전용 옵션 영역)
            SizedBox(
              width: design.sidebarWidth,
              child: const ChatUtilitySidebar(),
            ),
          ],
        ),
      ),
    );
  }
}
