import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../providers/chat_provider.dart';
import '../providers/meeting_provider.dart';

class ChatInput extends ConsumerStatefulWidget {
  const ChatInput({
    super.key,
    required this.messageController,
    required this.scrollToBottom,
  });

  final TextEditingController messageController;
  final VoidCallback scrollToBottom;

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(chatProvider.select((s) => s.isLoading));
    final design = context.design;
    final accentColor = _isFocused ? AppColors.secondary : AppColors.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: GlowDecorator(
            isFocused: _isFocused,
            glowColor: AppColors.primary,
            spread: 4,
            blur: 16,
            borderRadius: BorderRadius.circular(100),
            child: GlassDecorator(
              blur: 24,
              opacity: 0.6,
              borderRadius: BorderRadius.circular(100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(LucideIcons.paperclip, size: 20, color: _isFocused ? AppColors.secondary : null),
                      onPressed: () {},
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    IconButton(
                      icon: Icon(LucideIcons.mic, size: 20, color: accentColor),
                      onPressed: () => ref.read(meetingProvider.notifier).startMeeting(),
                      tooltip: '회의 모드 시작',
                    ),
                    Expanded(
                      child: AppTextField(
                        controller: widget.messageController,
                        focusNode: _focusNode,
                        hintText: 'Curating thoughts...',
                        onSubmitted: (value) => _handleSendMessage(ref, value),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildSendButton(context, () => _handleSendMessage(ref, widget.messageController.text), design, isLoading),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).animate().slideY(begin: 1, end: 0, duration: 600.ms, curve: Curves.easeOutBack),
    );
  }

  void _handleSendMessage(WidgetRef ref, String value) {
    if (value.trim().isNotEmpty) {
      ref.read(chatProvider.notifier).sendMessage(value);
      widget.messageController.clear();
      widget.scrollToBottom();
    }
  }

  Widget _buildSendButton(BuildContext context, VoidCallback onPressed, AppDesignSystem design, bool isLoading) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: design.primaryGradient,
        ),
        boxShadow: [
          BoxShadow(
            color: design.primaryGradient[0].withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: isLoading 
          ? const SizedBox(
              width: 20, 
              height: 20, 
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
            )
          : const Icon(LucideIcons.arrowUp, color: Colors.white, size: 22),
        onPressed: isLoading ? null : onPressed,
      ),
    );
  }
}
