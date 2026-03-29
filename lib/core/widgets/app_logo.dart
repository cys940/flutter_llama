import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 앱의 브랜드 아이덴티티를 나타내는 공통 로고 위젯입니다.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 40,
    this.showText = false,
    this.animate = true,
    this.textColor,
    this.opacity = 1.0,
  });

  final double size;
  final bool showText;
  final bool animate;
  final Color? textColor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    Widget logo = Opacity(
      opacity: opacity,
      child: Image.asset(
        'assets/images/digital_curator_logo.png',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );

    if (animate) {
      logo = logo.animate()
          .fadeIn(duration: 800.ms)
          .scale(
            duration: 800.ms, 
            begin: const Offset(0.8, 0.8), 
            curve: Curves.easeOutBack,
          )
          .then()
          // 지속적으로 떠다니는(Floating) 효과
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(begin: -2.0, end: 2.0, duration: 2.seconds, curve: Curves.easeInOutSine)
          // 주기적인 반짝임(Shimmer) 효과
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
            duration: 3.seconds, 
            delay: 5.seconds, 
            color: Colors.white.withValues(alpha: 0.1),
          );
    }

    if (!showText) return logo;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logo,
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Digital Curator',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor ?? const Color(0xFFDEE5FF),
                fontWeight: FontWeight.w900,
                fontFamily: 'Plus Jakarta Sans',
                letterSpacing: -0.5,
                height: 1.1,
              ),
            ),
            Text(
              'LOCAL AI INTELLIGENCE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: (textColor ?? Colors.white).withValues(alpha: 0.5),
                fontSize: 8,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
