import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../../../../core/utils/responsive_helper.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final design = context.design;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, design),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader(context, 'Getting Started', LucideIcons.rocket),
                const SizedBox(height: 16),
                _buildFaqItem(
                  context,
                  design,
                  'How do I load an AI model?',
                  'Go to Settings > Model Selection and choose a valid GGUF model file from your device storage. Once selected, the system will initialize the Llama engine automatically.',
                ),
                _buildFaqItem(
                  context,
                  design,
                  'What are GGUF models?',
                  'GGUF is a modern file format designed for efficient AI model inference on consumer hardware. You can find various GGUF models on Hugging Face (e.g., Llama-3, Mistral, Phi-3).',
                ),
                const SizedBox(height: 48),
                _buildSectionHeader(context, 'Privacy & Safety', LucideIcons.shieldCheck),
                const SizedBox(height: 16),
                _buildFaqItem(
                  context,
                  design,
                  'Is my data shared externally?',
                  'No. This application runs entirely locally. Your conversations, documents, and model weights never leave your device. There is no cloud processing involved.',
                ),
                _buildFaqItem(
                  context,
                  design,
                  'Where are my chats stored?',
                  'All chat history is stored in a local SQLite database on your device. You can clear your history anytime from the sidebar.',
                ),
                const SizedBox(height: 48),
                _buildSectionHeader(context, 'Performance', LucideIcons.zap),
                const SizedBox(height: 16),
                _buildFaqItem(
                  context,
                  design,
                  'Why is the generation slow?',
                  'Local AI performance depends on your CPU/GPU hardware and the model size. Using smaller models (e.g., 3B or 7B parameters) or higher quantization (Q4_K_M) usually provides faster responses.',
                ),
                _buildFaqItem(
                  context,
                  design,
                  'Does it support GPU acceleration?',
                  'Yes, if your hardware supports it and the underlying Llama implementation is configured for Metal (macOS) or CUDA/Vulkan (Windows/Linux).',
                ),
                const SizedBox(height: 48),
                _buildSectionHeader(context, 'Troubleshooting', LucideIcons.alertCircle),
                const SizedBox(height: 16),
                _buildFaqItem(
                  context,
                  design,
                  'Model fails to load.',
                  'Ensure you have enough free RAM to accommodate the model. If the file is on an external drive, check the connection. Corrupted GGUF files will also fail to initialize.',
                ),
                _buildFaqItem(
                  context,
                  design,
                  'Output is cut off mid-sentence.',
                  'You can adjust the "Maximum Tokens" setting in the chat configuration to allow for longer response generation.',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppDesignSystem design) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.background,
      leading: Builder(
        builder: (context) {
          final bool canPop = Navigator.of(context).canPop();
          if (context.isMobile) {
            return IconButton(
              icon: const Icon(LucideIcons.menu, color: AppColors.onSurface),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          } else if (canPop) {
            return IconButton(
              icon: const Icon(LucideIcons.arrowLeft, color: AppColors.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24, bottom: 20),
        title: Text(
          'Help & FAQ',
          style: (Theme.of(context).textTheme.headlineSmall ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              right: -50,
              top: -20,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.primary.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            const Center(
              child: Opacity(
                opacity: 0.03,
                child: Icon(LucideIcons.helpCircle, size: 240, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1, end: 0);
  }

  Widget _buildFaqItem(
    BuildContext context,
    AppDesignSystem design,
    String question,
    String answer,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GlassDecorator(
        blur: design.glassBlur,
        opacity: design.glassOpacityContainer,
        borderRadius: BorderRadius.circular(design.surfaceRadiusMd),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              question,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            expandedAlignment: Alignment.topLeft,
            children: [
              Text(
                answer,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0);
  }
}
