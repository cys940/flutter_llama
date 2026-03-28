import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../providers/chat_provider.dart';

class ChatHistorySidebar extends ConsumerWidget {
  const ChatHistorySidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);
    final sessions = chatState.sessions;
    final design = context.design;

    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFF091328),
        border: Border(right: BorderSide(color: Colors.transparent, width: 0)),
      ),
      child: GlassDecorator(
        blur: design.glassBlur,
        opacity: design.glassOpacity / 2,
        borderRadius: BorderRadius.zero,
        useGhostBorder: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 64),
            _buildHeader(context, ref, design),
            const SizedBox(height: 48),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'HISTORY',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                      letterSpacing: 2.0,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: sessions.isEmpty
                  ? _buildEmptyState(context)
                  : _buildSessionList(context, ref, chatState, sessions, design),
            ),
            _buildBottomActions(context),
          ],
        ),
      ),
    ).animate().slideX(begin: -1, end: 0, duration: 500.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, AppDesignSystem design) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: design.primaryGradient,
                  ),
                ),
                child: const Icon(LucideIcons.droplets, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Llama Intelligence',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: const Color(0xFFDEE5FF),
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                  ),
                  Text(
                    'SOPHISTICATED CURATOR',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                          fontSize: 8,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          InkWell(
            onTap: () => ref.read(chatProvider.notifier).startNewSession(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: design.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: design.primaryGradient[0].withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.plusCircle, size: 18, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'New Chat',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionList(
    BuildContext context,
    WidgetRef ref,
    dynamic chatState,
    dynamic sessions,
    AppDesignSystem design,
  ) {
    return ListView.builder(
      itemCount: sessions.length,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      itemBuilder: (context, index) {
        final session = sessions[index];
        final isSelected = chatState.sessionId == session.sessionId;

        return Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: GlowDecorator(
            isFocused: isSelected,
            glowColor: design.glowColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () {
                ref.read(chatProvider.notifier).loadSession(session.sessionId);
                if (Scaffold.of(context).isDrawerOpen) {
                  Navigator.pop(context);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF141F38)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? LucideIcons.messageSquareText
                          : LucideIcons.messageSquare,
                      size: 18,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        session.title,
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.onSurface
                              : AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 100 + (index * 30))).slideX(begin: -0.1, end: 0);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'No history yet',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
            ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _SidebarAction(
            icon: LucideIcons.settings,
            label: 'Settings',
            onTap: () => context.push(RouteNames.settings),
          ),
          const SizedBox(height: 8),
          _SidebarAction(
            icon: LucideIcons.helpCircle,
            label: 'Help & FAQ',
            onTap: () => context.push(RouteNames.helpFaq),
          ),
        ],
      ),
    );
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
