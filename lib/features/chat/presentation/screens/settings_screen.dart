import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'System Preferences',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSizes.xl),
        children: [
          _SectionHeader(title: 'Model Configuration'),
          const SizedBox(height: AppSizes.m),
          _SettingCard(
            icon: LucideIcons.layers,
            title: 'Context Window',
            value: '4096 tokens',
            onTap: () {},
          ),
          _SettingCard(
            icon: LucideIcons.thermometer,
            title: 'Temperature',
            value: '0.7',
            onTap: () {},
            showSlider: true,
          ),
          const SizedBox(height: AppSizes.xl),
          _SectionHeader(title: 'Appearance'),
          const SizedBox(height: AppSizes.m),
          _SettingCard(
            icon: LucideIcons.palette,
            title: 'Theme Mode',
            value: 'Deep Sea (Dark)',
            onTap: () {},
          ),
          _SettingCard(
            icon: LucideIcons.type,
            title: 'Typography',
            value: 'Plus Jakarta Sans',
            onTap: () {},
          ),
          const SizedBox(height: AppSizes.xl),
          _SectionHeader(title: 'System'),
          const SizedBox(height: AppSizes.m),
          _SettingCard(
            icon: LucideIcons.hardDrive,
            title: 'Local Storage',
            value: '2.4 GB used',
            onTap: () {},
          ),
          _SettingCard(
            icon: LucideIcons.info,
            title: 'Version',
            value: '1.0.0-alpha',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant.withOpacity(0.5),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    this.showSlider = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final bool showSlider;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.m),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: AppColors.surfaceHigh,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: AppColors.primary),
                  const SizedBox(width: AppSizes.m),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (showSlider) ...[
                const SizedBox(height: AppSizes.l),
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: const LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
