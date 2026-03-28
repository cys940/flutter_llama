import 'package:flutter/material.dart';

/// 화면 크기에 따라 브레이크포인트를 자동으로 계산하고
/// 적절한 값을 반환하는 BuildContext 확장(Extension)입니다.
extension ResponsiveHelper on BuildContext {
  /// 현재 화면의 가로 너비
  double get screenWidth => MediaQuery.of(this).size.width;

  /// 모바일 여부 (< 600px)
  bool get isMobile => screenWidth < 600.0;

  /// 태블릿 여부 (600px ~ 1200px)
  bool get isTablet => screenWidth >= 600.0 && screenWidth < 1200.0;

  /// 데스크탑 여부 (>= 1200px)
  bool get isDesktop => screenWidth >= 1200.0;

  /// 태블릿 이상 여부
  bool get isAtLeastTablet => screenWidth >= 600.0;

  /// 현재 브레이크포인트에 맞는 값을 선택적으로 반환합니다.
  /// 
  /// [mobile] 필수 기본값
  /// [tablet] 태블릿 브레이크포인트 (지정하지 않으면 모바일 값 사용)
  /// [desktop] 데스크탑 브레이크포인트 (지정하지 않으면 태블릿 혹은 모바일 값 사용)
  T responsive<T>(
    T mobile, {
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isAtLeastTablet && tablet != null) return tablet;
    return mobile;
  }
}
