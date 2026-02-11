import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:portfolio/utils/app_animations.dart';

/// A widget that triggers animations only when it becomes visible in the viewport.
/// This improves performance by not animating off-screen content.
///
/// Usage:
/// ```dart
/// ViewportAnimatedBuilder(
///   child: MyWidget(),
///   builder: (context, child, animation) {
///     return Opacity(
///       opacity: animation,
///       child: Transform.translate(
///         offset: Offset(0, 50 * (1 - animation)),
///         child: child,
///       ),
///     );
///   },
/// )
/// ```
class ViewportAnimatedBuilder extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, Widget child, double animation)
  builder;
  final double visibleFraction;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool repeat;

  const ViewportAnimatedBuilder({
    super.key,
    required this.child,
    required this.builder,
    this.visibleFraction = 0.2,
    this.duration = AppAnimations.medium,
    this.delay = Duration.zero,
    this.curve = Curves.easeOut,
    this.repeat = false,
  });

  @override
  State<ViewportAnimatedBuilder> createState() =>
      _ViewportAnimatedBuilderState();
}

class _ViewportAnimatedBuilderState extends State<ViewportAnimatedBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= widget.visibleFraction) {
      if (!_hasAnimated || widget.repeat) {
        Future.delayed(widget.delay, () {
          if (mounted) {
            _controller.forward();
            _hasAnimated = true;
          }
        });
      }
    } else if (widget.repeat && info.visibleFraction == 0) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? ValueKey(hashCode),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return widget.builder(
            context,
            child!,
            widget.curve.transform(_controller.value),
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// A convenience widget for fade-in animations that trigger on viewport visibility
class ViewportFadeIn extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double visibleFraction;
  final double beginOpacity;
  final Offset slideOffset;

  const ViewportFadeIn({
    super.key,
    required this.child,
    this.duration = AppAnimations.medium,
    this.delay = Duration.zero,
    this.visibleFraction = 0.2,
    this.beginOpacity = 0.0,
    this.slideOffset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ViewportAnimatedBuilder(
      duration: duration,
      delay: delay,
      visibleFraction: visibleFraction,
      builder: (context, child, animation) {
        return Opacity(
          opacity: beginOpacity + (1.0 - beginOpacity) * animation,
          child: Transform.translate(
            offset: Offset(
              slideOffset.dx * (1 - animation),
              slideOffset.dy * (1 - animation),
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// A convenience widget for slide-up animations that trigger on viewport visibility
class ViewportSlideUp extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double visibleFraction;
  final double beginOffset;

  const ViewportSlideUp({
    super.key,
    required this.child,
    this.duration = AppAnimations.medium,
    this.delay = Duration.zero,
    this.visibleFraction = 0.2,
    this.beginOffset = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ViewportAnimatedBuilder(
      duration: duration,
      delay: delay,
      visibleFraction: visibleFraction,
      builder: (context, child, animation) {
        return Transform.translate(
          offset: Offset(0, beginOffset * (1 - animation)),
          child: Opacity(opacity: animation, child: child),
        );
      },
      child: child,
    );
  }
}

/// A staggered animation wrapper for lists that animates children sequentially
/// when they become visible
class ViewportStaggeredList extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration staggerDelay;
  final double visibleFraction;
  final AxisDirection direction;

  const ViewportStaggeredList({
    super.key,
    required this.children,
    this.duration = AppAnimations.medium,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.visibleFraction = 0.1,
    this.direction = AxisDirection.down,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return ViewportFadeIn(
          delay: Duration(milliseconds: staggerDelay.inMilliseconds * index),
          duration: duration,
          visibleFraction: visibleFraction,
          slideOffset: direction == AxisDirection.down
              ? const Offset(0, 30)
              : const Offset(30, 0),
          child: child,
        );
      }).toList(),
    );
  }
}
