import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Background & Main Surface (VOID)
  static const Color background = Color(0xFF060E20);
  static const Color surface = Color(0xFF060E20);
  
  // Surface Layers (Tonal Hierarchy)
  static const Color surfaceLow = Color(0xFF091328);     // Sidebar / Sectioning
  static const Color surfaceHigh = Color(0xFF141F38);    // AI Bubbles / Cards
  static const Color surfaceHighest = Color(0xFF192540); // Hover / Interaction
  static const Color surfaceVariant = Color(0xFF192540); // Glass base
  
  // Primary & Secondary (SPARK & FLOW)
  static const Color primary = Color(0xFF9FA7FF);        // Vibrant Indigo
  static const Color primaryContainer = Color(0xFF8D98FF); 
  static const Color secondary = Color(0xFF3ADFFA);      // Cyan
  static const Color tertiary = Color(0xFFC180FF);       // Violet (Thinking)

  // AI & User Bubble Specifics
  static const Color aiBubble = Color(0xFF141F38);       // surfaceHigh
  static const Color userBubble = Color(0xFF8D98FF);     // primaryContainer

  // Text Tokens (Editorial Authority)
  static const Color onSurface = Color(0xFFDEE5FF);      // Primary AI response
  static const Color onSurfaceVariant = Color(0xFFA3AAC4); // Secondary text/Labels
  static const Color onPrimary = Color(0xFF101B8B);
  static const Color onPrimaryContainer = Color(0xFF000A7B);

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFFF6E84);
  static const Color warning = Color(0xFFFF9800);
  
  // Gradients
  static const List<Color> primaryGradient = [Color(0xFF9FA7FF), Color(0xFF3ADFFA)];
}
