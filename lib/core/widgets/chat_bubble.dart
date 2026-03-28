import 'package:flutter/material.dart';
import '../theme/app_sizes.dart';
import '../theme/animation_constants.dart';
import '../utils/responsive_helper.dart';

/// 채팅 메시지를 표시하는 반응형 버블 위젯입니다. (Concept A: Editorial Curator)
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
    final colorScheme = Theme.of(context).colorScheme;
    
    // 화면 크기에 따른 가변적 수치 계산
    final double fontSize = context.responsive(14.0, tablet: 16.0);
    final double horizontalPadding = context.responsive(20.0, tablet: 28.0);
    final double verticalPadding = context.responsive(14.0, tablet: 18.0);
    
    // 버블의 최대 가로폭 조절
    final double maxBubbleWidth = context.isDesktop 
        ? 650.0 
        : MediaQuery.of(context).size.width * (context.isTablet ? 0.7 : 0.85);

    // 디자인 스펙: Radius lg (2rem = 32px)
    const double borderRadiusLarge = 32.0;
    const double borderRadiusSmall = 8.0;

    return TweenAnimationBuilder<double>(
      duration: AnimationConstants.long, // 더 고품격적인 느낌을 위해 상향
      curve: AnimationConstants.defaultCurve,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)), // 미세한 솟아오름
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: context.isMobile ? AppSizes.s : AppSizes.m,
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
                color: isUser 
                    ? colorScheme.primaryContainer 
                    : colorScheme.surfaceContainerHigh,
                borderRadius: isUser 
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(borderRadiusLarge),
                        topRight: Radius.circular(borderRadiusLarge),
                        bottomLeft: Radius.circular(borderRadiusLarge),
                        bottomRight: Radius.circular(borderRadiusSmall),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(borderRadiusLarge),
                        topRight: Radius.circular(borderRadiusLarge),
                        bottomLeft: Radius.circular(borderRadiusSmall),
                        bottomRight: Radius.circular(borderRadiusLarge),
                      ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isUser 
                      ? colorScheme.onPrimaryContainer 
                      : colorScheme.onSurface,
                  fontSize: fontSize,
                  height: 1.6,
                ),
              ),
            ),
            if (timestamp != null)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12, right: 12),
                child: Text(
                  '${timestamp!.hour}:${timestamp!.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
