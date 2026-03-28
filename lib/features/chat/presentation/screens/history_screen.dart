import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/responsive_helper.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, colorScheme, textTheme),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 32),
                _buildDiscoverySection(context, colorScheme, textTheme),
                const SizedBox(height: 56),
                _buildRecentSessionsHeader(context, colorScheme, textTheme),
                const SizedBox(height: 24),
                _buildSessionList(context, colorScheme, textTheme),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: context.isMobile ? _buildMobileNav(context) : null,
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    final design = context.design;
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.background.withValues(alpha: 0.8),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 100,
      leading: context.isMobile
          ? IconButton(
              icon: const Icon(LucideIcons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : null,
      title: Row(
        children: [
          if (context.isDesktop) ...[
            const SizedBox(width: 8),
            Text(
              'Explore',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                fontFamily: 'Plus Jakarta Sans',
                letterSpacing: -0.5,
              ),
            ),
          ],
          const Spacer(),
          if (context.isDesktop) ...[
            Container(
              width: 320,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
              ),
              child: const Row(
                children: [
                  Icon(LucideIcons.search, size: 16, color: AppColors.onSurfaceVariant),
                  SizedBox(width: 12),
                  Text(
                    'Search explorations...',
                    style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: design.primaryGradient),
              ),
              child: const Center(
                child: Text('JD', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
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
                Text(
                  'Discovery',
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Curated Templates',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text('View All', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Icon(LucideIcons.chevronRight, size: 14, color: AppColors.onSurfaceVariant),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardCount = context.isDesktop ? 3 : (context.isTablet ? 2 : 1);
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: cardCount,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
              childAspectRatio: context.isDesktop ? 1.0 : 1.4,
              children: [
                _buildTemplateCard(
                  context,
                  'Content Strategy',
                  'Generate editorial calendars and social media hooks.',
                  LucideIcons.sparkles,
                  AppColors.primary,
                ),
                _buildTemplateCard(
                  context,
                  'Code Architect',
                  'Debug complex microservices or refactor legacy patterns.',
                  LucideIcons.terminal,
                  AppColors.secondary,
                ),
                _buildTemplateCard(
                  context,
                  'Mental Models',
                  'Deconstruct problems using first principles.',
                  LucideIcons.brain,
                  AppColors.tertiary,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTemplateCard(BuildContext context, String title, String desc, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: accent, size: 20),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              fontFamily: 'Plus Jakarta Sans',
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSessionsHeader(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Text(
          'Recent Sessions',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '24 Total',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.0),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionList(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        _buildSessionItem(context, 'The Ethics of Neural Networks', 'Transformer biases in LLMs...', '2m ago', AppColors.primary),
        _buildSessionItem(context, 'Quantum Computing 101', 'Qubits vs Classical bits...', '1h ago', null),
        _buildSessionItem(context, 'Rust Memory Management', 'Borrow checker and ownership...', '3h ago', null),
        _buildSessionItem(context, 'Minimalist Design Trends', 'Neo-brutalism and UX...', 'Oct 12', null),
      ],
    );
  }

  Widget _buildSessionItem(BuildContext context, String title, String preview, String time, Color? indicator) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: indicator ?? AppColors.onSurfaceVariant.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.onSurface),
                ),
                Text(
                  preview,
                  style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.bold),
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
            _buildNavItem(context, LucideIcons.messageSquare, 'Chat', false),
            _buildNavItem(context, LucideIcons.history, 'History', true),
            _buildNavItem(context, LucideIcons.compass, 'Explore', false),
            _buildNavItem(context, LucideIcons.settings, 'Settings', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive) {
    if (isActive) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11)),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.onSurfaceVariant.withValues(alpha: 0.6), size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
