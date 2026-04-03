import 'package:flutter/material.dart';

/// Stitch 디자인 시스템의 고유한 토큰들을 플러터 테마와 연결하는 확장 클래스입니다.
/// 이 클래스를 통해 '그림자 농도', '글래스모피즘 투명도', '그래디언트' 등을 일관되게 관리합니다.
class AppDesignSystem extends ThemeExtension<AppDesignSystem> {
  const AppDesignSystem({
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.glassOpacity,
    required this.glassBlur,
    required this.glowColor,
    required this.aiBubbleRadius,
    required this.userBubbleRadius,
    required this.cardShadow,
    required this.focusGlow,
    required this.surfaceRadiusLg,
    required this.surfaceRadiusMd,
    required this.surfaceRadiusSm,
    required this.aiSpringCurve,
    required this.glassOpacityContainer,
    required this.editorialMaxWidth,
    required this.sidebarWidth,
  });

  final List<Color> primaryGradient;
  final List<Color> secondaryGradient;
  final double glassOpacity;
  final double glassBlur;
  final Color glowColor;
  final BorderRadius aiBubbleRadius;
  final BorderRadius userBubbleRadius;
  final BoxShadow cardShadow;
  final BoxShadow focusGlow;
  final double surfaceRadiusLg;
  final double surfaceRadiusMd;
  final double surfaceRadiusSm;
  final Curve aiSpringCurve;
  final double glassOpacityContainer;
  final double editorialMaxWidth;
  final double sidebarWidth;

  @override
  AppDesignSystem copyWith({
    List<Color>? primaryGradient,
    List<Color>? secondaryGradient,
    double? glassOpacity,
    double? glassBlur,
    Color? glowColor,
    BorderRadius? aiBubbleRadius,
    BorderRadius? userBubbleRadius,
    BoxShadow? cardShadow,
    BoxShadow? focusGlow,
    double? surfaceRadiusLg,
    double? surfaceRadiusMd,
    double? surfaceRadiusSm,
    Curve? aiSpringCurve,
    double? glassOpacityContainer,
    double? editorialMaxWidth,
    double? sidebarWidth,
  }) {
    return AppDesignSystem(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      glassBlur: glassBlur ?? this.glassBlur,
      glowColor: glowColor ?? this.glowColor,
      aiBubbleRadius: aiBubbleRadius ?? this.aiBubbleRadius,
      userBubbleRadius: userBubbleRadius ?? this.userBubbleRadius,
      cardShadow: cardShadow ?? this.cardShadow,
      focusGlow: focusGlow ?? this.focusGlow,
      surfaceRadiusLg: surfaceRadiusLg ?? this.surfaceRadiusLg,
      surfaceRadiusMd: surfaceRadiusMd ?? this.surfaceRadiusMd,
      surfaceRadiusSm: surfaceRadiusSm ?? this.surfaceRadiusSm,
      aiSpringCurve: aiSpringCurve ?? this.aiSpringCurve,
      glassOpacityContainer: glassOpacityContainer ?? this.glassOpacityContainer,
      editorialMaxWidth: editorialMaxWidth ?? this.editorialMaxWidth,
      sidebarWidth: sidebarWidth ?? this.sidebarWidth,
    );
  }

  @override
  AppDesignSystem lerp(ThemeExtension<AppDesignSystem>? other, double t) {
    if (other is! AppDesignSystem) return this;
    return AppDesignSystem(
      primaryGradient: [
        Color.lerp(primaryGradient[0], other.primaryGradient[0], t)!,
        Color.lerp(primaryGradient[1], other.primaryGradient[1], t)!,
      ],
      secondaryGradient: [
        Color.lerp(secondaryGradient[0], other.secondaryGradient[0], t)!,
        Color.lerp(secondaryGradient[1], other.secondaryGradient[1], t)!,
      ],
      glassOpacity: (glassOpacity + (other.glassOpacity - glassOpacity) * t),
      glassBlur: (glassBlur + (other.glassBlur - glassBlur) * t),
      glowColor: Color.lerp(glowColor, other.glowColor, t)!,
      aiBubbleRadius: BorderRadius.lerp(aiBubbleRadius, other.aiBubbleRadius, t)!,
      userBubbleRadius: BorderRadius.lerp(userBubbleRadius, other.userBubbleRadius, t)!,
      cardShadow: BoxShadow.lerp(cardShadow, other.cardShadow, t)!,
      focusGlow: BoxShadow.lerp(focusGlow, other.focusGlow, t)!,
      surfaceRadiusLg: (surfaceRadiusLg + (other.surfaceRadiusLg - surfaceRadiusLg) * t),
      surfaceRadiusMd: (surfaceRadiusMd + (other.surfaceRadiusMd - surfaceRadiusMd) * t),
      surfaceRadiusSm: (surfaceRadiusSm + (other.surfaceRadiusSm - surfaceRadiusSm) * t),
      aiSpringCurve: t < 0.5 ? aiSpringCurve : other.aiSpringCurve,
      glassOpacityContainer: (glassOpacityContainer + (other.glassOpacityContainer - glassOpacityContainer) * t),
      editorialMaxWidth: (editorialMaxWidth + (other.editorialMaxWidth - editorialMaxWidth) * t),
      sidebarWidth: (sidebarWidth + (other.sidebarWidth - sidebarWidth) * t),
    );
  }
}

/// [BuildContext]에서 바로 디자인 시스템에 접근할 수 있도록 돕는 확장 메서드입니다.
extension AppDesignSystemX on BuildContext {
  AppDesignSystem get design => Theme.of(this).extension<AppDesignSystem>()!;
}
