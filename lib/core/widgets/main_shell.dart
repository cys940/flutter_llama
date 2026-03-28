import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import '../../features/chat/presentation/widgets/chat_history_sidebar.dart';
import '../theme/app_colors.dart';

/// 앱의 공통 레이아웃을 제공하는 쉘 위젯입니다.
/// 사이드바를 고정하고 내부 콘텐츠(child)만 전동되도록 관리합니다.
class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = context.isMobile;

    return Scaffold(
      backgroundColor: AppColors.background,
      // 모바일에서는 사이드바를 드로어로 제공
      drawer: isMobile ? const ChatHistorySidebar() : null,
      body: Row(
        children: [
          // 데스크톱/태블릿에서는 사이드바를 고정
          if (!isMobile) const ChatHistorySidebar(),
          
          // 메인 콘텐츠 영역
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
