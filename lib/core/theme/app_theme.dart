import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          surface: AppColors.surface,
          error: AppColors.error,
          onPrimary: AppColors.onPrimary,
          onSecondary: Colors.black,
          onSurface: AppColors.onSurface,
          onError: Colors.white,
          primaryContainer: AppColors.primaryContainer,
          onPrimaryContainer: AppColors.onPrimaryContainer,
          surfaceContainerLow: AppColors.surfaceLow,
          surfaceContainerHigh: AppColors.surfaceHigh,
          surfaceContainerHighest: AppColors.surfaceHighest,
        ),
        // Plus Jakarta Sans for Headlines, Inter for Body
        textTheme: TextTheme(
          displayLarge: GoogleFonts.plusJakartaSans(
            color: AppColors.onSurface,
            fontSize: 56, // 3.5rem
            fontWeight: FontWeight.bold,
            letterSpacing: -0.02 * 56, // -0.02em tracking
          ),
          headlineSmall: GoogleFonts.plusJakartaSans(
            color: AppColors.onSurface,
            fontSize: 24, // 1.5rem (headline-sm)
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: GoogleFonts.inter(
            color: AppColors.onSurface, 
            fontSize: 16, // 1rem
            height: 1.6,
          ),
          bodyMedium: GoogleFonts.inter(
            color: AppColors.onSurfaceVariant,
            fontSize: 14,
          ),
          labelMedium: GoogleFonts.inter(
            color: AppColors.onSurfaceVariant,
            fontSize: 12, // 0.75rem (label-md)
            fontWeight: FontWeight.w500,
          ),
        ),
        cardTheme: const CardThemeData(
          color: AppColors.surfaceHigh,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant.withOpacity(0.6),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32), // ROUND_FULL
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            elevation: 0,
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
          thickness: 0,
          space: 0,
        ),
      );
}
