import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final double opacity;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GlassCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.blur = 10,
    this.opacity = 0.1,
    this.color,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              (color ?? Colors.white).withOpacity(opacity),
              (color ?? Colors.white).withOpacity(opacity * 0.5),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Duration duration;

  const HoverCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: widget.duration,
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.05 : 1.0)
          ..rotateZ(_isHovered ? 0.01 : 0.0),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color:
                      AppColors.primaryBlue.withOpacity(_isHovered ? 0.3 : 0.1),
                  blurRadius: _isHovered ? 20 : 10,
                  spreadRadius: _isHovered ? 2 : 0,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _isHovered
                    ? [
                        AppColors.primaryBlue.withOpacity(0.1),
                        AppColors.primaryPurple.withOpacity(0.1),
                      ]
                    : [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.02),
                      ],
              ),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
