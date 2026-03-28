import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive_helper.dart';

/// 채팅 메시지를 표시하는 반응형 버블 위젯입니다.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.timestamp,
  });

  final String message;
  final bool isUser;
  final DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    // 화면 크기에 따른 가변적 수치 계산
    final double fontSize = context.responsive(14.0, tablet: 15.0);
    final double horizontalPadding = context.responsive(AppSizes.m, tablet: AppSizes.l);
    final double verticalPadding = context.responsive(AppSizes.s, tablet: AppSizes.m);
    
    // 버블의 최대 가로폭 조절 (데스크탑에서는 더 좁게 설정하여 가독성 향상)
    final double maxBubbleWidth = context.isDesktop 
        ? 600.0 
        : MediaQuery.of(context).size.width * (context.isTablet ? 0.65 : 0.75);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.xxs, 
        horizontal: context.isMobile ? AppSizes.xs : AppSizes.m,
      ),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, 
              vertical: verticalPadding,
            ),
            constraints: BoxConstraints(maxWidth: maxBubbleWidth),
            decoration: BoxDecoration(
              color: isUser ? AppColors.userBubble : AppColors.aiBubble,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.radiusL),
                topRight: Radius.circular(AppSizes.radiusL),
                bottomLeft: Radius.circular(isUser ? AppSizes.radiusL : AppSizes.xxs),
                bottomRight: Radius.circular(isUser ? AppSizes.xxs : AppSizes.radiusL),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: fontSize,
                height: 1.5,
              ),
            ),
          ),
          if (timestamp != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
              child: Text(
                '${timestamp!.hour}:${timestamp!.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 11,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
