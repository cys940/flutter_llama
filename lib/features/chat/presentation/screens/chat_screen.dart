import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/widgets/chat_bubble.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../../../../core/widgets/app_logo.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_state.dart';
import '../providers/meeting_provider.dart';
import '../providers/meeting_state.dart';
import '../../../../core/router/route_names.dart';
import 'package:go_router/go_router.dart';
import '../widgets/chat_utility_sidebar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _pickModel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      try {
        // 모바일/데스크톱 공통으로 기본 모델로 등록(복사)하고 로드하도록 변경
        await ref.read(chatProvider.notifier).registerDefaultModel(path);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('모델 설정 실패: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<MeetingState>(meetingProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
      if (next.metadata != null && previous?.metadata == null) {
        context.push(RouteNames.meetingReport);
      }
    });

    return Row(
      children: [
        Expanded(
          child: _ChatBody(
            messageController: _messageController,
            scrollController: _scrollController,
            onPickModel: _pickModel,
            scrollToBottom: _scrollToBottom,
          ),
        ),
        if (context.isDesktop) const ChatUtilitySidebar(),
      ],
    );
  }
}

class _ChatBody extends ConsumerWidget {
  const _ChatBody({
    required this.messageController,
    required this.scrollController,
    required this.onPickModel,
    required this.scrollToBottom,
  });

  final TextEditingController messageController;
  final ScrollController scrollController;
  final VoidCallback onPickModel;
  final VoidCallback scrollToBottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatProvider);
    final messages = state.messages;
    final design = context.design;

    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          reverse: true,
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 140)),

            if (state.isLoading && state.isModelLoaded)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: _buildThinkingState(context, design),
                ),
              ),

            if (state.isModelLoaded && messages.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final message = messages[messages.length - 1 - index];
                      return ChatBubble(
                        key: ValueKey(message.id),
                        message: message.text,
                        isUser: message.isUser,
                        timestamp: message.timestamp,
                        animationDelay: Duration(milliseconds: index * 40),
                      );
                    },
                    childCount: messages.length,
                  ),
                ),
              ),

            if (state.isModelLoaded && messages.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(context, state),
              ),

            if (!state.isModelLoaded)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildWelcomeState(context, state),
              ),

            SliverPersistentHeader(
              pinned: true,
              delegate: _EditorialHeaderDelegate(
                isMobile: context.isMobile,
                modelName: state.modelPath?.split('/').last,
                isModelLoaded: state.isModelLoaded,
                onClearChat: () => ref.read(chatProvider.notifier).clearChat(),
                design: design,
              ),
            ),
          ],
        ),

        _buildFloatingInput(context, state, ref, design),
        _buildMeetingOverlays(context, ref),
      ],
    );
  }

  Widget _buildMeetingOverlays(BuildContext context, WidgetRef ref) {
    final meetingState = ref.watch(meetingProvider);
    
    if (meetingState.isRecording) {
      return Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SignatureGradient(
                child: Icon(LucideIcons.mic, size: 60, color: Colors.white),
              ).animate(onPlay: (controller) => controller.repeat())
               .scale(duration: 1.seconds, begin: const Offset(1, 1), end: const Offset(1.2, 1.2))
               .then()
               .scale(duration: 1.seconds, begin: const Offset(1.2, 1.2), end: const Offset(1, 1)),
              const SizedBox(height: 24),
              const Text('회의 내용을 듣고 있습니다...', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  meetingState.transcript,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 48),
              AppButton(
                text: '회의 종료 및 분석',
                onPressed: () => ref.read(meetingProvider.notifier).stopMeeting(),
                icon: const Icon(LucideIcons.stopCircle),
                width: 200,
              ),
            ],
          ),
        ),
      );
    }

    if (meetingState.isAnalyzing) {
      return Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              const Text('AI가 회의 내용을 분석 중입니다...', style: TextStyle(color: Colors.white, fontSize: 18)),
              const SizedBox(height: 8),
              const Text('요약 및 액션 아이템을 생성하고 있습니다.', style: TextStyle(color: Colors.white54)),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildThinkingState(BuildContext context, AppDesignSystem design) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: Icon(LucideIcons.bot, size: 20, color: AppColors.primary)),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: GlassDecorator(
            borderRadius: design.aiBubbleRadius.copyWith(topLeft: Radius.zero),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Llama is contemplating...',
                    style: TextStyle(
                      color: AppColors.onSurface.withValues(alpha: 0.6),
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(3, (index) => 
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ).animate(onPlay: (c) => c.repeat())
                       .scale(duration: 400.ms, delay: (index * 200).ms, begin: const Offset(1, 1), end: const Offset(1.5, 1.5))
                       .then()
                       .scale(duration: 400.ms, begin: const Offset(1.5, 1.5), end: const Offset(1, 1))
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn();
  }

  Widget _buildEmptyState(BuildContext context, ChatState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLogo(size: 80),
          const SizedBox(height: 32),
          Text(
            'Llama Intelligence',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 8),
          Text(
            'Sophisticated Curator',
            style: TextStyle(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeState(BuildContext context, ChatState state) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLogo(size: 100),
          const SizedBox(height: 32),
          Text(
            'Llama Intelligence',
            style: textTheme.displayLarge?.copyWith(
              fontSize: context.responsive(36.0, tablet: 48.0, desktop: 56.0),
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
          const SizedBox(height: 48),
          if (!state.isLoading)
            AppButton(
              text: context.isMobile ? '기본 모델 설정' : 'Connect Model',
              onPressed: onPickModel,
              useGlow: true,
              width: 220,
              icon: const Icon(LucideIcons.plus, size: 18),
            ).animate().fadeIn(delay: 500.ms).scale(),
          if (state.isLoading) const CircularProgressIndicator(strokeWidth: 2),
        ],
      ),
    );
  }

  Widget _buildFloatingInput(BuildContext context, ChatState state, WidgetRef ref, AppDesignSystem design) {
    return Positioned(
      bottom: 32,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    icon: const Icon(LucideIcons.paperclip, size: 20),
                    onPressed: () {},
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.mic, size: 20),
                    onPressed: () => ref.read(meetingProvider.notifier).startMeeting(),
                    color: Theme.of(context).colorScheme.primary,
                    tooltip: '회의 모드 시작',
                  ),
                  Expanded(
                    child: AppTextField(
                      controller: messageController,
                      hintText: 'Curating thoughts...',
                      onSubmitted: (value) {
                         if (value.isNotEmpty) {
                          ref.read(chatProvider.notifier).sendMessage(value);
                          messageController.clear();
                          scrollToBottom();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildSendButton(context, () {
                    if (messageController.text.isNotEmpty) {
                      ref.read(chatProvider.notifier).sendMessage(messageController.text);
                      messageController.clear();
                      scrollToBottom();
                    }
                  }, design),
                ],
              ),
            ),
          ),
        ).animate().slideY(begin: 1, end: 0, duration: 600.ms, curve: Curves.easeOutBack),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context, VoidCallback onPressed, AppDesignSystem design) {
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
            color: design.primaryGradient[0].withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(LucideIcons.arrowUp, color: Colors.white, size: 22),
        onPressed: onPressed,
      ),
    );
  }
}

