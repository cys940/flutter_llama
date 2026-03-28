import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/widgets/chat_bubble.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_history_sidebar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
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
        await ref.read(chatProvider.notifier).loadModel(path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Model loaded successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load model: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // 메시지 추가 시 자동 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorScheme.surface,
      drawer: context.isMobile ? const ChatHistorySidebar() : null,
      body: ResponsiveLayout(
        mobile: _ChatBody(
          messageController: _messageController,
          scrollController: _scrollController,
          onPickModel: _pickModel,
          scaffoldKey: _scaffoldKey,
        ),
        tablet: Row(
          children: [
            const ChatHistorySidebar(),
            Expanded(
              child: _ChatBody(
                messageController: _messageController,
                scrollController: _scrollController,
                onPickModel: _pickModel,
                scaffoldKey: _scaffoldKey,
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            const ChatHistorySidebar(),
            Expanded(
              child: Center(
                child: _ChatBody(
                  messageController: _messageController,
                  scrollController: _scrollController,
                  onPickModel: _pickModel,
                  scaffoldKey: _scaffoldKey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBody extends ConsumerWidget {
  const _ChatBody({
    required this.messageController,
    required this.scrollController,
    required this.onPickModel,
    required this.scaffoldKey,
  });

  final TextEditingController messageController;
  final ScrollController scrollController;
  final VoidCallback onPickModel;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatProvider);
    final messages = state.messages;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Glassmorphic SliverAppBar
            SliverAppBar(
              expandedHeight: 140,
              collapsedHeight: 72,
              pinned: true,
              floating: true,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: context.isMobile
                  ? IconButton(
                      icon: const Icon(LucideIcons.menu),
                      onPressed: () => scaffoldKey.currentState?.openDrawer(),
                    )
                  : null,
              flexibleSpace: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24), // 디자인 스펙 반영
                  child: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.symmetric(
                      horizontal: context.isMobile ? AppSizes.m : AppSizes.xl, 
                      vertical: 20,
                    ),
                    centerTitle: false,
                    title: Text(
                      'The Curator',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                if (state.isModelLoaded)
                  IconButton(
                    icon: Icon(LucideIcons.trash2, color: colorScheme.onSurfaceVariant.withOpacity(0.5)),
                    onPressed: () => ref.read(chatProvider.notifier).clearChat(),
                  ),
                const SizedBox(width: AppSizes.s),
              ],
            ),

            if (!state.isModelLoaded)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: AppColors.primaryGradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Icon(
                          state.modelError != null ? LucideIcons.alertTriangle : LucideIcons.brainCircuit,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xl),
                      Text(
                        'The Digital Curator',
                        style: textTheme.displayLarge?.copyWith(
                          fontSize: context.responsive(32.0, tablet: 48.0, desktop: 56.0),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.s),
                      Text(
                        state.isLoading ? 'Awakening intelligence...' : 'Your local, private AI companion',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.xxl),
                      if (!state.isLoading)
                        ElevatedButton(
                          onPressed: onPickModel,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(220, 60),
                            backgroundColor: colorScheme.primaryContainer,
                            foregroundColor: colorScheme.onPrimaryContainer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.plus, size: 18),
                              SizedBox(width: 8),
                              Text('Connect Model', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      if (state.isLoading)
                        const CircularProgressIndicator(strokeWidth: 2),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              )
            else ...[
              // 모델 정보 헤더 (Editorial Style)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.cpu, size: 12, color: colorScheme.primary),
                            const SizedBox(width: 6),
                            Text(
                              state.modelPath?.split('/').last ?? "Active Model",
                              style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 메시지 목록
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final message = messages[index];
                      return ChatBubble(
                        key: ValueKey(message.id),
                        message: message.text,
                        isUser: message.isUser,
                        timestamp: message.timestamp,
                      );
                    },
                    childCount: messages.length,
                  ),
                ),
              ),
              // 하단 여백
              const SliverToBoxAdapter(
                child: SizedBox(height: 120),
              ),
            ],
          ],
        ),

        // 하단 입력부 (Fixed Overlay with Glassmorphism)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              AppSizes.m,
              AppSizes.s,
              AppSizes.m,
              context.responsive(AppSizes.m, tablet: AppSizes.xl) + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface.withOpacity(0.0),
                  colorScheme.surface.withOpacity(0.9),
                  colorScheme.surface,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
            child: AppTextField(
              controller: messageController,
              hintText: state.isModelLoaded ? 'Thinking with you...' : 'The Curator is waiting',
              onSend: () {
                if (state.isModelLoaded && !state.isLoading && messageController.text.isNotEmpty) {
                  ref.read(chatProvider.notifier).sendMessage(messageController.text);
                  messageController.clear();
                }
              },
              onSubmitted: (value) {
                if (state.isModelLoaded && !state.isLoading && value.isNotEmpty) {
                  ref.read(chatProvider.notifier).sendMessage(value);
                  messageController.clear();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
