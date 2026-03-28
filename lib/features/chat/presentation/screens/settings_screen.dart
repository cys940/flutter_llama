import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../widgets/chat_history_sidebar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _temperature = 0.85;
  double _topP = 0.92;
  bool _isTrainingOptOut = true;
  bool _isEncryptionEnabled = true;

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
                  padding: EdgeInsets.symmetric(
                    horizontal: context.responsive(AppSizes.l, tablet: AppSizes.xxl, desktop: 120.0),
                    vertical: 32,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildHeader(textTheme),
                      const SizedBox(height: 48),
                      _buildAppearanceSection(context, colorScheme, textTheme),
                      const SizedBox(height: 64),
                      _buildNeuralParametersSection(context, colorScheme, textTheme),
                      const SizedBox(height: 64),
                      _buildPrivacySection(context, colorScheme, textTheme),
                      const SizedBox(height: 120),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      centerTitle: false,
      title: SignatureGradient(
        child: Text('Llama AI', style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, fontSize: 20)),
      ),
      actions: [
        IconButton(icon: const Icon(LucideIcons.user), onPressed: () {}),
        IconButton(icon: const Icon(LucideIcons.settings, color: AppColors.primary), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'System Preferences',
          style: textTheme.displayLarge?.copyWith(
            fontSize: context.responsive(36.0, tablet: 48.0, desktop: 56.0),
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Calibrate your digital curator\'s interface and intelligence parameters.',
          style: textTheme.bodyLarge?.copyWith(color: AppColors.onSurfaceVariant, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildAppearanceSection(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(LucideIcons.eye, 'Interface Aesthetic', AppColors.secondary),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildPreferenceCard(
                colorScheme: colorScheme,
                label: 'THEME MODE',
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    children: [
                      _buildThemeTab(LucideIcons.moon, 'Midnight', true),
                      _buildThemeTab(LucideIcons.sun, 'Ethereal', false),
                    ],
                  ),
                ),
              ),
            ),
            if (context.isTablet || context.isDesktop) ...[
              const SizedBox(width: 24),
              Expanded(
                child: _buildPreferenceCard(
                  colorScheme: colorScheme,
                  label: 'CORE RESONANCE',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _buildColorDot(AppColors.primary, true),
                          _buildColorDot(AppColors.secondary, false),
                          _buildColorDot(AppColors.tertiary, false),
                          _buildColorDot(AppColors.error, false),
                        ],
                      ),
                      Text(
                        'Indigo Drift', 
                        style: TextStyle(
                          fontSize: 11, 
                          fontWeight: FontWeight.bold, 
                          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildNeuralParametersSection(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(LucideIcons.brain, 'Neural Parameters', AppColors.tertiary),
        const SizedBox(height: 24),
        GlassDecorator(
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                _buildSliderRow(
                  title: 'Creativity Temperature',
                  desc: 'Higher values result in more divergent and creative responses.',
                  value: _temperature,
                  color: AppColors.primary,
                  onChanged: (v) => setState(() => _temperature = v),
                ),
                const SizedBox(height: 48),
                _buildSliderRow(
                  title: 'Nucleus Sampling (Top-P)',
                  desc: 'Limits word choice to the most probable cumulative percentage.',
                  value: _topP,
                  color: AppColors.tertiary,
                  onChanged: (v) => setState(() => _topP = v),
                ),
                const SizedBox(height: 48),
                _buildModelSelector(colorScheme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySection(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(LucideIcons.shieldCheck, 'Privacy & Safety', AppColors.error),
        const SizedBox(height: 24),
        _buildSelectionItem(
          title: 'Training Data Opt-out',
          desc: 'Prevent your conversations from being used to improve our models.',
          value: _isTrainingOptOut,
          onChanged: (v) => setState(() => _isTrainingOptOut = v),
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 12),
        _buildSelectionItem(
          title: 'Enhanced Encryption',
          desc: 'End-to-end encryption for all persistent chat history.',
          value: _isEncryptionEnabled,
          onChanged: (v) => setState(() => _isEncryptionEnabled = v),
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 16),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -0.5)),
      ],
    );
  }

  Widget _buildPreferenceCard({required ColorScheme colorScheme, required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.w900, 
              letterSpacing: 2.0, 
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildThemeTab(IconData icon, String label, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceHighest : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: isActive ? Border.all(color: Colors.white, width: 2) : null,
        boxShadow: isActive ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10)] : null,
      ),
    );
  }

  Widget _buildSliderRow({
    required String title,
    required String desc,
    required double value,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(desc, style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
                ],
              ),
            ),
            Text(value.toStringAsFixed(2), style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 24, fontFeatures: const [FontFeature.tabularFigures()])),
          ],
        ),
        const SizedBox(height: 24),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: AppColors.background,
            thumbColor: Colors.white,
            overlayColor: color.withValues(alpha: 0.1),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 5),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('LOGICAL / PRECISE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.0, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5))),
            Text('CREATIVE / ABSTRACT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.0, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5))),
          ],
        ),
      ],
    );
  }

  Widget _buildModelSelector(ColorScheme colorScheme) {
    return Row(
      children: [
        _buildModelCard('Llama 3 Ultra', 'Complex reasoning', true),
        const SizedBox(width: 12),
        _buildModelCard('Llama 3 Pro', 'Daily tasks', false),
        const SizedBox(width: 12),
        _buildModelCard('Llama 3 Flash', 'Sub-second latency', false),
      ],
    );
  }

  Widget _buildModelCard(String name, String desc, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceHighest.withValues(alpha: 0.5) : AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? AppColors.primary.withValues(alpha: 0.4) : AppColors.outlineVariant),
          boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 20)] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: isActive ? AppColors.primary : AppColors.onSurface)),
            const SizedBox(height: 4),
            Text(desc, style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionItem({
    required String title,
    required String desc,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 13)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value, 
            onChanged: onChanged,
            activeTrackColor: AppColors.secondary.withValues(alpha: 0.5),
            activeThumbColor: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}
