import 'package:flutter/material.dart';

class AppAnimations {
  AppAnimations._();

  // Durations
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration slower = Duration(milliseconds: 900);
  static const Duration countUp = Duration(milliseconds: 1500);

  // Curves
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeIn = Curves.easeIn;
  static const Curve elasticOut = Curves.elasticOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve easeOutQuart = Curves.easeOutQuart;

  // Stagger delays
  static Duration staggerDelay(int index) => Duration(milliseconds: index * 100);

  // Hover scale
  static const double hoverScale = 1.05;
  static const double pressScale = 0.95;

  // Opacity values
  static const double hoverOpacity = 1.0;
  static const double normalOpacity = 0.8;
}

/// Default animation builder for fade-in with slide-up
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset slideOffset;
  final VoidCallback? onComplete;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = AppAnimations.medium,
    this.delay = Duration.zero,
    this.slideOffset = const Offset(0, 30),
    this.onComplete,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.easeOutCubic,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.easeOutCubic,
      ),
    );

    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward().then((_) {
          widget.onComplete?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Scale-in animation widget
class ScaleInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double beginScale;
  final VoidCallback? onComplete;

  const ScaleInAnimation({
    super.key,
    required this.child,
    this.duration = AppAnimations.medium,
    this.delay = Duration.zero,
    this.beginScale = 0.8,
    this.onComplete,
  });

  @override
  State<ScaleInAnimation> createState() => _ScaleInAnimationState();
}

class _ScaleInAnimationState extends State<ScaleInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: widget.beginScale, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AppAnimations.easeOut,
      ),
    );

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward().then((_) {
          widget.onComplete?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}
