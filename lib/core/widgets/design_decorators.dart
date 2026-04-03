import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Stitch 'Ethereal Intelligence' 명세에 따른 유리 질감 효과를 적용하는 데코레이터입니다.
class GlassDecorator extends StatelessWidget {
  const GlassDecorator({
    super.key,
    required this.child,
    this.blur = 24.0,
    this.opacity = 0.6,
    this.color = AppColors.surfaceVariant,
    this.borderRadius,
    this.useGhostBorder = true,
  });

  final Widget child;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius? borderRadius;
  final bool useGhostBorder;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(24);
    
    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: opacity),
            borderRadius: effectiveRadius,
            border: useGhostBorder 
                ? Border.all(
                    color: AppColors.outlineVariant.withOpacity(0.15),
                    width: 0.8,
                  ) 
                : null,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.transparent,
                Colors.black.withOpacity(0.05),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// 디자인 가이드에 최적화된 유리 질감 카드 위젯입니다.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GlassDecorator(
      borderRadius: borderRadius,
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

/// 인터랙티브 요소에 Stitch Signature Glow 효과를 부여하는 데코레이터입니다.
class GlowDecorator extends StatelessWidget {
  const GlowDecorator({
    super.key,
    required this.child,
    this.isFocused = false,
    this.glowColor = AppColors.primary,
    this.spread = 2.0,
    this.blur = 16.0,
    this.borderRadius,
  });

  final Widget child;
  final bool isFocused;
  final Color glowColor;
  final double spread;
  final double blur;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(24),
        boxShadow: isFocused 
          ? [
              BoxShadow(
                color: glowColor.withOpacity(0.3),
                spreadRadius: spread,
                blurRadius: blur,
                offset: const Offset(0, 0),
              ),
              BoxShadow(
                color: glowColor.withOpacity(0.1),
                spreadRadius: spread * 2,
                blurRadius: blur * 2,
                offset: const Offset(0, 0),
              ),
            ]
          : [],
      ),
      child: child,
    );
  }
}

/// 버튼이나 아이콘에 Signature 135-degree Gradient를 입히는 데코레이터입니다.
class SignatureGradient extends StatelessWidget {
  const SignatureGradient({
    super.key,
    required this.child,
    this.gradient = AppColors.primaryGradient,
  });

  final Widget child;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight, // 135-degree approximate
        colors: gradient,
      ).createShader(bounds),
      child: child,
    );
  }
}
