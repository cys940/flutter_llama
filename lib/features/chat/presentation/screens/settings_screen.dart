import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_decorators.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'dart:ui';

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

    return CustomScrollView(
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
    );
  }

  Widget _buildAppBar(BuildContext context, ColorScheme colorScheme, TextTheme textTheme) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
      elevation: 0,
      centerTitle: false,
      leading: context.isMobile
          ? IconButton(
              icon: const Icon(LucideIcons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : null,
      title: Row(
        children: [
          SignatureGradient(
            child: Text(
              'Llama AI',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
            ),
            child: Text(
              'Settings',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
          style: GoogleFonts.plusJakartaSans(
            fontSize: context.responsive(36.0, tablet: 48.0, desktop: 56.0),
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Calibrate your digital curator\'s interface and intelligence parameters.',
          style: GoogleFonts.inter(
            color: AppColors.onSurfaceVariant,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
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
        GridView.count(
          crossAxisCount: context.isMobile ? 1 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: context.isMobile ? 1.8 : 2.2,
          children: [
            _buildPreferenceCard(
              colorScheme: colorScheme,
              label: 'THEME MODE',
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.background,
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
            _buildPreferenceCard(
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
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
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
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Column(
                children: [
                  _buildSliderRow(
                    title: 'Creativity Temperature',
                    desc: 'Higher values result in more divergent and creative responses.',
                    value: _temperature,
                    color: AppColors.primary,
                    gradient: AppColors.primaryGradient,
                    onChanged: (v) => setState(() => _temperature = v),
                  ),
                  const SizedBox(height: 48),
                  _buildSliderRow(
                    title: 'Nucleus Sampling (Top-P)',
                    desc: 'Limits word choice to the most probable cumulative percentage.',
                    value: _topP,
                    color: AppColors.tertiary,
                    gradient: [AppColors.secondary, AppColors.tertiary],
                    onChanged: (v) => setState(() => _topP = v),
                  ),
                  const SizedBox(height: 48),
                  _buildModelSelector(colorScheme),
                ],
              ),
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
        _buildSectionTitle(LucideIcons.userCheck, 'Privacy & Safety', AppColors.error),
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
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: -0.5,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPreferenceCard({required ColorScheme colorScheme, required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label, 
            style: GoogleFonts.inter(
              fontSize: 10, 
              fontWeight: FontWeight.w800, 
              letterSpacing: 2.0, 
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildThemeTab(IconData icon, String label, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceHighest : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: isActive ? AppColors.onSurface : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorDot(Color color, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 24,
      height: 24,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isActive ? Border.all(color: AppColors.surfaceHighest, width: 2) : null,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: isActive ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8)] : null,
        ),
      ),
    );
  }

  Widget _buildSliderRow({
    required String title,
    required String desc,
    required double value,
    required Color color,
    required List<Color> gradient,
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
                  Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.onSurface)),
                  const SizedBox(height: 4),
                  Text(desc, style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 14)),
                ],
              ),
            ),
            Text(
              value.toStringAsFixed(2),
              style: GoogleFonts.inter(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 22,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Stack(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 4,
                  width: constraints.maxWidth * value,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
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
          ],
        ),
        if (title == 'Creativity Temperature')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Logical / Precise', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5))),
              Text('Creative / Abstract', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant.withValues(alpha: 0.5))),
            ],
          ),
      ],
    );
  }

  Widget _buildModelSelector(ColorScheme colorScheme) {
    return Row(
      children: [
        _buildModelCard('Llama 3 Ultra', '복잡한 추론 및 분석', true),
        const SizedBox(width: 12),
        _buildModelCard('Llama 3 Pro', '일상적인 대화 및 작업', false),
        const SizedBox(width: 12),
        _buildModelCard('Llama 3 Flash', '빠른 응답 속도 최적화', false),
      ],
    );
  }

  Widget _buildModelCard(String name, String desc, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceHigh : AppColors.surfaceLow.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary.withValues(alpha: 0.4) : AppColors.outlineVariant.withValues(alpha: 0.1),
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: isActive ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 20)] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: isActive ? AppColors.onSurface : AppColors.onSurface.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.8),
                height: 1.2,
              ),
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.inter(color: AppColors.onSurfaceVariant, fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 48,
              height: 24,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceHighest,
                borderRadius: BorderRadius.circular(100),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: value ? AppColors.secondary : AppColors.outline,
                    shape: BoxShape.circle,
                    boxShadow: value ? [BoxShadow(color: AppColors.secondary.withValues(alpha: 0.4), blurRadius: 8)] : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
