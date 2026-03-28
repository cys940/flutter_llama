import 'package:flutter/material.dart';
import '../theme/app_sizes.dart';
import '../theme/app_design_system.dart';
import '../utils/responsive_helper.dart';
import 'design_decorators.dart';

/// Stitch 'Digital Curator' 스타일의 메시지 버블 위젯입니다.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.timestamp,
    this.avatarUrl,
  });

  final String message;
  final bool isUser;
  final DateTime? timestamp;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final design = context.design;

    // Editorial Metrics
    final double horizontalPadding = context.responsive(20.0, tablet: 28.0);
    final double verticalPadding = context.responsive(14.0, tablet: 18.0);

    // Intentional Asymmetry: AI 응답 시 왼쪽 여백을 더 넓게 주어 에디토리얼 리듬 생성
    final double sideMargin = context.responsive(AppSizes.m, tablet: AppSizes.xl);
    final double aiLeftMargin = sideMargin * 1.5;

    final double maxBubbleWidth = context.isDesktop
        ? 680.0
        : MediaQuery.of(context).size.width * (context.isTablet ? 0.75 : 0.85);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      // Spring Physics 근사치 (stiffness: 120, damping: 14)
      curve: const ElasticOutCurve(0.8), 
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isUser ? sideMargin : aiLeftMargin,
          16.0,
          isUser ? sideMargin : sideMargin,
          16.0,
        ),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              _buildAvatar(context, isAI: true),
              const SizedBox(width: AppSizes.m),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment:
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  _buildBubble(context, colorScheme, design, horizontalPadding, verticalPadding, maxBubbleWidth),
                  if (timestamp != null) _buildTimestamp(context, colorScheme),
                ],
              ),
            ),
            if (isUser) ...[
              const SizedBox(width: AppSizes.m),
              _buildAvatar(context, isAI: false),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(
    BuildContext context,
    ColorScheme colorScheme,
    AppDesignSystem design,
    double hPadding,
    double vPadding,
    double maxWidth,
  ) {
    final bubbleContent = Container(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: isUser ? colorScheme.primaryContainer : null,
        borderRadius: isUser ? design.userBubbleRadius : design.aiBubbleRadius,
        boxShadow: isUser ? [design.cardShadow] : null,
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isUser ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
          fontSize: context.responsive(15.0, tablet: 16.0),
          height: 1.6,
          letterSpacing: -0.1,
        ),
      ),
    );

    if (isUser) return bubbleContent;

    // AI Bubble은 Glassmorphism 적용
    return GlassDecorator(
      borderRadius: design.aiBubbleRadius,
      color: colorScheme.surfaceContainerHigh,
      opacity: 0.8,
      child: bubbleContent,
    );
  }

  Widget _buildAvatar(BuildContext context, {required bool isAI}) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isAI ? colorScheme.surfaceContainerHigh : null,
        border: Border.all(
          color: isAI ? colorScheme.primary.withValues(alpha: 0.2) : colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ClipOval(
        child: avatarUrl != null
            ? Image.network(avatarUrl!, fit: BoxFit.cover)
            : Center(
                child: Icon(
                  isAI ? Icons.auto_awesome : Icons.person,
                  size: 20,
                  color: isAI ? colorScheme.primary : colorScheme.onSurfaceVariant,
                ),
              ),
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
      child: Text(
        '${timestamp!.hour}:${timestamp!.minute.toString().padLeft(2, '0')} AM',
        style: TextStyle(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
