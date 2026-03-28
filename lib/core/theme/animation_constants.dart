import 'package:flutter/material.dart';

class AnimationConstants {
  AnimationConstants._();

  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration long = Duration(milliseconds: 800);
  static const Duration staggered = Duration(milliseconds: 50);

  // Curves
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve editorialCurve = Cubic(0.4, 0, 0.2, 1);
  static const Curve entranceCurve = Curves.easeOutBack;
  static const Curve exitCurve = Curves.easeInCubic;
  static const Curve emphasizeCurve = Curves.elasticOut;

  // Offsets
  static const Offset slideUpStart = Offset(0, 20);
  static const Offset slideDownStart = Offset(0, -20);
}
