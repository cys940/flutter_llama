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
    // 메시지 추가 시 자동 스크롤
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      // 모바일에서만 히스토리 드로어 제공
      drawer: context.isMobile ? const ChatHistorySidebar() : null,
      appBar: AppBar(
        title: const Text(
          'Local AI Chat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: context.isMobile 
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(LucideIcons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.trash2, color: AppColors.textSecondary),
            onPressed: () => ref.read(chatProvider.notifier).clearChat(),
          ),
          const SizedBox(width: AppSizes.s),
        ],
      ),
      body: ResponsiveLayout(
        // 모바일: 전체 화면 채팅
        mobile: _ChatBody(
          messageController: _messageController,
          scrollController: _scrollController,
          onPickModel: _pickModel,
        ),
        // 태블릿 이상: 고정 사이드바 + 채팅 바디
        tablet: Row(
          children: [
            const ChatHistorySidebar(),
            const VerticalDivider(width: 1, color: AppColors.surface),
            Expanded(
              child: _ChatBody(
                messageController: _messageController,
                scrollController: _scrollController,
                onPickModel: _pickModel,
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            const ChatHistorySidebar(),
            const VerticalDivider(width: 1, color: AppColors.surface),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: AppSizes.desktopContentMaxWidth),
                  child: _ChatBody(
                    messageController: _messageController,
                    scrollController: _scrollController,
                    onPickModel: _pickModel,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 채팅 메시지 리스트와 입력창을 포함하는 핵심 바디 위젯입니다.
class _ChatBody extends ConsumerWidget {
  const _ChatBody({
    required this.messageController,
    required this.scrollController,
    required this.onPickModel,
  });

  final TextEditingController messageController;
  final ScrollController scrollController;
  final VoidCallback onPickModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatProvider);
    final messages = state.messages;

    return Column(
      children: [
        if (!state.isModelLoaded)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.brain, size: 64, color: AppColors.primary),
                    const SizedBox(height: AppSizes.l),
                    const Text(
                      'No Model Loaded',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSizes.s),
                    const Text(
                      'Please select a GGUF model file to start chatting.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSizes.xl),
                    ElevatedButton.icon(
                      onPressed: state.isLoading ? null : onPickModel,
                      icon: const Icon(LucideIcons.fileSearch),
                      label: const Text('Select Model'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: AppSizes.m),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(
                  message: message.text,
                  isUser: message.isUser,
                  timestamp: message.timestamp,
                );
              },
            ),
          ),
        
        // 입력부
        Container(
          padding: EdgeInsets.all(context.responsive(AppSizes.m, tablet: AppSizes.l)),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: messageController,
                    hintText: state.isModelLoaded ? 'Type a message...' : 'Load a model first',
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      if (state.isModelLoaded && !state.isLoading && value.isNotEmpty) {
                        ref.read(chatProvider.notifier).sendMessage(value);
                        messageController.clear();
                      }
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.s),
                Container(
                  decoration: BoxDecoration(
                    color: state.isLoading || !state.isModelLoaded
                        ? AppColors.card
                        : AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  child: IconButton(
                    icon: state.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(LucideIcons.send, color: Colors.white),
                    onPressed: state.isLoading || !state.isModelLoaded
                        ? null
                        : () {
                            if (messageController.text.isNotEmpty) {
                              ref.read(chatProvider.notifier).sendMessage(messageController.text);
                              messageController.clear();
                            }
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