class _EditorialHeaderDelegate extends SliverPersistentHeaderDelegate {
  _EditorialHeaderDelegate({
    required this.isMobile,
    this.modelName,
    required this.isModelLoaded,
    required this.onClearChat,
    required this.design,
  });

  final bool isMobile;
  final String? modelName;
  final bool isModelLoaded;
  final VoidCallback onClearChat;
  final AppDesignSystem design;

  @override
  double get minExtent => isMobile ? 80 : 100;
  @override
  double get maxExtent => isMobile ? 120 : 160;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;
    final textTheme = Theme.of(context).textTheme;

    return GlassDecorator(
      blur: design.glassBlur,
      opacity: (design.glassOpacity + (progress * 0.2)).clamp(0.0, 1.0),
      borderRadius: BorderRadius.zero,
      useGhostBorder: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 16 : 40,
          MediaQuery.of(context).padding.top,
          16,
          0,
        ),
        child: Row(
          children: [
            if (isMobile)
              IconButton(
                icon: const Icon(LucideIcons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Llama Intelligence',
                    style: textTheme.headlineSmall?.copyWith(
                      fontSize: (24 - (progress * 4)).clamp(18.0, 24.0),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (isModelLoaded)
                    Opacity(
                      opacity: (1 - (progress * 1.5)).clamp(0.0, 1.0),
                      child: Text(
                        modelName ?? 'Editorial Curator',
                        style: textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isModelLoaded)
              IconButton(
                icon: const Icon(LucideIcons.trash2, size: 20),
                onPressed: onClearChat,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
              ),
            const SizedBox(width: 8),
            const AppLogo(size: 36, animate: false),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _EditorialHeaderDelegate oldDelegate) => true;
}
