import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../../domain/constants/prompt_templates.dart';
import '../providers/chat_provider.dart';
import '../providers/settings_provider.dart';

class ChatUtilitySidebar extends ConsumerWidget {
  const ChatUtilitySidebar({super.key});

  static const _recommendationPrompts = PromptTemplates.recommendations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 320,
      color: AppColors.surfaceLow,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Thread Context', colorScheme.primary),
          const SizedBox(height: 16),
          _buildContextCard(context, colorScheme),
          const SizedBox(height: 32),
          _buildSectionHeader(context, 'Recommended Curations', colorScheme.secondary),
          const SizedBox(height: 16),
          _buildRecommendationList(context, colorScheme, ref),
          const Spacer(),
          _buildProPromotion(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Color color) {
    return Text(
      title.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Plus Jakarta Sans',
          ),
    );
  }

  Widget _buildContextCard(BuildContext context, ColorScheme colorScheme) {
    return GlassDecorator(
      borderRadius: BorderRadius.circular(16),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'This conversation explores the intersection of Minimalism and UI/UX Design. Currently analyzing cognitive load patterns.',
          style: TextStyle(
            fontSize: 12,
            height: 1.6,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationList(BuildContext context, ColorScheme colorScheme, WidgetRef ref) {
    return Column(
      children: [
        _buildRecommendItem(context, LucideIcons.fileText, 'Design & Psychology', colorScheme.primary, ref),
        const SizedBox(height: 12),
        _buildRecommendItem(context, LucideIcons.database, 'Cognitive Load Data', colorScheme.secondary, ref),
      ],
    );
  }

  Widget _buildRecommendItem(BuildContext context, IconData icon, String label, Color iconColor, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        final prompt = _recommendationPrompts[label];
        if (prompt != null) {
          await ref.read(settingsProvider.notifier).updateSystemPrompt(prompt);
        }
        await ref.read(chatProvider.notifier).startNewSession();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProPromotion(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surfaceHigh,
            AppColors.surfaceVariant.withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Curator Pro',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Unlock deep-search analysis and long-form synthesis.',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('업그레이드 기능은 준비 중입니다.')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.onSurface,
                foregroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: const Text('Upgrade Now', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
