import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_design_system.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => FlexThemeData.dark(
        useMaterial3: true,
        colors: const FlexSchemeColor(
          primary: AppColors.primary,
          primaryContainer: AppColors.primaryContainer,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryContainer,
          tertiary: AppColors.tertiary,
          tertiaryContainer: Color(0xFF560094),
          appBarColor: AppColors.surfaceLow,
          error: AppColors.error,
        ),
        surface: AppColors.surface,
        scaffoldBackground: AppColors.background,
        subThemesData: const FlexSubThemesData(
          useTextTheme: true,
          useM2StyleDividerInM3: false,
          adaptiveRemoveElevationTint: FlexAdaptive.all(),
          adaptiveElevationShadowsBack: FlexAdaptive.all(),
          inputDecoratorIsFilled: true,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorRadius: 999, // Full rounded
          inputDecoratorUnfocusedHasBorder: false,
          inputDecoratorFocusedHasBorder: false,
        ),
        visualDensity: VisualDensity.standard,
        fontFamily: GoogleFonts.inter().fontFamily,
      ).copyWith(
        // Editorial Typography System
        textTheme: TextTheme(
          displayLarge: GoogleFonts.plusJakartaSans(
            color: AppColors.onSurface,
            fontSize: 56, // 3.5rem
            fontWeight: FontWeight.bold,
            letterSpacing: -0.02 * 56, // -0.02em tracking
            height: 1.1,
          ),
          headlineLarge: GoogleFonts.plusJakartaSans(
            color: AppColors.onSurface,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.02 * 32,
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            color: AppColors.onSurface,
            fontSize: 24, // 1.5rem
            fontWeight: FontWeight.w600,
            letterSpacing: -0.02 * 24,
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
            height: 1.6,
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
            aiSpringCurve: const Cubic(0.175, 0.885, 0.32, 1.275), // Custom Spring
            glassOpacityContainer: 0.15,
          ),
        ],

        // Input Theme: No-Line Rule & Glass (Customized in Widgets, but defaults here)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant.withValues(alpha: 0.6),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999), 
            borderSide: BorderSide.none, 
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(999),
            borderSide: BorderSide.none,
          ),
          hintStyle: GoogleFonts.inter(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),

        // Interaction Decent (Dividers are hidden)
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
          thickness: 0,
          space: 0,
        ),
      );
}
