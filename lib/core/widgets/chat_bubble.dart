import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_design_system.dart';
import 'design_decorators.dart';

/// Stitch 'Digital Curator' 스타일의 고품질 메시지 버블 위젯입니다.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.timestamp,
    this.animationDelay = Duration.zero,
  });

  final String message;
  final bool isUser;
  final DateTime? timestamp;
  final Duration animationDelay;

  @override
  Widget build(BuildContext context) {
    final design = context.design;

    // Asymmetry 마진 적용: AI 응답은 왼쪽 여백을 더 넓게 주어 에디토리얼 느낌 강조
    final margin = isUser 
        ? const EdgeInsets.fromLTRB(48.0, 6.0, 16.0, 6.0) 
        : const EdgeInsets.fromLTRB(16.0, 6.0, 64.0, 6.0);

    return Padding(
      padding: margin,
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: _buildBubbleContent(context, design),
      ),
    ).animate(delay: animationDelay)
     .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
     .slideY(begin: 0.1, end: 0, duration: 500.ms, curve: design.aiSpringCurve);
  }

  Widget _buildBubbleContent(BuildContext context, AppDesignSystem design) {
    final bubbleChild = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isUser ? AppColors.onPrimary : AppColors.onSurface,
                ),
          ),
          if (timestamp != null) ...[
            const SizedBox(height: 6),
            Text(
              '${timestamp!.hour}:${timestamp!.minute.toString().padLeft(2, '0')} ${timestamp!.hour >= 12 ? 'PM' : 'AM'}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: (isUser ? AppColors.onPrimary : AppColors.onSurfaceVariant)
                        .withValues(alpha: 0.5),
                    fontSize: 10,
                  ),
            ),
          ],
        ],
      ),
    );

    if (isUser) {
      // User Bubble: Signature Gradient
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: design.primaryGradient,
          ),
          borderRadius: design.userBubbleRadius,
          boxShadow: [
            BoxShadow(
              color: design.primaryGradient[0].withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: bubbleChild,
      );
    } else {
      // AI Bubble: Glassmorphism Blur
      return GlassDecorator(
        borderRadius: design.aiBubbleRadius,
        color: AppColors.surfaceHigh,
        opacity: design.glassOpacity,
        blur: design.glassBlur,
        child: bubbleChild,
      );
    }
  }
}
