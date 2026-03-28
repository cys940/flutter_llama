import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/router/route_names.dart';

class ChatHistorySidebar extends StatelessWidget {
  const ChatHistorySidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 280,
      color: AppColors.surfaceLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.xxl * 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.l),
            child: Text(
              'History & Explore',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.xl),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.m),
              itemBuilder: (context, index) {
                final isSelected = index == 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.s),
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(32), // ROUND_FULL
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.l,
                        vertical: AppSizes.m,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.surfaceHigh 
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 18,
                            color: isSelected 
                                ? AppColors.primary 
                                : AppColors.onSurfaceVariant,
                          ),
                          const SizedBox(width: AppSizes.m),
                          Expanded(
                            child: Text(
                              'Recent Chat ${index + 1}',
                              style: TextStyle(
                                color: isSelected 
                                    ? AppColors.onSurface 
                                    : AppColors.onSurfaceVariant,
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom Actions
          Padding(
            padding: const EdgeInsets.all(AppSizes.l),
            child: Column(
              children: [
                _SidebarAction(
                  icon: Icons.explore_outlined,
                  label: 'Discovery',
                  onTap: () {},
                ),
                _SidebarAction(
                  icon: Icons.settings_outlined,
                  label: 'System Preferences',
                  onTap: () => context.push(RouteNames.settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarAction extends StatelessWidget {
  const _SidebarAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.m,
          vertical: AppSizes.m,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
            const SizedBox(width: AppSizes.m),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
