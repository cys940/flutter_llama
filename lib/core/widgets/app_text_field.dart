import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_sizes.dart';
import '../theme/app_design_system.dart';
import '../theme/animation_constants.dart';
import '../utils/responsive_helper.dart';
import 'design_decorators.dart';

/// 앱 전체에서 사용되는 반응형 텍스트 필드 위젯입니다. (Concept A: Editorial Curator)
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.onSubmitted,
    this.autofocus = false,
    this.maxLines = 1,
    this.onSend,
  });

  final TextEditingController? controller;
  final String? hintText;
  final bool autofocus;
  final int maxLines;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSend;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final design = context.design;
    final double fontSize = context.responsive(14.0, tablet: 16.0);
    final double padding = context.responsive(AppSizes.s, tablet: AppSizes.m);
    final borderRadius = BorderRadius.circular(32);

    return GlowDecorator(
      glowColor: _isFocused ? design.glowColor : Colors.transparent,
      borderRadius: borderRadius,
      blur: 24,
      spread: 2,
      child: GlassDecorator(
        borderRadius: borderRadius,
        opacity: design.glassOpacity,
        blur: design.glassBlur,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: null, // No-Line Rule: Physical borders removed
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  LucideIcons.sparkles,
                  size: 18,
                  color: _isFocused
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  onSubmitted: widget.onSubmitted,
                  autofocus: widget.autofocus,
                  maxLines: widget.maxLines,
                  cursorColor: colorScheme.primary,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      fontSize: fontSize,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: padding + 6,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: widget.onSend ??
                      () => widget.onSubmitted
                          ?.call(widget.controller?.text ?? ''),
                  child: AnimatedContainer(
                    duration: AnimationConstants.fast,
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: design.primaryGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        if (_isFocused)
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.arrowUp,
                      color: colorScheme.onPrimary,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
