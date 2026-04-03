import 'package:flutter/material.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive_helper.dart';
import 'design_decorators.dart';

/// 앱 전체에서 사용되는 반응형 공용 버튼 위젯입니다.
/// 디자인 시스템의 AppDesignSystem 토큰을 준수합니다.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.useGlow = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final bool useGlow;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 화면 크기에 따른 가변적 높이와 폰트 크기 계산
    final double buttonHeight =
        context.responsive(48.0, tablet: 54.0, desktop: 56.0);
    final double fontSize = context.responsive(14.0, tablet: 16.0);
    final double iconSpacing =
        context.responsive(AppSizes.xs, tablet: AppSizes.s);

    final actualBgColor = backgroundColor ?? colorScheme.primary;
    final actualFgColor = foregroundColor ?? colorScheme.onPrimary;

    Widget button = SizedBox(
      width: width ?? double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: actualBgColor,
          foregroundColor: actualFgColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(actualFgColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    SizedBox(width: iconSpacing),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );

    if (useGlow && onPressed != null) {
      button = GlowDecorator(
        glowColor: actualBgColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        child: button,
      );
    }

    return button;
  }
}
