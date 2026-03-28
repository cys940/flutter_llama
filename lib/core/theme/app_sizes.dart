import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// 디자인 시스템의 공통 간격 및 크기를 정의하는 토큰입니다.
/// 모든 위젯은 이 토큰을 사용하여 일관된 반응형 경험을 제공해야 합니다.
class AppSizes {
  AppSizes._();

  // Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1200.0;

  // Spacing Tokens
  static const double zero = 0.0;
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double s = 12.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Border Radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Content Max Width
  static const double desktopContentMaxWidth = 800.0;
  static const double sidebarWidthTablet = 260.0;
  static const double sidebarWidthDesktop = 300.0;

  /// 현재 화면 크기에 맞는 최적의 패딩을 반환합니다.
  static double responsivePadding(BuildContext context) {
    return context.responsive(
      AppSizes.m, // Mobile
      tablet: AppSizes.l, // Tablet
      desktop: AppSizes.xl, // Desktop
    );
  }

  /// 현재 화면 크기에 맞는 사이드바 너비를 반환합니다.
  static double responsiveSidebarWidth(BuildContext context) {
    return context.isDesktop ? sidebarWidthDesktop : sidebarWidthTablet;
  }
}
