import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/router/route_names.dart';
import '../providers/chat_provider.dart';

class ChatHistorySidebar extends ConsumerWidget {
  const ChatHistorySidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final chatState = ref.watch(chatProvider);
    final sessions = chatState.sessions;

    return Container(
      width: 280,
      color: colorScheme.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.xxl * 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.l),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'History',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      ref.read(chatProvider.notifier).startNewSession(),
                  icon: const Icon(LucideIcons.plusCircle, size: 20),
                  color: colorScheme.primary,
                  tooltip: 'New Chat',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          Expanded(
            child: sessions.isEmpty
                ? Center(
                    child: Text(
                      'No history yet',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: sessions.length,
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.m),
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final isSelected =
                          chatState.sessionId == session.sessionId;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.s),
                        child: InkWell(
                          onTap: () {
                            ref
                                .read(chatProvider.notifier)
                                .loadSession(session.sessionId);
                            if (Scaffold.of(context).isDrawerOpen) {
                              Navigator.pop(context);
                            }
                          },
                          borderRadius: BorderRadius.circular(32),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.l,
                              vertical: AppSizes.m,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.surfaceContainerHigh
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? LucideIcons.messageSquare
                                      : LucideIcons.messageCircle,
                                  size: 18,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: AppSizes.m),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.title,
                                        style: TextStyle(
                                          color: isSelected
                                              ? colorScheme.onSurface
                                              : colorScheme.onSurfaceVariant,
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        _formatDate(session.lastMessageAt),
                                        style: TextStyle(
                                          color: colorScheme.onSurfaceVariant
                                              .withValues(alpha: 0.5),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Bottom Actions
          Padding(
            padding: const EdgeInsets.all(AppSizes.l),
            child: Column(
              children: [
                _SidebarAction(
                  icon: LucideIcons.history,
                  label: 'History & Explore',
                  onTap: () => context.push(RouteNames.history),
                ),
                _SidebarAction(
                  icon: LucideIcons.settings,
                  label: 'System Preferences',
                  onTap: () => context.push(RouteNames.settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.month}/${date.day}';
  }
}

class _SidebarAction extends StatelessWidget {
  const _SidebarAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.m,
          vertical: AppSizes.m,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSizes.m),
            Text(
              label,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
