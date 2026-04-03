import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 앱의 브랜드 아이덴티티를 나타내는 공통 로고 위젯입니다.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 40,
    this.showText = false,
    this.useInternalAnimation = true,
    this.textColor,
    this.opacity = 1.0,
  });

  final double size;
  final bool showText;
  final bool useInternalAnimation;
  final Color? textColor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    Widget logoBody = Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (textColor ?? const Color(0xFF4D7CFF)).withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Image.asset(
          'assets/images/digital_curator_logo.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );

    Widget logo = Opacity(
      opacity: opacity,
      child: logoBody,
    );

    if (useInternalAnimation) {
      logo = logo.animate()
          .fadeIn(duration: 800.ms)
          .scale(
            duration: 800.ms, 
            begin: const Offset(0.8, 0.8), 
            curve: Curves.easeOutBack,
          )
          .then()
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(begin: -2.0, end: 2.0, duration: 2.seconds, curve: Curves.easeInOutSine)
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
            duration: 3.seconds, 
            delay: 5.seconds, 
            color: Colors.white.withOpacity(0.1),
          );
    }

    if (!showText) return logo;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        logo,
        const SizedBox(width: 16),
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
                letterSpacing: -0.8,
                height: 1.0,
                fontSize: size * 0.45,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'LOCAL AI INTELLIGENCE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: (textColor ?? Colors.white).withOpacity(0.4),
                fontSize: size * 0.22,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
