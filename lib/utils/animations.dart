import 'package:flutter/material.dart';

class AnimationConstants {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve elasticCurve = Curves.elasticOut;
}

class AnimatedContainer extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;

  const AnimatedContainer({
    Key? key,
    required this.child,
    this.duration = AnimationConstants.normal,
    this.curve = AnimationConstants.defaultCurve,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              width: width,
              height: height,
              padding: padding,
              margin: margin,
              decoration: decoration,
              child: this.child,
            ),
          ),
        );
      },
    );
  }
}
