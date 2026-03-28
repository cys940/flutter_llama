import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_design_system.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        
        // Material 3 ColorScheme Alignment
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: AppColors.onPrimary,
          onSecondary: AppColors.onSecondary,
          onSurface: AppColors.onSurface,
          onSurfaceVariant: AppColors.onSurfaceVariant,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          secondaryContainer: AppColors.secondaryContainer,
          onSecondaryContainer: AppColors.onSecondaryContainer,
          surfaceContainerLow: AppColors.surfaceLow,
          surfaceContainerHigh: AppColors.surfaceHigh,
          surfaceContainerHighest: AppColors.surfaceHighest,
        ),

        // Editorial Typography System
        textTheme: TextTheme(
          displayLarge: GoogleFonts.plusJakartaSans(
            color: AppColors.onSurface,
            fontSize: 56, // 3.5rem
            fontWeight: FontWeight.bold,
            letterSpacing: -0.02 * 56, // -0.02em tracking
            height: 1.1,
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            color: AppColors.onSurface,
            fontSize: 24, // 1.5rem
            fontWeight: FontWeight.w600,
            letterSpacing: -0.01 * 24,
          ),
          bodyLarge: GoogleFonts.inter(
            color: AppColors.onSurface,
            fontSize: 16, // 1rem
            height: 1.6, // 1.6 line-height for readability
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: GoogleFonts.inter(
            color: AppColors.onSurfaceVariant,
            fontSize: 14,
            height: 1.5,
          ),
          labelMedium: GoogleFonts.inter(
            color: AppColors.onSurfaceVariant,
            fontSize: 12, // 0.75rem
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),

        // Component Extensions
        extensions: [
          AppDesignSystem(
            primaryGradient: AppColors.primaryGradient,
            glassOpacity: 0.6,
            glassBlur: 24.0,
            glowColor: AppColors.primary.withValues(alpha: 0.2),
            aiBubbleRadius: BorderRadius.circular(32), // lg
            userBubbleRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(8), // sm indicating origin
            ),
            cardShadow: BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            surfaceRadiusLg: 48.0, // rounded-xl for containers
            surfaceRadiusMd: 24.0, 
            surfaceRadiusSm: 12.0,
          ),
        ],

        // Input Theme: No-Line Rule
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant.withValues(alpha: 0.6),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999), // full rounded
            borderSide: BorderSide.none, // Absolute No-Line
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none, // We use Glow instead of border
          ),
          hintStyle: GoogleFonts.inter(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),

        // Action Components
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),

        // Interaction Decent (Dividers are hidden)
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
          thickness: 0,
          space: 0,
        ),
        
        // Sidebar / Scaffolding
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColors.surfaceLow,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(48),
              bottomRight: Radius.circular(48),
            ),
          ),
        ),
      );
}
