import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../widgets/chat_history_sidebar.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Row(
        children: [
          if (!context.isMobile) const ChatHistorySidebar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(context, colorScheme, textTheme),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 32),
                      _buildDiscoverySection(context, colorScheme, textTheme),
                      const SizedBox(height: 48),
                      _buildRecentSessionsHeader(context, colorScheme, textTheme),
                      const SizedBox(height: 24),
                      _buildSessionList(context, colorScheme, textTheme),
                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: context.isMobile ? _buildMobileNav(context) : null,
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      centerTitle: false,
      title: context.isMobile 
        ? SignatureGradient(
            child: Text('Llama AI', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          )
        : Container(
            width: 400,
            height: 44,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(22),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(LucideIcons.search, size: 18, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search conversations...',
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 13),
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
      actions: [
        IconButton(icon: const Icon(LucideIcons.user), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDiscoverySection(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Discovery', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, fontSize: 28)),
                const SizedBox(height: 4),
                Text('Ignite your curiosity with curated AI templates.', style: textTheme.bodyMedium),
              ],
            ),
            TextButton(
              onPressed: () {}, 
              child: Text('View All', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardCount = context.isDesktop ? 3 : (context.isTablet ? 2 : 1);
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cardCount,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.2,
              children: [
                _buildTemplateCard(
                  context, 
                  'Content Strategy', 
                  'Generate high-impact editorial calendars and social media hooks.',
                  LucideIcons.sparkles,
                  colorScheme.primary,
                ),
                _buildTemplateCard(
                  context, 
                  'Code Architect', 
                  'Debug complex microservices or refactor legacy Python patterns.',
                  LucideIcons.terminal,
                  colorScheme.secondary,
                ),
                _buildTemplateCard(
                  context, 
                  'Mental Models', 
                  'Deconstruct hard problems using First Principles or Inversion techniques.',
                  LucideIcons.brain,
                  colorScheme.tertiary,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTemplateCard(BuildContext context, String title, String desc, IconData icon, Color accent) {
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: accent, size: 24),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(height: 8),
          Text(desc, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13, height: 1.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('TRY TEMPLATE', style: TextStyle(color: accent, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.2)),
              const SizedBox(width: 8),
              Icon(LucideIcons.arrowRight, color: accent, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSessionsHeader(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Text('Recent Sessions', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('24 TOTAL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant, letterSpacing: 1.0)),
        ),
      ],
    );
  }

  Widget _buildSessionList(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        _buildSessionItem(context, 'The Ethics of Neural Networks', 'The discussion focused on how transformers can inadvertently encode biases...', '2m ago', colorScheme.secondary),
        _buildSessionItem(context, 'Quantum Computing 101', 'Exploring the difference between qubits and classical bits, focusing on...', '1h ago', null),
        _buildSessionItem(context, 'Rust Memory Management', 'Deep dive into the borrow checker, ownership principles, and how Rust prevents...', '3h ago', null),
        _buildSessionItem(context, 'Minimalist Design Trends', 'Analyzing the shift from flat design to neo-brutalism and the return of...', 'Oct 12', null),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide(color: AppColors.outlineVariant),
            ),
            child: Text('LOAD OLDER CONVERSATIONS', style: TextStyle(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionItem(BuildContext context, String title, String preview, String time, Color? indicator) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: indicator ?? colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15), overflow: TextOverflow.ellipsis)),
                    Text(time, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(preview, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNav(BuildContext context) {
    return GlassDecorator(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24, top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, LucideIcons.messageCircle, 'CHAT', false),
            _buildNavItem(context, LucideIcons.history, 'HISTORY', true),
            _buildNavItem(context, LucideIcons.compass, 'EXPLORE', false),
            _buildNavItem(context, LucideIcons.settings, 'SETTINGS', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive) {
    final colorScheme = Theme.of(context).colorScheme;
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
             BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.onPrimary, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1.0)),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
      ],
    );
  }
}
