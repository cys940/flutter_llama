import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/widgets/chat_bubble.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../providers/chat_provider.dart';
import '../providers/chat_state.dart';
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
            // Desktop context sidebar
            if (context.isDesktop)
              const _ThreadContextSidebar(),
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
    final design = context.design;

    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Ethereal SliverAppBar (No-Line)
            SliverAppBar(
              expandedHeight: 120,
              collapsedHeight: 72,
              pinned: true,
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: context.isMobile
                  ? IconButton(
                      icon: const Icon(LucideIcons.menu),
                      onPressed: () => scaffoldKey.currentState?.openDrawer(),
                    )
                  : null,
              flexibleSpace: GlassDecorator(
                blur: design.glassBlur,
                opacity: 0.8,
                borderRadius: BorderRadius.zero,
                useGhostBorder: false,
                child: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.symmetric(
                    horizontal: context.isMobile ? AppSizes.m : AppSizes.xl,
                    vertical: 20,
                  ),
                  centerTitle: false,
                  title: SignatureGradient(
                    child: Text(
                      'Llama Intelligence',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white, // Gradient will mask this
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                if (state.isModelLoaded)
                   _buildTopActionButton(
                    context, 
                    icon: LucideIcons.trash2, 
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
                      SignatureGradient(
                        child: Icon(
                          state.modelError != null
                              ? LucideIcons.alertTriangle
                              : LucideIcons.brainCircuit,
                          size: 100,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSizes.xl),
                      Text(
                        'The Digital Curator',
                        style: textTheme.displayLarge?.copyWith(
                          fontSize: context.responsive(32.0,
                              tablet: 48.0, desktop: 56.0),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.s),
                      Text(
                        state.isLoading
                            ? 'Awakening intelligence...'
                            : 'Sophisticated curator of data',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.xxl),
                      if (!state.isLoading)
                        AppButton(
                          text: 'Connect Model',
                          onPressed: onPickModel,
                          useGlow: true,
                          width: 220,
                          icon: const Icon(LucideIcons.plus, size: 18),
                        ),
                      if (state.isLoading)
                        const CircularProgressIndicator(strokeWidth: 2),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              )
            else ...[
              // Model Badge
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.xl, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.cpu,
                                size: 12, color: colorScheme.primary),
                            const SizedBox(width: 6),
                            Text(
                              state.modelPath?.split('/').last ??
                                  'Active Model',
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
              // Message List
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
                        avatarUrl: message.isUser 
                          ? 'https://lh3.googleusercontent.com/aida-public/AB6AXuCIlnahtQ7YmkSLL5Gv7q6-RatqdF4qUDU9LYyDYLWzZjZkyDiJH5CJ9ClgmmJ2tWRHUGq1q2ptbKcmajKZqEC31iwkkO3JOP6Tfd58QM3xKwRIT0PeA6e8S3K4YOgE13NtVKPd56KFwGQSI1jNlecyqlpYBb10mzw6AfjkjJC04M3RVK_SEibU4_TrZt7f8IRfig1-TuB2qORA47U9JnnjracyboaTukUvL7vLTrKnE6APLwUWFU9pphfqMHWMgbEsrupqheHBIbJN'
                          : null,
                      );
                    },
                    childCount: messages.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 140),
              ),
            ],
          ],
        ),

        // Floating Command Bar
        Positioned(
          bottom: 24,
          left: 20,
          right: 20,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GlowDecorator(
                    isFocused: true, // Always show subtle glow for premium feel
                    glowColor: colorScheme.primary,
                    spread: 2,
                    blur: 10,
                    child: GlassDecorator(
                      blur: 24,
                      opacity: 0.7,
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            IconButton(
                              icon: Icon(LucideIcons.paperclip, size: 20, color: colorScheme.onSurfaceVariant),
                              onPressed: () {},
                            ),
                            Expanded(
                              child: AppTextField(
                                controller: messageController,
                                hintText: state.isModelLoaded ? 'Message Llama Intelligence...' : 'The Curator is waiting...',
                                onSend: () => _sendMessage(ref, state),
                              ),
                            ),
                            IconButton(
                              icon: Icon(LucideIcons.mic, size: 20, color: colorScheme.onSurfaceVariant),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 4),
                            _buildSendButton(context, () => _sendMessage(ref, state)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'POWERED BY LLAMA INTELLIGENCE • SOPHISTICATED CURATOR',
                    style: TextStyle(
                      fontSize: 9,
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _sendMessage(WidgetRef ref, ChatState state) {
    if (state.isModelLoaded && !state.isLoading && messageController.text.isNotEmpty) {
      ref.read(chatProvider.notifier).sendMessage(messageController.text);
      messageController.clear();
    }
  }

  Widget _buildTopActionButton(BuildContext context, {required IconData icon, required VoidCallback onPressed}) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      icon: Icon(icon, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6), size: 20),
      onPressed: onPressed,
      style: IconButton.styleFrom(
        hoverColor: colorScheme.surfaceContainerHighest,
      ),
    );
  }

  Widget _buildSendButton(BuildContext context, VoidCallback onPressed) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        ),
      ),
      child: IconButton(
        icon: const Icon(LucideIcons.sendHorizontal, color: AppColors.onPrimaryContainer, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}

class _ThreadContextSidebar extends StatelessWidget {
  const _ThreadContextSidebar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 320,
      color: colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.all(AppSizes.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 100), // Match AppBar offset
          Text(
            'THREAD CONTEXT',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 16),
          GlassDecorator(
            opacity: 0.3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'This conversation explores the intersection of Minimalism and UI/UX Design. Currently analyzing cognitive load patterns.',
                style: textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'RECOMMENDED CURATIONS',
            style: textTheme.labelMedium?.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 16),
          _buildCurationItem(context, 'Design & Psychology', LucideIcons.fileText),
          _buildCurationItem(context, 'Cognitive Load Data', LucideIcons.database),
          const Spacer(),
          _buildUpgradeCard(context),
        ],
      ),
    );
  }

  Widget _buildCurationItem(BuildContext context, String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpgradeCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Curator Pro', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          const SizedBox(height: 8),
          Text(
            'Unlock deep-search analysis and long-form synthesis.',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.onSurface,
                foregroundColor: colorScheme.surface,
              ),
              child: const Text('Upgrade Now'),
            ),
          ),
        ],
      ),
    );
  }
}
