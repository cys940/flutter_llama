import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// 화면 크기에 따라 서로 다른 위젯을 렌더링하는 반응형 레이아웃 래퍼입니다.
/// LayoutBuilder를 사용하여 부모 위젯의 제약 조건을 기반으로 결정합니다.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  /// 모바일 화면 (가로폭 < 600px) - 필수
  final Widget mobile;

  /// 태블릿 화면 (600px <= 가로폭 < 1200px) - 선택 (미지정 시 모바일 사용)
  final Widget? tablet;

  /// 데스크탑 화면 (>= 1200px) - 선택 (미지정 시 태블릿 혹은 모바일 사용)
  final Widget? desktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200.0) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= 600.0) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
