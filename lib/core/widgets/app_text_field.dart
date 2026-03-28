import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../utils/responsive_helper.dart';

/// 앱 전체에서 사용되는 반응형 텍스트 필드 위젯입니다.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.autofocus = false,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final double fontSize = context.responsive(14.0, tablet: 16.0);
    final double padding = context.responsive(AppSizes.s, tablet: AppSizes.m);

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      maxLines: maxLines,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          horizontal: padding,
          vertical: padding * 0.75,
        ),
      ),
    );
  }
}
