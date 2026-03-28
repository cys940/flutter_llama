import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../providers/meeting_provider.dart';
import '../../domain/entities/action_item.dart';

class MeetingDashboardScreen extends ConsumerWidget {
  const MeetingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meetingState = ref.watch(meetingProvider);
    final metadata = meetingState.metadata;

    if (metadata == null) {
      return const Scaffold(
        body: Center(child: Text('표시할 데이터가 없습니다.')),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('회의 리포트'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: context.isMobile
            ? IconButton(
                icon: const Icon(LucideIcons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
            : (Navigator.of(context).canPop()
                ? IconButton(
                    icon: const Icon(LucideIcons.chevronLeft),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null),
      ),
      body: SignatureGradient(
        child: SafeArea(
          child: ResponsiveLayout(
            mobile: _buildContent(context, metadata),
            desktop: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: _buildContent(context, metadata),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic metadata) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, metadata),
          const SizedBox(height: AppSizes.xl),
          _buildSummarySection(context, metadata.summary),
          const SizedBox(height: AppSizes.xl),
          _buildActionItemsSection(context, metadata.actionItems),
          const SizedBox(height: AppSizes.xl),
          _buildTranscriptSection(context, metadata.fullTranscript),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic metadata) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy년 MM월 dd일 HH:mm');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '회의 통계',
          style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: AppSizes.s),
        Row(
          children: [
            _buildStatChip(
              context,
              LucideIcons.calendar,
              metadata.startTime != null ? dateFormat.format(metadata.startTime!) : '-',
            ),
            const SizedBox(width: AppSizes.s),
            _buildStatChip(
              context,
              LucideIcons.clock,
              '${metadata.duration.inMinutes}분 ${metadata.duration.inSeconds % 60}초',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.m, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSizes.xs),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, String summary) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, LucideIcons.fileText, 'AI 요약'),
          const SizedBox(height: AppSizes.m),
          Text(
            summary,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItemsSection(BuildContext context, List<ActionItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, LucideIcons.checkSquare, '액션 아이템 (${items.length})'),
        const SizedBox(height: AppSizes.m),
        if (items.isEmpty)
          const Text('추출된 할 일이 없습니다.')
        else
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.m),
            child: GlassCard(
              padding: const EdgeInsets.all(AppSizes.m),
              child: Row(
                children: [
                  Checkbox(
                    value: item.isCompleted,
                    onChanged: (val) {}, // TODO: 상태 업데이트
                    shape: const CircleBorder(),
                  ),
                  const SizedBox(width: AppSizes.s),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.task,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        if (item.assignee != null || item.dueDate != null)
                          const SizedBox(height: 4),
                        Row(
                          children: [
                            if (item.assignee != null)
                              _buildSubInfo(context, LucideIcons.user, item.assignee!),
                            if (item.dueDate != null) ...[
                              const SizedBox(width: AppSizes.m),
                              _buildSubInfo(context, LucideIcons.calendar, DateFormat('MM/dd').format(item.dueDate!)),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
      ],
    );
  }

  Widget _buildSubInfo(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Theme.of(context).hintColor),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
      ],
    );
  }

  Widget _buildTranscriptSection(BuildContext context, String transcript) {
    return ExpansionTile(
      title: _buildSectionTitle(context, LucideIcons.languages, '전체 전사 내용'),
      tilePadding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSizes.m),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
          child: Text(
            transcript,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontFamily: 'Courier', height: 1.5),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: AppSizes.s),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
