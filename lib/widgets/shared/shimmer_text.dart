import 'package:flutter/material.dart';
import 'package:portfolio/utils/app_colors.dart';

/// A text widget with a container sweep effect on hover.
/// On hover, a container slides in from left to right and the text
/// changes to background color only after the sweep completes.
class ShimmerText extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Duration sweepDuration;
  final Color sweepColor;

  const ShimmerText({
    super.key,
    required this.text,
    required this.textStyle,
    this.sweepDuration = const Duration(milliseconds: 500),
    this.sweepColor = AppColors.primary,
  });

  @override
  State<ShimmerText> createState() => _ShimmerTextState();
}

class _ShimmerTextState extends State<ShimmerText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.sweepDuration,
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _curvedAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: _ShimmerPainter(
              sweepColor: widget.sweepColor,
              progress: _curvedAnimation.value,
            ),
            child: Text(
              widget.text,
              style: widget.textStyle.copyWith(
                color: _curvedAnimation.value >= 0.99
                    ? AppColors.background
                    : widget.textStyle.color,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ShimmerPainter extends CustomPainter {
  final Color sweepColor;
  final double progress;

  _ShimmerPainter({
    required this.sweepColor,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate sweep position
    final sweepLeft = -size.width * (1 - progress);

    // Draw the sweep container
    final sweepRect = Rect.fromLTWH(
      sweepLeft,
      0,
      size.width,
      size.height,
    );

    canvas.drawRect(sweepRect, Paint()..color = sweepColor);
  }

  @override
  bool shouldRepaint(covariant _ShimmerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.sweepColor != sweepColor;
  }
}
