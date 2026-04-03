import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../../../../core/utils/responsive_helper.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final design = context.design;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildEditorialHeader(context, design, textTheme),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: context.responsive(24.0, tablet: 48.0, desktop: 80.0),
              vertical: 32,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader(context, 'GETTING STARTED', LucideIcons.rocket),
                const SizedBox(height: 20),
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
                const SizedBox(height: 56),
                _buildSectionHeader(context, 'PRIVACY & SAFETY', LucideIcons.shieldCheck),
                const SizedBox(height: 20),
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
                const SizedBox(height: 56),
                _buildSectionHeader(context, 'PERFORMANCE', LucideIcons.zap),
                const SizedBox(height: 20),
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
                const SizedBox(height: 56),
                _buildSectionHeader(context, 'TROUBLESHOOTING', LucideIcons.alertCircle),
                const SizedBox(height: 20),
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
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorialHeader(BuildContext context, AppDesignSystem design, TextTheme textTheme) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _HelpHeaderDelegate(
        design: design,
        textTheme: textTheme,
        isMobile: context.isMobile,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
            letterSpacing: 2.5,
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
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              question,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            iconColor: AppColors.primary,
            collapsedIconColor: AppColors.onSurfaceVariant.withOpacity(0.5),
            childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            expandedAlignment: Alignment.topLeft,
            children: [
              Text(
                answer,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColors.onSurfaceVariant.withOpacity(0.9),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05, end: 0);
  }
}

class _HelpHeaderDelegate extends SliverPersistentHeaderDelegate {
  final AppDesignSystem design;
  final TextTheme textTheme;
  final bool isMobile;

  _HelpHeaderDelegate({
    required this.design,
    required this.textTheme,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double progress = shrinkOffset / maxExtent;
    final double opacity = (1.0 - progress).clamp(0.0, 1.0);
    
    return GlassDecorator(
      blur: progress > 0.1 ? 24 : 0,
      opacity: progress > 0.1 ? 0.8 : 0,
      child: Container(
        height: maxExtent,
        padding: EdgeInsets.fromLTRB(
          isMobile ? 24 : 80,
          MediaQuery.of(context).padding.top + 16,
          24,
          16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppColors.onSurface, AppColors.onSurface.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    'Help & Support',
                    style: textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: isMobile ? 32 : 48,
                      letterSpacing: -1.5,
                      height: 1.0,
                    ),
                  ),
                ),
                const Spacer(),
                if (progress > 0.5)
                  const AppLogo(size: 32, showText: false),
              ],
            ),
            if (opacity > 0) ...[
              const SizedBox(height: 12),
              Opacity(
                opacity: opacity,
                child: Text(
                  'Expert assistance and deep system documentation.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => isMobile ? 200 : 260;

  @override
  double get minExtent => isMobile ? 100 : 120;

  @override
  bool shouldRebuild(covariant _HelpHeaderDelegate oldDelegate) => true;
}
