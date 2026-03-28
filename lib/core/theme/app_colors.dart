import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background & Tonal Hierarchy (VOID)
  static const Color background = Color(0xFF060E20);
  static const Color surface = Color(0xFF060E20); // Base Layer
  static const Color surfaceLow = Color(0xFF091328); // Sidebar / Persistent utility
  static const Color surfaceHigh = Color(0xFF141F38); // Message Bubbles / Cards
  static const Color surfaceHighest = Color(0xFF192540); // Hover / Interaction / Glass Base
  static const Color surfaceVariant = Color(0xFF192540); // For Glassmorphism

  // Primary & Secondary (SPARK & FLOW)
  static const Color primary = Color(0xFF9FA7FF); // Spark Blue (User Bubbles)
  static const Color secondary = Color(0xFF3ADFFA); // Flow Cyan (Accent/Glow)
  static const Color tertiary = Color(0xFFC180FF); // Violet (Thinking)
  
  // Containers (Editorial Surfaces)
  static const Color primaryContainer = Color(0xFF8D98FF); 
  static const Color onPrimaryContainer = Color(0xFF000A7B);
  static const Color secondaryContainer = Color(0xFF006877);
  static const Color onSecondaryContainer = Color(0xFFEAFBFF);

  // Text Tokens (Editorial Authority)
  static const Color onSurface = Color(0xFFDEE5FF); // Primary text (AI output)
  static const Color onSurfaceVariant = Color(0xFFA3AAC4); // Labels / Descriptors
  static const Color onPrimary = Color(0xFF101B8B);
  static const Color onSecondary = Color(0xFF004B56);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF6E84);
  static const Color warning = Color(0xFFFFB2B9); // Softened for dark mode
  
  // Gradients (135-degree Flow)
  static const List<Color> primaryGradient = [Color(0xFF9FA7FF), Color(0xFF3ADFFA)];
  static const List<Color> surfaceGradient = [Color(0xFF091328), Color(0xFF060E20)];

  // Neutrals for subtle effects
  static const Color outline = Color(0xFF6D758C);
  static const Color outlineVariant = Color(0x2640485D); // 15% opacity as per "Ghost Border" rule
}
