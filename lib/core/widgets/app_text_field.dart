import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_design_system.dart';
import 'design_decorators.dart';

/// 앱 전체에서 사용되는 고품질 Kinetic 스타일의 텍스트 필드입니다.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onSubmitted,
    this.autofocus = false,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool autofocus;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final design = context.design;
    final textTheme = Theme.of(context).textTheme;

    return GlowDecorator(
      isFocused: _isFocused,
      glowColor: design.glowColor,
      borderRadius: BorderRadius.circular(999),
      child: GlassDecorator(
        borderRadius: BorderRadius.circular(999),
        opacity: design.glassOpacityContainer,
        blur: design.glassBlur / 2, // 덜 강한 블러 적용
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          onSubmitted: widget.onSubmitted,
          onChanged: widget.onChanged,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          cursorColor: AppColors.primary,
          style: textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            fillColor: Colors.transparent,
            filled: false,
          ),
        ),
      ),
    );
  }
}
