import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/chat_provider.dart';
import '../../domain/entities/model_file_entity.dart';
import '../../../../core/theme/app_colors.dart';

class ModelSelectorSheet extends ConsumerWidget {
  const ModelSelectorSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatProvider);
    final notifier = ref.read(chatProvider.notifier);
    final platform = ref.read(platformServiceProvider);
    
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 600;

    // 저장 공간 정보가 없으면 초기화
    if (state.totalDiskSpace == null && !platform.isWeb) {
      Future.microtask(() => notifier.fetchAvailableModels());
    }

    final content = _buildContent(context, state, notifier, platform);

    if (isDesktop) {
      return Center(
        child: Container(
          width: 500,
          height: size.height * 0.7,
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: content,
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: content,
    );
  }

  Widget _buildContent(BuildContext context, dynamic state, dynamic notifier, dynamic platform) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'AI 모델 관리',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(LucideIcons.x, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          platform.isWeb 
              ? '브라우저에서 실행 가능한 최적화된 모델을 선택하세요.'
              : '채팅에 사용할 GGUF 모델을 선택하거나 추가하세요.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        if (!platform.isWeb && !platform.isMacOS)
          _buildStorageInfoCard(context, state.freeDiskSpace, state.totalDiskSpace),
        const SizedBox(height: 24),

        // Verification / Copying Progress Overlay
        if (state.isVerifying) ...[
          _buildVerifyingState(context),
          const SizedBox(height: 24),
        ],
        
        if (state.isCopying) ...[
          _buildCopyProgress(context, state.copyProgress),
          const SizedBox(height: 24),
        ],

        // Model List
        Flexible(
          child: state.availableModels.isEmpty && !state.isVerifying && !state.isCopying
              ? _buildEmptyState(context, notifier)
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: state.availableModels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final model = state.availableModels[index];
                    final isSelected = state.modelPath == model.path;
                    return _buildModelCard(context, model, isSelected, notifier, platform);
                  },
                ),
        ),

        const SizedBox(height: 24),

        // Add Model Button (Hide or change for Web)
        if (!state.isCopying && !state.isVerifying)
          ElevatedButton.icon(
            onPressed: () => notifier.pickAndRegisterModel(context),
            icon: Icon(platform.isWeb ? LucideIcons.uploadCloud : LucideIcons.plus, size: 20),
            label: Text(platform.isWeb ? '브라우저에 모델 파일 불러오기' : '새로운 모델 추가하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ).animate().fadeIn().scale(),
        
        // Error Message
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              state.error!,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
            ),
          ).animate().shake(),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCopyProgress(BuildContext context, double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('모델 파일을 준비 중입니다...', 
                style: TextStyle(fontWeight: FontWeight.w600)),
              Text('${(progress * 100).toStringAsFixed(1)}%'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.surfaceVariant,
              color: AppColors.primary,
              minHeight: 8,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildModelCard(BuildContext context, ModelFileEntity model, bool isSelected, ChatNotifier notifier, dynamic platform) {
    final sizeStr = '${(model.size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';

    return InkWell(
      onTap: () => notifier.selectModel(model),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primary.withValues(alpha: 0.15) 
              : AppColors.surfaceVariant.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSelected ? LucideIcons.check : (platform.isWeb ? LucideIcons.cpu : LucideIcons.box),
                size: 20,
                color: isSelected ? Colors.white : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    platform.isWeb && model.path.startsWith('http') ? '권장 모델 • $sizeStr' : sizeStr,
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ChatNotifier notifier) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 40),
        Icon(LucideIcons.fileSearch, size: 60, 
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.3)),
        const SizedBox(height: 16),
        const Text(
          '등록된 모델이 없습니다.\n모델을 추가하거나 선택해 주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.onSurfaceVariant),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildStorageInfoCard(BuildContext context, double? freeMB, double? totalMB) {
    if (freeMB == null || totalMB == null) return const SizedBox.shrink();
    
    final usedMB = totalMB - freeMB;
    final usedRatio = usedMB / totalMB;
    final isLowSpace = freeMB < 3000;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '기기 저장 공간',
                style: TextStyle(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '여유: ${(freeMB / 1024).toStringAsFixed(1)} GB',
                style: TextStyle(
                  color: isLowSpace ? AppColors.error : AppColors.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usedRatio,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              color: isLowSpace ? AppColors.error : AppColors.primary,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyingState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '모델 데이터 검증 중...',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'GGUF 포맷 및 WebGPU 최적화 상태를 확인하고 있습니다.',
                  style: TextStyle(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().shimmer(duration: 2.seconds, color: Colors.white.withValues(alpha: 0.1));
  }
}
