import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_colors.dart';
import '../theme/app_design_system.dart';
import 'design_decorators.dart';

/// Stitch 'Digital Curator' 스타일의 고품질 메시지 버블 위젯입니다.
class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    this.isTyping = false,
    this.timestamp,
    this.animationDelay = Duration.zero,
  });

  final String message;
  final bool isUser;
  final bool isTyping;
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
      child: _buildBubbleContent(context, design),
    ).animate(delay: animationDelay)
     .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
     .slideY(begin: 0.1, end: 0, duration: 500.ms, curve: design.aiSpringCurve);
  }

  Widget _buildBubbleContent(BuildContext context, AppDesignSystem design) {
    if (isUser) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: design.userBubbleRadius,
                boxShadow: [design.cardShadow],
              ),
              child: _buildMessageDisplay(context, isUser),
            ),
          ),
          const SizedBox(width: 16),
          _buildAvatar(context, isUser),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(context, isUser),
          const SizedBox(width: 16),
          Flexible(
            child: GlassDecorator(
              borderRadius: design.aiBubbleRadius,
              color: AppColors.surfaceHigh,
              opacity: design.glassOpacity,
              blur: design.glassBlur,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _buildMessageDisplay(context, isUser),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildMessageDisplay(BuildContext context, bool isUser) {
    if (isTyping) {
      return const _TypingIndicator();
    }

    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isUser ? AppColors.onPrimaryContainer : AppColors.onSurface,
                height: 1.6,
                letterSpacing: 0.2,
                fontFamily: 'Inter',
              ),
        ),
        const SizedBox(height: 12),
        _buildActionRow(context, isUser),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context, bool isUser) {
    final timeStr = timestamp != null 
        ? '${timestamp!.hour}:${timestamp!.minute.toString().padLeft(2, '0')} ${timestamp!.hour >= 12 ? 'PM' : 'AM'}'
        : 'now';

    if (isUser) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.edit, size: 14, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(timeStr, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold)),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(timeStr, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        const Icon(LucideIcons.copy, size: 14, color: AppColors.onSurfaceVariant),
        const SizedBox(width: 12),
        const Icon(LucideIcons.thumbsUp, size: 14, color: AppColors.onSurfaceVariant),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, bool isUser) {
    if (isUser) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCIlnahtQ7YmkSLL5Gv7q6-RatqdF4qUDU9LYyDYLWzZjZkyDiJH5CJ9ClgmmJ2tWRHUGq1q2ptbKcmajKZqEC31iwkkO3JOP6Tfd58QM3xKwRIT0PeA6e8S3K4YOgE13NtVKPd56KFwGQSI1jNlecyqlpYBb10mzw6AfjkjJC04M3RVK_SEibU4_TrZt7f8IRfig1-TuB2qORA47U9JnnjracyboaTukUvL7vLTrKnE6APLwUWFU9pphfqMHWMgbEsrupqheHBIbJN'),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(LucideIcons.bot, size: 20, color: AppColors.primary),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(3, (index) {
          return Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 6),
            decoration: const BoxDecoration(
              color: AppColors.tertiary,
              shape: BoxShape.circle,
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .scale(
             duration: 800.ms, 
             delay: (index * 150).ms, 
             begin: const Offset(0.8, 0.8), 
             end: const Offset(1.2, 1.2),
             curve: Curves.elasticOut,
           )
           .fadeIn(duration: 800.ms);
        }),
      ),
    ).animate().fadeIn();
  }
}
